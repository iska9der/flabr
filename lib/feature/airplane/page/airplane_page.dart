import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../presentation/page/publications/widget/publication_detail_view.dart';
import '../../../presentation/widget/enhancement/enhancement.dart';
import '../bloc/bloc.dart';

@RoutePage()
class AirplanePage extends StatelessWidget {
  const AirplanePage({super.key});

  static const String routePath = 'airplane';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Оффлайн'),
      ),
      body:
          BlocBuilder<OfflinePublicationListBloc, OfflinePublicationListState>(
            builder: (context, state) {
              return state.maybeWhen(
                success: (models) => ListView.builder(
                  itemCount: models.length,
                  itemBuilder: (context, index) {
                    final model = models[index];

                    return ListTile(
                      title: Text(model.id),
                      subtitle: Text(model.type.label),
                      onTap: () => context.router.pushWidget(
                        Scaffold(
                          body: SafeArea(
                            child: PublicationDetailView(publication: model),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                orElse: () => const Center(child: CircleIndicator()),
              );
            },
          ),
    );
  }
}
