import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../bloc/publication/comment_list_cubit.dart';
import '../../../../data/model/comment/comment.dart';
import '../../../../data/model/offset_history.dart';
import '../../../extension/extension.dart';
import '../../../widget/comment/comment.dart';
import '../../../widget/enhancement/card.dart';
import '../../../widget/enhancement/progress_indicator.dart';
import '../../../widget/error_widget.dart';
import '../../../widget/user_text_button.dart';
import 'comment_parent_widget.dart';

class CommentListView extends StatelessWidget {
  const CommentListView({super.key});

  void fetch(BuildContext context) => context.read<CommentListCubit>().fetch();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AutoLeadingButton(),
        title: const Text('Комментарии'),
      ),
      body: SafeArea(
        child: BlocBuilder<CommentListCubit, CommentListState>(
          builder: (context, state) {
            if (state.status == .initial) {
              fetch(context);

              return const CircleIndicator();
            }

            if (state.status == .loading) {
              return const CircleIndicator();
            }

            if (state.status == .failure) {
              return Center(
                child: AppError(
                  message: state.error,
                  onRetry: () => fetch(context),
                ),
              );
            }

            final comments = state.list.comments;
            if (comments.isEmpty) {
              return const Center(child: Text('Нет комментариев'));
            }

            return SelectionArea(child: CommentTreeWidget(comments));
          },
        ),
      ),
    );
  }
}

/// Рекурсивный виджет для отрисовки дерева комментариев
class CommentTreeWidget extends StatefulWidget {
  const CommentTreeWidget(this.comments, {super.key});

  final List<Comment> comments;

  @override
  State<CommentTreeWidget> createState() => _CommentTreeWidgetState();
}

class _CommentTreeWidgetState extends State<CommentTreeWidget> {
  late final ScrollController scrollController;
  late Set<String> expandedCommentIds;

  final _parentKeys = <String, GlobalKey>{};
  final _history = OffsetHistory();

