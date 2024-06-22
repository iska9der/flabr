import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';

import '../../../../data/model/comment/comment_model.dart';
import '../../../../data/model/offset_history.dart';
import '../../../extension/part.dart';
import '../../../theme/part.dart';
import '../../../widget/comment/comment_widget.dart';
import '../../../widget/enhancement/progress_indicator.dart';
import '../../../widget/user_text_button.dart';
import '../cubit/comment_list_cubit.dart';
import 'comment_parent_widget.dart';

class CommentListView extends StatelessWidget {
  const CommentListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Комментарии'),
      ),
      body: SafeArea(
        child: SelectionArea(
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
                return const Center(
                  child: Text('Нет комментариев'),
                );
              }

              return CommentTreeWidget(comments);
            },
          ),
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
      childrenProvider: (Comment comment) => comment.children,
    )..expandAll();
  }

  @override
  void dispose() {
    _history.close();
    scrollController.dispose();
    treeController.dispose();
    super.dispose();
  }

  void _moveToParent(String id) async {
    final key = _parentKeys[id];
    if (key == null) {
      return;
    }

    final context = key.currentContext;

    /// если не найден контекст - значит необходимый элемент отлетел в мусорку,
    /// поэтому мы скроллимся вверх пока он снова не создатся
    if (context == null) {
      final shift =
          scrollController.offset < 400 ? scrollController.offset : 400;
      await scrollController.animateTo(
        scrollController.offset - shift,
        duration: const Duration(milliseconds: 50),
        curve: scrollCurve,
      );
      return _moveToParent(id);
    }

    Scrollable.ensureVisible(
      context,
      duration: scrollDuration,
      curve: scrollCurve,
    );
  }

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 16),
            nodeBuilder: (BuildContext context, TreeEntry<Comment> entry) {
              final key =
                  entry.node.childrenRaw.isNotEmpty ? GlobalKey() : null;
              if (key != null) {
                _parentKeys[entry.node.id] = key;
              }

              final authorColor = entry.node.isPostAuthor
                  ? Colors.yellowAccent.withOpacity(.12)
                  : Theme.of(context).colorScheme.surface;

              double topPadding = entry.index == 0
                  ? 0
                  : entry.node.parentId.isNotEmpty
                      ? 2
                      : 8;

              return Padding(
                key: key,
                padding: EdgeInsets.only(top: topPadding),
                child: TreeIndentation(
                  entry: entry,
                  guide: const IndentGuide(indent: 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(kBorderRadiusDefault),
                    child: ColoredBox(
                      color: authorColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              UserTextButton(entry.node.author),
                              const Spacer(),
                              ExpandIcon(
                                key: GlobalObjectKey(entry.node),
                                isExpanded: entry.isExpanded,
                                onPressed: (_) =>
                                    treeController.toggleExpansion(entry.node),
                              ),
                            ],
                          ),
                          if (entry.isExpanded)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (entry.node.parent != null)
                                  GestureDetector(
                                    onTap: () {
                                      /// добавляем в историю текущий оффсет скролла
                                      _history.push(
                                        entry.node.id,
                                        scrollController.offset,
                                      );

                                      /// перемещаемся к родительскому комментарию
                                      _moveToParent(entry.node.parentId);
                                    },
                                    child: ParentComment(
                                      parent: entry.node.parent!,
                                    ),
                                  ),
                                CommentWidget(entry.node),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
