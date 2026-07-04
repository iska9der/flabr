import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../../bloc/publication/comment_list_cubit.dart';
import '../../../../data/model/comment/comment.dart';
import '../../../extension/extension.dart';
import '../../../widget/comment/comment.dart';
import '../../../widget/enhancement/card.dart';
import '../../../widget/enhancement/progress_indicator.dart';
import '../../../widget/error_widget.dart';
import '../../../widget/user_text_button.dart';
import '../model/scroll_history.dart';
import 'comment_parent_widget.dart';

class CommentListView extends StatefulWidget {
  const CommentListView({
    super.key,
    this.initialId,
  });

  /// Идентификатор комментария, к которому надо проскроллить
  final String? initialId;

  @override
  State<CommentListView> createState() => _CommentListViewState();
}

class _CommentListViewState extends State<CommentListView> {
  @override
  void initState() {
    super.initState();

    _fetch();
  }

  void _fetch() {
    unawaited(context.read<CommentListCubit>().fetch());
  }

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
            if (state.status == .initial || state.status == .loading) {
              return const CircleIndicator();
            }

            if (state.status == .failure) {
              return Center(
                child: AppError(
                  message: state.error,
                  onRetry: _fetch,
                ),
              );
            }

            final comments = state.list.comments;
            if (comments.isEmpty) {
              return const Center(child: Text('Нет комментариев'));
            }

            return SelectionArea(
              child: CommentTreeWidget(
                comments: comments,
                initialId: widget.initialId,
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Рекурсивный виджет для отрисовки дерева комментариев
class CommentTreeWidget extends StatefulWidget {
  const CommentTreeWidget({
    super.key,
    required this.comments,
    this.initialId,
  });

  final List<Comment> comments;

  /// Идентификатор комментария, к которому надо проскроллить
  final String? initialId;

  @override
  State<CommentTreeWidget> createState() => _CommentTreeWidgetState();
}

class _CommentTreeWidgetState extends State<CommentTreeWidget> {
  static const _scrollDuration = Duration(milliseconds: 300);
  static const _scrollAlignment = 0.08;

  late final ItemScrollController _itemScrollController;
  late final ItemPositionsListener _itemPositionsListener;
  late Set<String> _expandedCommentIds;

  // Плоский список комментариев, которые сейчас должны быть доступны скроллу
  late List<Comment> _visibleComments;

  final _history = CommentScrollHistory();

  // Последний обработанный верхний элемент, чтобы не пересчитывать историю без смещения списка
  int? _lastFirstVisibleIndex;

  // CommentId, для которого initial scroll уже выполнен или покрыт initialScrollIndex
  String? _handledInitialId;

  // Флаг активного отложенного перехода к initialId
  var _isInitialScrollScheduled = false;

  @override
  void initState() {
    super.initState();

    _itemScrollController = ItemScrollController();
    _itemPositionsListener = ItemPositionsListener.create();

    // По видимым позициям скрываем кнопку возврата, когда пользователь уже дошел до сохраненного комментария
    _itemPositionsListener.itemPositions.addListener(_onItemPositionsChanged);
    _expandedCommentIds = _collectExpandableCommentIds(widget.comments);
    _refreshVisibleComments();
    _markInitialScrollHandledByInitialIndex();
  }

  @override
  void didUpdateWidget(covariant CommentTreeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.comments != widget.comments) {
      _syncExpandedComments(oldWidget.comments);
      _refreshVisibleComments();
    }

    if (oldWidget.initialId != widget.initialId) {
      _scheduleInitialScroll();
    }
  }

  @override
  void dispose() {
    _itemPositionsListener.itemPositions.removeListener(
      _onItemPositionsChanged,
    );
    _history.close();

    super.dispose();
  }

  Set<String> _collectExpandableCommentIds(List<Comment> comments) {
    final ids = <String>{};

    void collect(Comment comment) {
      if (comment.children.isEmpty) {
        return;
      }

      ids.add(comment.id);
      comment.children.forEach(collect);
    }

    comments.forEach(collect);

    return ids;
  }

  void _syncExpandedComments(List<Comment> previousComments) {
    final currentCommentIds = _collectExpandableCommentIds(widget.comments);
    final previousCommentIds = _collectExpandableCommentIds(previousComments);

    // Сохраняем пользовательские раскрытия после обновления дерева, но новые ветки показываем раскрытыми
    _expandedCommentIds = {
      ..._expandedCommentIds.where(currentCommentIds.contains),
      ...currentCommentIds.difference(previousCommentIds),
    };
  }

  void _refreshVisibleComments() {
    _visibleComments = _buildVisibleComments();
  }

  List<Comment> _buildVisibleComments() {
    final result = <Comment>[];

    void collect(Comment comment) {
      result.add(comment);

      if (!_expandedCommentIds.contains(comment.id)) {
        return;
      }

      comment.children.forEach(collect);
    }

    widget.comments.forEach(collect);

    return result;
  }

  void _toggle(Comment comment) {
    setState(() {
      if (!_expandedCommentIds.remove(comment.id)) {
        _expandedCommentIds.add(comment.id);
      }

      _refreshVisibleComments();
    });
  }

  void _markInitialScrollHandledByInitialIndex() {
    final initialId = widget.initialId;
    if (initialId == null) {
      return;
    }

    final initialIndex = _indexOfComment(commentId: initialId);
    if (initialIndex != null) {
      _handledInitialId = initialId;
    }
  }

  void _scheduleInitialScroll() {
    final initialId = widget.initialId;
    if (initialId == null ||
        initialId == _handledInitialId ||
        _isInitialScrollScheduled) {
      return;
    }

    _isInitialScrollScheduled = true;

    // Переход к элементу возможен только после первого layout списка
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isInitialScrollScheduled = false;
      if (!mounted) {
        return;
      }

      if (widget.initialId != initialId) {
        _scheduleInitialScroll();
        return;
      }

      _moveToInitialComment(initialId);
    });
  }

