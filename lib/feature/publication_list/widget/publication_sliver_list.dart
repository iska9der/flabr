import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../bloc/publication/publication_bookmarks_bloc.dart';
import '../../../bloc/settings/settings_cubit.dart';
import '../../../i18n/i18n.dart';
import '../../../presentation/extension/extension.dart';
import '../../../presentation/page/publications/widget/card/card.dart';
import '../../../presentation/widget/enhancement/progress_indicator.dart';
import '../../../presentation/widget/error_widget.dart';
import '../../scroll/scroll.dart';
import '../cubit/publication_list_cubit.dart';
import 'publication_pagination.dart';

class PublicationSliverList<
  ListCubit extends PublicationListCubit<ListState>,
  ListState extends PublicationListState
>
    extends StatelessWidget {
  const PublicationSliverList({
    super.key,
    this.bloc,
    this.showType = false,
  });

  final ListCubit? bloc;

  /// Показывать тип поста в карточках
  final bool showType;

  @override
  Widget build(BuildContext context) {
    final listCubit = bloc ?? context.read<ListCubit>();
    final scrollCubit = context.read<ScrollCubit?>();
    const skeletonLoader = _SkeletonLoader();
    final paginationEnabled = context.select<SettingsCubit, bool>(
      (cubit) => cubit.state.feed.navigationMode == .pagination,
    );

    return MultiBlocListener(
      listeners: [
        BlocListener<ListCubit, ListState>(
          bloc: listCubit,
          listenWhen: (previous, current) =>
              previous.response.refs.isNotEmpty && current.status == .failure,
          listener: (_, state) => context.showSnack(
            content: Text(context.t.errorMessage(state.error)),
          ),
        ),

        /// Синхронизация закладок при успешной загрузке публикаций
        BlocListener<ListCubit, ListState>(
          bloc: listCubit,
          listenWhen: (_, current) => current.status == .success,
          listener: (context, state) {
            context.read<PublicationBookmarksBloc>().add(
              PublicationBookmarksEvent.updated(
                publications: state.response.refs,
              ),
            );
          },
        ),
        BlocListener<SettingsCubit, SettingsState>(
          listenWhen: (previous, current) =>
              previous.feed.navigationMode != current.feed.navigationMode,
          listener: (_, _) {
            listCubit.reset();
            scrollCubit?.animateToTop();
          },
        ),
      ],
      child: BlocBuilder<ListCubit, ListState>(
        bloc: listCubit,
        builder: (context, state) {
          /// При инициализации запрашиваем публикации
          if (state.status == .initial) {
            listCubit.fetch();
          }

          /// При смене страницы список очищается, поэтому skeleton нужен
          /// для загрузки любой страницы в режиме пагинации
          final isLoaderShown =
              state.response.refs.isEmpty &&
              (state.status == .initial || state.status == .loading);

          if (isLoaderShown) {
            return skeletonLoader;
          }

          /// Ошибку показываем вместо карточек, если текущая страница пуста
          final isErrorShown =
              state.response.refs.isEmpty && state.status == .failure;
          if (isErrorShown) {
            return SliverFillRemaining(
              child: Center(
                child: AppError(
                  error: state.error,
                  onRetry: () => listCubit.fetch(),
                ),
              ),
            );
          }

          var publications = state.response.refs;
          if (publications.isEmpty) {
            return SliverFillRemaining(
              child: Center(child: Text(context.t.publication.list.empty)),
            );
          }

          final additional = !paginationEnabled && state.status == .loading
              ? 1
              : 0;
          final list = SliverList.builder(
            itemCount: publications.length + additional,
            itemBuilder: (context, index) {
              if (index < publications.length) {
                final publication = publications[index];

                return PublicationCardWidget(
                  key: Key('publication_card_${publication.id}'),
                  publication,
                  showType: showType,
                );
              }

              Timer(
                scrollCubit?.duration ?? const Duration(milliseconds: 30),
                () => scrollCubit?.animateToBottom(),
              );

              return const SizedBox(
                height: 60,
                child: CircleIndicator.medium(),
              );
            },
          );

          if (!paginationEnabled || state.response.pagesCount <= 1) {
            return list;
          }

          return SliverMainAxisGroup(
            slivers: [
              list,
              SliverToBoxAdapter(
                child: PublicationPagination(
                  currentPage: state.currentPage,
                  pagesCount: state.response.pagesCount,
                  onPageSelected: (page) {
                    listCubit.changePage(page);
                    scrollCubit?.animateToTop();
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SkeletonLoader extends StatelessWidget {
  // ignore: unused_element_parameter
  const _SkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.sliver(
      child: SliverList.list(
        children: .generate(
          2,
          (i) => SkeletonCardWidget(
            authorAlias: 'author alias' * (Random().nextInt(2) + 1),
            title: 'card title' * (Random().nextInt(10) + 1),
            description: 'random card description' * (Random().nextInt(7) + 5),
          ),
        ).toList(),
      ),
    );
  }
}
