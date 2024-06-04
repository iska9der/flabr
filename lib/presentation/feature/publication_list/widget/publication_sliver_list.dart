part of '../part.dart';

class PublicationSliverList<ListCubit extends PublicationListCubit<ListState>,
    ListState extends PublicationListState> extends StatelessWidget {
  const PublicationSliverList({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollCubit = context.read<ScrollCubit?>();

    return BlocConsumer<ListCubit, ListState>(
      listenWhen: (previous, current) =>
          previous.page != 1 && current.status == PublicationListStatus.failure,
      listener: (_, state) => getIt<Utils>().showSnack(
        context: context,
        content: Text(state.error),
      ),
      builder: (context, state) {
        /// Инициализация
        if (state.status == PublicationListStatus.initial) {
          context.read<ListCubit>().fetch();
          return const SliverFillRemaining(
            child: CircleIndicator(),
          );
        }

        /// Если происходит загрузка первой страницы
        if (context.read<ListCubit>().isFirstFetch) {
          if (state.status == PublicationListStatus.loading) {
            return const SliverFillRemaining(
              child: CircleIndicator(),
            );
          }

          /// Ошибка при попытке получить статьи
          if (state.status == PublicationListStatus.failure) {
            return SliverFillRemaining(
              child: Center(child: Text(state.error)),
            );
          }
        }

        var publications = state.publications;
        if (publications.isEmpty) {
          return const SliverFillRemaining(
            child: Center(
              child: Text('Ничего нет'),
            ),
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
            childCount: publications.length +
                (state.status == PublicationListStatus.loading ? 1 : 0),
          ),
        );
      },
    );
  }
}
