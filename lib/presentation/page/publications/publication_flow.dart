// ignore_for_file: use_key_in_widget_constructors

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage(name: PublicationFlow.routeName)
class PublicationFlow extends StatelessWidget {
  const PublicationFlow({
    super.key,
    @PathParam() required this.type,
    @PathParam() required this.id,
  });

  final String type;
  final String id;

  static const String routePath = '/publication/:type/:id';
  static const String routeName = 'PublicationRouter';

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}
