import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:intl/intl.dart';

import '../../../../bloc/publication/comment_list_cubit.dart';
import '../../../../data/model/comment/comment.dart';
import '../../../../data/model/offset_history.dart';
import '../../../extension/extension.dart';
import '../../../widget/comment/comment.dart';
import '../../../widget/enhancement/card.dart';
import '../../../widget/enhancement/progress_indicator.dart';
import '../../../widget/user_text_button.dart';
import 'comment_parent_widget.dart';

class CommentListView extends StatelessWidget {
  const CommentListView({super.key});

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
            if (state.status.isInitial) {
              context.read<CommentListCubit>().fetch();
              return const CircleIndicator();
            }

            if (state.status.isLoading) {
              return const CircleIndicator();
            }

            if (state.status.isFailure) {
              return Center(child: Text(state.error));
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
  late final Comment root;
  late final TreeController<Comment> treeController;

  final _parentKeys = <String, GlobalKey>{};
  final _history = OffsetHistory();

  final scrollDuration = const Duration(milliseconds: 300);
  final scrollCurve = Curves.linear;

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();

    root = Comment(id: '0', children: widget.comments);
    treeController = TreeController<Comment>(
      roots: root.children,
      childrenProvider: (comment) => comment.children,
    )..expandAll();
  }

  @override
  void dispose() {
    _history.close();
    scrollController.dispose();
    treeController.dispose();

    super.dispose();
  }

  /// добавляем в историю текущий оффсет скролла
  void _saveToHistory({
    required String id,
    required double offset,
    required String parentId,
  }) {
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
    final theme = context.theme;

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
          TreeView<Comment>(
            treeController: treeController,
            controller: scrollController,
            padding: const .fromLTRB(4, 4, 4, 16),
            nodeBuilder: (BuildContext context, TreeEntry<Comment> entry) {
              final comment = entry.node;

              final key = comment.childrenRaw.isNotEmpty ? GlobalKey() : null;
              if (key != null) {
                _parentKeys[comment.id] = key;
              }

              final authorColor = switch (comment.isPostAuthor) {
                true => theme.colors.author,
                false => null,
              };

              double topPadding = entry.index == 0
                  ? 0
                  : comment.parentId.isNotEmpty
                  ? 2
                  : 8;

              return Padding(
                key: key,
                padding: .only(top: topPadding),

                /// TODO: package deprecated
                /// see: https://pub.dev/packages/flutter_fancy_tree_view
                /// use: https://pub.dev/packages/two_dimensional_scrollables
                child: TreeIndentation(
                  entry: entry,
                  guide: const IndentGuide(indent: 0),
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
                                  DateFormat.yMd().add_jm().format(
                                    comment.publishedAt,
                                  ),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            ExpandIcon(
                              key: GlobalObjectKey(comment),
                              isExpanded: entry.isExpanded,
                              onPressed: (_) => treeController.toggleExpansion(
                                comment,
                              ),
                            ),
                          ],
                        ),
                        if (entry.isExpanded)
                          Column(
                            crossAxisAlignment: .stretch,
                            children: [
                              if (comment.parent != null)
                                CommentParent(
                                  parent: comment.parent!,
                                  onParentTapped: () {
                                    _saveToHistory(
                                      id: comment.id,
                                      offset: scrollController.offset,
                                      parentId: comment.parent!.id,
                                    );

                                    _moveToParent(comment.parentId);
                                  },
                                ),
                              CommentWidget(comment),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomRight,
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
