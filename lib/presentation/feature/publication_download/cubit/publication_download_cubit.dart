part of '../part.dart';

class PublicationDownloadCubit extends Cubit<PublicationDownloadState> {
  PublicationDownloadCubit({
    required String publicationId,
    required String publicationText,
    required PublicationDownloadFormat format,
  })  : converter = PublicationTextConverter(
          text: publicationText,
          desiredFormat: format,
        ),
        super(PublicationDownloadState(
          id: publicationId,
          htmlText: publicationText,
          format: format,
        )) {
    _init();
  }

  final PublicationTextConverter converter;

  _init() async {
    if (!await FlutterFileDialog.isPickDirectorySupported()) {
      return emit(
          state.copyWith(status: PublicationDownloadStatus.notSupported));
    }
  }

  pickAndSave() async {
    if (state.status == PublicationDownloadStatus.loading ||
        state.status == PublicationDownloadStatus.notSupported) {
      return;
    }

    try {
      emit(state.copyWith(status: PublicationDownloadStatus.loading));

      final pickedDirectory = await FlutterFileDialog.pickDirectory();
      if (pickedDirectory == null) {
        return emit(state.copyWith(status: PublicationDownloadStatus.initial));
      }

      final text = converter.convert();
      final data = utf8.encode(text);

      await FlutterFileDialog.saveFileToDirectory(
        directory: pickedDirectory,
        data: data,
        mimeType: state.format.mimeType,
        fileName: state.fileName,
        replace: true,
      );

      emit(state.copyWith(status: PublicationDownloadStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: PublicationDownloadStatus.failure,
        error: e.toString(),
      ));
    }
  }
}
