part of '../part.dart';

class PublicationFormatWidget extends StatelessWidget {
  const PublicationFormatWidget(
    this.format, {
    super.key,
  });

  final PublicationFormat format;

  @override
  Widget build(BuildContext context) {
    final actualColor = format.color;

    return Align(
      alignment: Alignment.centerLeft,
      child: OutlinedButton(
        onPressed: null,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          minimumSize: Size.zero,
          side: BorderSide(color: actualColor),
          foregroundColor: actualColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(kBorderRadiusDefault),
            ),
          ),
        ),
        child: Text(
          format.label,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: actualColor,
          ),
        ),
      ),
    );
  }
}
