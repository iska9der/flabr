// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

part 'article_config_model.dart';
part 'feed_config_model.dart';
part 'misc_config_model.dart';

class Config extends Equatable {
  const Config({
    this.feed = FeedConfigModel.empty,
    this.publication = PublicationConfigModel.empty,
    this.misc = MiscConfigModel.empty,
  });

  final FeedConfigModel feed;
  final PublicationConfigModel publication;
  final MiscConfigModel misc;

  Config copyWith({
    FeedConfigModel? feed,
    PublicationConfigModel? publication,
    MiscConfigModel? misc,
  }) {
    return Config(
      feed: feed ?? this.feed,
      publication: publication ?? this.publication,
      misc: misc ?? this.misc,
    );
  }

  @override
  List<Object?> get props => [
        feed,
        publication,
        misc,
      ];
}
