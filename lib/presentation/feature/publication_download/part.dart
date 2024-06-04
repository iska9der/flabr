import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:html2md/html2md.dart' as html2md;

part 'cubit/publication_download_cubit.dart';
part 'cubit/publication_download_state.dart';
part 'model/publication_download_format_enum.dart';
part 'service/publication_text_converter.dart';
part 'widget/publication_download_widget.dart';
