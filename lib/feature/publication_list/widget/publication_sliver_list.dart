import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/component/di/di.dart';
import '../../../presentation/page/publications/widget/card/card.dart';
import '../../../presentation/utils/utils.dart';
import '../../../presentation/widget/enhancement/progress_indicator.dart';
import '../../scroll/scroll.dart';
import '../cubit/publication_list_cubit.dart';

class PublicationSliverList<
  ListCubit extends PublicationListCubit<ListState>,
  ListState extends PublicationListState
>
    extends StatelessWidget {
  const PublicationSliverList({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollCubit = context.read<ScrollCubit?>();
    const skeletonLoader = _SkeletonLoader();

    return BlocConsumer<ListCubit, ListState>(
      listenWhen:
          (previous, current) =>
              previous.page != 1 &&
              current.status == PublicationListStatus.failure,
      listener:
          (_, state) => getIt<Utils>().showSnack(
            context: context,
            content: Text(state.error),
          ),
      builder: (context, state) {
        /// При инициализации запрашиваем публикации
        if (state.status == PublicationListStatus.initial) {
          context.read<ListCubit>().fetch();
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
            state.isFirstFetch && state.status == PublicationListStatus.failure;
        if (isErrorShown) {
          return SliverFillRemaining(child: Center(child: Text(state.error)));
        }

        var publications = state.publications;
        if (publications.isEmpty) {
          return const SliverFillRemaining(
            child: Center(child: Text('Ничего нет')),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (c, i) {
              if (i < publications.length) {
                final publication = publications[i];

                return PublicationCardWidget(
                  publication,
                  showType: context.read<ListCubit>().showType,
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
            childCount:
                publications.length +
                (state.status == PublicationListStatus.loading ? 1 : 0),
          ),
        );
      },
    );
  }
}

class _SkeletonLoader extends StatelessWidget {
  // ignore: unused_element
  const _SkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer.sliver(
      child: SliverList.list(
        children:
            List.generate(
              2,
              (i) => SkeletonCardWidget(
                authorAlias: 'author alias' * (Random().nextInt(2) + 1),
                title: 'card title' * (Random().nextInt(10) + 1),
                description:
                    'random card description' * (Random().nextInt(7) + 5),
              ),
            ).toList(),
      ),
    );
  }
}