  final scrollDuration = const Duration(milliseconds: 300);
  final scrollCurve = Curves.linear;

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();
    expandedCommentIds = _collectExpandableCommentIds(widget.comments);
  }

  @override
  void didUpdateWidget(covariant CommentTreeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.comments == widget.comments) {
      return;
    }

    final newCommentIds = _collectExpandableCommentIds(widget.comments);
    final oldCommentIds = _collectExpandableCommentIds(oldWidget.comments);

    expandedCommentIds = {
      ...expandedCommentIds.where(newCommentIds.contains),
      ...newCommentIds.difference(oldCommentIds),
    };
  }

  @override
  void dispose() {
    _history.close();
    scrollController.dispose();

    super.dispose();
  }

  Set<String> _collectExpandableCommentIds(List<Comment> comments) {
    final ids = <String>{};

    void collect(Comment comment) {
      if (comment.children.isNotEmpty) {
        ids.add(comment.id);
        comment.children.forEach(collect);
      }
    }

    comments.forEach(collect);

    return ids;
  }

  GlobalKey? _keyFor(Comment comment) {
    if (comment.childrenRaw.isNotEmpty) {
      return _parentKeys.putIfAbsent(comment.id, GlobalKey.new);
    }

    return null;
  }

  List<Comment> _visibleComments() {
    final visibleComments = <Comment>[];

    void collect(Comment comment) {
      visibleComments.add(comment);

      if (!expandedCommentIds.contains(comment.id)) {
        return;
      }

      comment.children.forEach(collect);
    }

    widget.comments.forEach(collect);

    return visibleComments;
  }

  void _toggle(Comment comment) {
    setState(() {
      if (!expandedCommentIds.remove(comment.id)) {
        expandedCommentIds.add(comment.id);
      }
    });
  }

  double _topPadding({required Comment comment, required int index}) {
    if (index == 0) {
      return 0;
    }

    if (comment.parentId.isNotEmpty) {
      return 2;
    }

    return 8;
  }

  /// добавляем в историю текущий оффсет скролла
  void _saveToHistory({required String id, required String parentId}) {
    final key = _parentKeys[parentId];
    final box = key?.currentContext?.findRenderObject();
    if (box != null) {
      final double yPosition = (box as RenderBox).localToGlobal(.zero).dy;

      /// если родительский комментарий не очень далеко - не сохраняем в историю
      if (yPosition > -400) {
        return;
      }
    }

    _history.push(id, scrollController.offset);
  }

  /// скролл к родительскому комментарию
  void _moveToParent(String parentId) async {
    final key = _parentKeys[parentId];
    if (key == null) {
      return;
    }

    final context = key.currentContext;

    /// если не найден контекст - значит необходимый элемент отлетел в мусорку,
    /// поэтому мы скроллимся вверх пока он снова не создатся
    if (context == null) {
      final shift = scrollController.offset < 400
          ? scrollController.offset
          : 400;
      await scrollController.animateTo(
        scrollController.offset - shift,
        duration: const .new(milliseconds: 50),
        curve: scrollCurve,
      );
      return _moveToParent(parentId);
    }

    Scrollable.ensureVisible(
      context,
      duration: scrollDuration,
      curve: scrollCurve,
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleComments = _visibleComments();

    return NotificationListener<UserScrollNotification>(
      onNotification: (notification) {
        /// удаляем из истории оффсет, если мы его проскроллили
        final id = _history.lessThan(notification.metrics.pixels);
        if (id != null) {
          _history.remove(id);
        }

        return false;
      },
      child: Stack(
        children: [
          CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverPadding(
                padding: const .fromLTRB(4, 4, 4, 16),
                sliver: SliverList.builder(
                  itemCount: visibleComments.length,
                  itemBuilder: (context, index) {
                    final comment = visibleComments[index];

                    return _CommentTreeItem(
                      key: _keyFor(comment),
                      comment: comment,
                      isExpanded:
                          comment.children.isEmpty ||
                          expandedCommentIds.contains(comment.id),
                      hasChildren: comment.children.isNotEmpty,
                      topPadding: _topPadding(comment: comment, index: index),
                      onToggle: () => _toggle(comment),
                      onParentTapped: () {
                        final parent = comment.parent;
                        if (parent == null) {
                          return;
                        }

                        _saveToHistory(id: comment.id, parentId: parent.id);

                        _moveToParent(comment.parentId);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          Align(
            alignment: .bottomRight,
            child: Padding(
              padding: const .all(8.0),
              child: StreamBuilder(
                stream: _history.stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox();
                  }

                  final history = snapshot.data!;

                  return IgnorePointer(
                    ignoring: history.isEmpty,
                    child: AnimatedOpacity(
                      opacity: history.isEmpty ? 0 : 1,
                      duration: const Duration(milliseconds: 200),
                      child: FloatingActionButton(
                        heroTag: null,
                        mini: true,
                        onPressed: () => scrollController.animateTo(
                          history.pop(),
                          duration: scrollDuration,
                          curve: scrollCurve,
                        ),
                        child: const Icon(Icons.history_rounded),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentTreeItem extends StatelessWidget {
  const _CommentTreeItem({
    super.key,
    required this.comment,
    required this.isExpanded,
    required this.hasChildren,
    required this.topPadding,
    required this.onToggle,
    required this.onParentTapped,
  });

  final Comment comment;
  final bool isExpanded;
  final bool hasChildren;
  final double topPadding;
  final VoidCallback onToggle;
  final VoidCallback onParentTapped;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final authorColor = switch (comment.isPostAuthor) {
      true => theme.colors.author,
      false => null,
    };

    return Padding(
      padding: .only(top: topPadding),
      child: FlabrCard(
        margin: .zero,
        padding: .zero,
        color: authorColor,
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            Row(
              children: [
                Padding(
                  padding: const .only(left: 8),
                  child: UserTextButton(
                    comment.author,
                    subtitle: Text(
                      DateFormat.yMd().add_jm().format(comment.publishedAt),
                      style: theme.textTheme.labelSmall!.copyWith(
                        color: theme.colors.textSecondary,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Visibility(
                  visible: hasChildren,
                  maintainAnimation: true,
                  maintainSize: true,
                  maintainState: true,
                  child: ExpandIcon(
                    key: GlobalObjectKey(comment),
                    isExpanded: isExpanded,
                    onPressed: (_) => onToggle(),
                  ),
                ),
              ],
            ),
            if (isExpanded)
              Column(
                crossAxisAlignment: .stretch,
                children: [
                  if (comment.parent != null)
                    CommentParent(
                      model: comment.parent!,
                      onParentTapped: onParentTapped,
                    ),
                  CommentWidget(comment),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
