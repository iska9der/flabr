import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'config_model.freezed.dart';
part 'config_model.g.dart';
part 'feed_config_model.dart';
part 'misc_config_model.dart';
part 'publication_config_model.dart';
part 'scroll_variant.dart';
part 'theme_config_model.dart';

@freezed
class Config with _$Config {
  const factory Config({
    @Default(ThemeConfigModel.empty) ThemeConfigModel theme,
    @Default(FeedConfigModel.empty) FeedConfigModel feed,
    @Default(PublicationConfigModel.empty) PublicationConfigModel publication,
    @Default(MiscConfigModel.empty) MiscConfigModel misc,
  }) = _Config;

  factory Config.fromJson(Map<String, dynamic> json) => _$ConfigFromJson(json);
}