  void _moveToInitialComment(String initialId) {
    if (!_itemScrollController.isAttached) {
      _scheduleInitialScroll();
      return;
    }

    // Перед переходом раскрываем всех родителей, иначе элемента не будет в плоском списке
    final parentIds = _parentIdsFor(initialId);
    if (parentIds == null) {
      return;
    }

    if (!_expandedCommentIds.containsAll(parentIds)) {
      setState(() {
        _expandedCommentIds.addAll(parentIds);
        _refreshVisibleComments();
      });

      _scheduleInitialScroll();
      return;
    }

    final index = _indexOfComment(commentId: initialId);
    if (index == null) {
      return;
    }

    _handledInitialId = initialId;
    _scrollToIndex(index);
  }

  List<String>? _parentIdsFor(String targetCommentId) {
    List<String>? find(List<Comment> comments, List<String> parentIds) {
      for (final comment in comments) {
        if (comment.id == targetCommentId) {
          return parentIds;
        }

        final result = find(comment.children, [...parentIds, comment.id]);
        if (result != null) {
          return result;
        }
      }

      return null;
    }

    return find(widget.comments, []);
  }

  int? _indexOfComment({required String commentId}) {
    final index = _visibleComments.indexWhere(
      (comment) => comment.id == commentId,
    );

    if (index == -1) {
      return null;
    }

    return index;
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

  void _saveToHistory({
    required Comment comment,
    required int index,
    required int parentIndex,
  }) {
    // Если родительский комментарий рядом, кнопку возврата не показываем
    if (index - parentIndex <= 4) {
      return;
    }

    _history.push(comment.id);
  }

  void _onItemPositionsChanged() {
    final firstVisibleIndex = _firstVisibleIndex();
    if (firstVisibleIndex == null ||
        firstVisibleIndex == _lastFirstVisibleIndex) {
      return;
    }

    _lastFirstVisibleIndex = firstVisibleIndex;

    // Сдвиг верхнего элемента означает, что часть сохраненных позиций могла стать неактуальной
    _removeScrolledHistory(firstVisibleIndex);
  }

  void _removeScrolledHistory(int firstVisibleIndex) {
    _history.removeVisibleBefore(
      firstVisibleIndex: firstVisibleIndex,
      indexOf: (commentId) {
        return _visibleComments.indexWhere(
          (comment) => comment.id == commentId,
        );
      },
    );
  }

  int? _firstVisibleIndex() {
    final positions = _itemPositionsListener.itemPositions.value;
    if (positions.isEmpty) {
      return null;
    }

    final visiblePositions = positions.where((position) {
      return position.itemTrailingEdge > 0 && position.itemLeadingEdge < 1;
    });

    if (visiblePositions.isEmpty) {
      return null;
    }

    return visiblePositions.reduce((a, b) => a.index < b.index ? a : b).index;
  }

  void _moveToParent({
    required Comment comment,
    required int index,
  }) {
    final parent = comment.parent;
    if (parent == null) {
      return;
    }

    final parentIndex = _indexOfComment(commentId: parent.id);
    if (parentIndex == null) {
      return;
    }

    _saveToHistory(comment: comment, index: index, parentIndex: parentIndex);
    _scrollToIndex(parentIndex);
  }

  void _returnToHistoryComment() {
    // История хранит commentId, поэтому индекс пересчитывается по актуальному списку
    final commentId = _history.pop();
    final index = _indexOfComment(commentId: commentId);
    if (index == null) {
      return;
    }

    _scrollToIndex(index);
  }

  void _scrollToIndex(int index) {
    _itemScrollController.scrollTo(
      index: index,
      duration: _scrollDuration,
      alignment: _scrollAlignment,
    );
  }

  int _initialScrollIndex() {
    final initialId = widget.initialId;
    if (initialId == null) {
      return 0;
    }

    return _indexOfComment(commentId: initialId) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ScrollablePositionedList.builder(
          itemScrollController: _itemScrollController,
          itemPositionsListener: _itemPositionsListener,
          initialScrollIndex: _initialScrollIndex(),
          initialAlignment: _scrollAlignment,
          padding: const .fromLTRB(4, 4, 4, 16),
          itemCount: _visibleComments.length,
          itemBuilder: (context, index) {
            final comment = _visibleComments[index];
            final isExpanded =
                comment.children.isEmpty ||
                _expandedCommentIds.contains(comment.id);

            return _CommentTreeItem(
              comment: comment,
              isExpanded: isExpanded,
              hasChildren: comment.children.isNotEmpty,
              topPadding: _topPadding(comment: comment, index: index),
              onToggle: () => _toggle(comment),
              onParentTapped: () => _moveToParent(
                comment: comment,
                index: index,
              ),
            );
          },
        ),
        _HistoryButton(
          history: _history,
          onPressed: _returnToHistoryComment,
        ),
      ],
    );
  }
}

class _HistoryButton extends StatelessWidget {
  const _HistoryButton({
    required this.history,
    required this.onPressed,
  });

  final CommentScrollHistory history;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: .bottomRight,
      child: Padding(
        padding: const .all(8.0),
        child: StreamBuilder<CommentScrollHistory>(
          initialData: history,
          stream: history.stream,
          builder: (context, snapshot) {
            final data = snapshot.data;
            final isEmpty = data == null || data.isEmpty;

            return IgnorePointer(
              ignoring: isEmpty,
              child: AnimatedOpacity(
                opacity: isEmpty ? 0 : 1,
                duration: const Duration(milliseconds: 200),
                child: FloatingActionButton(
                  heroTag: null,
                  onPressed: onPressed,
                  child: const Icon(Icons.history_rounded),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CommentTreeItem extends StatelessWidget {
  const _CommentTreeItem({
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
