import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../bloc/publication/publication_bookmarks_bloc.dart';
import '../../../presentation/extension/extension.dart';
import '../../../presentation/page/publications/widget/card/card.dart';
import '../../../presentation/widget/enhancement/progress_indicator.dart';
import '../../scroll/scroll.dart';
import '../cubit/publication_list_cubit.dart';

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

    return MultiBlocListener(
      listeners: [
        BlocListener<ListCubit, ListState>(
          listenWhen: (previous, current) =>
              previous.page != 1 &&
              current.status == PublicationListStatus.failure,
          listener: (_, state) => context.showSnack(content: Text(state.error)),
        ),

        /// Синхронизация закладок при успешной загрузке публикаций
        BlocListener<ListCubit, ListState>(
          listenWhen: (_, current) =>
              current.status == PublicationListStatus.success,
          listener: (context, state) {
            context.read<PublicationBookmarksBloc>().add(
              PublicationBookmarksEvent.updated(
                publications: state.publications,
              ),
            );
          },
        ),
      ],
      child: BlocBuilder<ListCubit, ListState>(
        builder: (context, state) {
          /// При инициализации запрашиваем публикации
          if (state.status == PublicationListStatus.initial) {
            listCubit.fetch();
          }

          /// Нужно ли отобразить виджет загрузки
          final isLoaderShown = switch (state.status) {
            PublicationListStatus.initial => true,
            PublicationListStatus.loading when state.isFirstFetch => true,
            _ => false,
          };

          if (isLoaderShown) {
            return skeletonLoader;
          }

          /// Ошибка при попытке получить статьи.
          /// Ошибку показываем вместо карточек только в случае, если
          /// происходит загрузка первой страницы
          final isErrorShown =
              state.isFirstFetch &&
              state.status == PublicationListStatus.failure;
          if (isErrorShown) {
            return SliverFillRemaining(child: Center(child: Text(state.error)));
          }

          var publications = state.publications;
          if (publications.isEmpty) {
            return const SliverFillRemaining(
              child: Center(child: Text('Ничего нет')),
            );
          }

          int additional = (state.status == PublicationListStatus.loading
              ? 1
              : 0);

          return SliverList.builder(
            itemCount: publications.length + additional,
            itemBuilder: (context, index) {
              if (index < publications.length) {
                final publication = publications[index];

                return PublicationCardWidget(
                  key: Key('publication_card_//${publication.id}'),
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
        children: List.generate(
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
