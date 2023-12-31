import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';

import '../../../../common/model/extension/enum_status.dart';
import '../../../../common/widget/author_widget.dart';
import '../../../../common/widget/comment_widget.dart';
import '../../../../common/widget/enhancement/progress_indicator.dart';
import '../../../../config/constants.dart';
import '../../cubit/comment/comment_list_cubit.dart';
import '../../model/comment/comment_model.dart';

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

  final List<CommentModel> comments;

  @override
  State<CommentTreeWidget> createState() => _CommentTreeWidgetState();
}

class _CommentTreeWidgetState extends State<CommentTreeWidget> {
  late final ScrollController scrollController;
  late final CommentModel root;
  late final TreeController<CommentModel> treeController;

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();
    root = CommentModel(id: '0', children: widget.comments);
    treeController = TreeController<CommentModel>(
      roots: root.children,
      childrenProvider: (CommentModel comment) => comment.children,
    )..expandAll();
  }

  @override
  void dispose() {
    treeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TreeView<CommentModel>(
      treeController: treeController,
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 16),
      nodeBuilder: (BuildContext context, TreeEntry<CommentModel> entry) {
        final authorColor = entry.node.isPostAuthor
            ? Colors.yellowAccent.withOpacity(.12)
            : Theme.of(context).colorScheme.surface;

        double topPadding = entry.index == 0
            ? 0
            : entry.node.parentId.isNotEmpty
                ? 2
                : 8;

        return Padding(
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
                        AuthorWidget(entry.node.author),
                        const Spacer(),
                        ExpandIcon(
                          key: GlobalObjectKey(entry.node),
                          isExpanded: entry.isExpanded,
                          onPressed: (_) =>
                              treeController.toggleExpansion(entry.node),
                        ),
                      ],
                    ),
                    if (entry.isExpanded) CommentWidget(entry.node),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
