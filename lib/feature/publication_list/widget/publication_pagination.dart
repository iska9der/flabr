import 'package:flutter/material.dart';

import '../../../presentation/extension/extension.dart';

/// Переключатель страниц с сокращением недоступных диапазонов
class PublicationPagination extends StatefulWidget {
  const PublicationPagination({
    super.key,
    required this.currentPage,
    required this.pagesCount,
    required this.onPageSelected,
  });

  final int currentPage;
  final int pagesCount;
  final ValueChanged<int> onPageSelected;

  @override
  State<PublicationPagination> createState() => _PublicationPaginationState();
}

class _PublicationPaginationState extends State<PublicationPagination> {
  static const double _itemExtent = 48;
  static const double _itemSpacing = 4;

  final ScrollController _scrollController = ScrollController();

  double? _viewportWidth;
  int? _positionedPage;

  List<int?> get _items {
    final visiblePages = <int>{
      1,
      2,
      widget.pagesCount - 1,
      widget.pagesCount,
      for (
        int page = widget.currentPage - 2;
        page <= widget.currentPage + 2;
        page++
      )
        page,
    }.where((page) => page >= 1 && page <= widget.pagesCount).toList()..sort();

    final items = <int?>[];
    for (int index = 0; index < visiblePages.length; index++) {
      if (index > 0 && visiblePages[index] - visiblePages[index - 1] > 1) {
        items.add(null);
      }
      items.add(visiblePages[index]);
    }

    return items;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scheduleCurrentPagePosition(
    List<int?> items,
    double viewportWidth,
  ) {
    if (_positionedPage == widget.currentPage &&
        _viewportWidth == viewportWidth) {
      return;
    }

    _positionedPage = widget.currentPage;
    _viewportWidth = viewportWidth;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) {
        return;
      }

      final currentIndex = items.indexOf(widget.currentPage);
      final currentCenter =
          currentIndex * (_itemExtent + _itemSpacing) + _itemExtent / 2;
      final target = (currentCenter - viewportWidth / 2).clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      );

      _scrollController.jumpTo(target);
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = _items;

    return Padding(
      padding: const .symmetric(horizontal: 8, vertical: 12),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Предыдущая страница',
            onPressed: widget.currentPage > 1
                ? () => widget.onPageSelected(widget.currentPage - 1)
                : null,
            icon: const Icon(Icons.chevron_left_rounded),
          ),
          const SizedBox(width: _itemSpacing),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                _scheduleCurrentPagePosition(items, constraints.maxWidth);

                return SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: .horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: Row(
                      mainAxisAlignment: .center,
                      spacing: _itemSpacing,
                      children: [
                        for (final (index, page) in items.indexed)
                          if (page == null)
                            SizedBox.square(
                              key: ValueKey('pagination_gap_$index'),
                              dimension: _itemExtent,
                              child: const Center(child: Text('…')),
                            )
                          else
                            _PaginationPageButton(
                              page: page,
                              isSelected: page == widget.currentPage,
                              onPressed: () => widget.onPageSelected(page),
                            ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: _itemSpacing),
          IconButton(
            tooltip: 'Следующая страница',
            onPressed: widget.currentPage < widget.pagesCount
                ? () => widget.onPageSelected(widget.currentPage + 1)
                : null,
            icon: const Icon(Icons.chevron_right_rounded),
          ),
        ],
      ),
    );
  }
}

class _PaginationPageButton extends StatelessWidget {
  const _PaginationPageButton({
    required this.page,
    required this.isSelected,
    required this.onPressed,
  });

  final int page;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final child = Text('$page');

    return SizedBox.square(
      dimension: _PublicationPaginationState._itemExtent,
      child: Semantics(
        selected: isSelected,
        child: isSelected
            ? OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: context.theme.colorScheme.primary,
                  padding: .zero,
                  side: BorderSide(color: context.theme.colorScheme.primary),
                ),
                onPressed: () {},
                child: child,
              )
            : TextButton(
                style: TextButton.styleFrom(padding: .zero),
                onPressed: onPressed,
                child: child,
              ),
      ),
    );
  }
}
