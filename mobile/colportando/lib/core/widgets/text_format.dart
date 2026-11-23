import 'package:colportando/core/extensions/theme_extensions.dart';
import 'package:colportando/core/theme/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WordLimitTextInputFormatter extends TextInputFormatter {
  final int maxWords;

  const WordLimitTextInputFormatter({required this.maxWords});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final words = newValue.text
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty);
    if (words.length <= maxWords) return newValue;
    return oldValue;
  }
}

class TextFormat {
  static const int descriptionWordLimit = 30;

  static int descriptionWordCount(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return 0;
    return trimmed
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .length;
  }

  static String descriptionPreview(
    String text, {
    int maxWords = descriptionWordLimit,
  }) {
    final normalized = text.trim();
    if (normalized.isEmpty) return 'Sin descripción';

    final words = normalized.split(RegExp(r'\s+'));
    if (words.length <= maxWords) return normalized;
    return '${words.take(maxWords).join(' ')}...';
  }

  static Widget title(
    String text, {
    TextAlign? textAlign,
    Color? color,
    FontWeight? fontWeight,
  }) {
    return Builder(
      builder: (context) {
        return Text(
          text,
          style: context.textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: fontWeight,
          ),
          textAlign: textAlign ?? .start,
        );
      },
    );
  }

  static Widget subtitle(
    String text, {
    TextAlign? textAlign,
    Color? color,
    FontWeight? fontWeight,
  }) {
    return Builder(
      builder: (context) {
        return Text(
          text,
          style: context.textTheme.titleSmall?.copyWith(
            color: color,
            fontWeight: fontWeight,
          ),
          textAlign: textAlign ?? .start,
        );
      },
    );
  }

  static Widget body(
    String text, {
    TextAlign? textAlign,
    Color? color,
    FontWeight? fontWeight,
  }) {
    return Builder(
      builder: (context) {
        return Text(
          text,
          style: context.textTheme.bodyLarge?.copyWith(
            color: color,
            fontWeight: fontWeight,
          ),
          textAlign: textAlign ?? .start,
        );
      },
    );
  }

  static Widget bodyWhite(
    String text, {
    TextAlign? textAlign,
    Color? color,
    FontWeight? fontWeight,
  }) {
    return Builder(
      builder: (context) {
        return Text(
          text,
          style: AppText.bodyWhite.copyWith(
            color: color,
            fontWeight: fontWeight,
          ),
          textAlign: textAlign ?? .start,
        );
      },
    );
  }

  static Widget bodySecondary(
    String text, {
    TextAlign? textAlign,
    Color? color,
    FontWeight? fontWeight,
  }) {
    return Builder(
      builder: (context) {
        return Text(
          text,
          style: context.textTheme.bodyMedium?.copyWith(
            color: color,
            fontWeight: fontWeight,
          ),
          textAlign: textAlign ?? .start,
        );
      },
    );
  }

  static Widget label(
    String text, {
    TextAlign? textAlign,
    Color? color,
    FontWeight? fontWeight,
  }) {
    return Builder(
      builder: (context) {
        return Text(
          text,
          style: context.textTheme.labelMedium?.copyWith(
            color: color,
            fontWeight: fontWeight,
          ),
          textAlign: textAlign ?? .start,
        );
      },
    );
  }
}
//   @override
//   Widget build(BuildContext context) {
//     switch (type) {
//       case "title":
//         return Text(text, style: context.textTheme.titleMedium);
//       case "subtitle":
//         return Text(text, style: context.textTheme.titleSmall);
//       case "body":
//         return Text(
//           text,
//           style: context.textTheme.bodyLarge,
//           textAlign: alignCenter == true ? TextAlign.center : null,
//         );
//       case "bodyWhite":
//         return Text(text, style: AppText.bodyWhite);
//       case "bodySecondary":
//         return Text(
//           text,
//           style: context.textTheme.bodyMedium,
//           textAlign: alignCenter == true ? TextAlign.center : null,
//         );

//       case "label":
//         return Text(text, style: context.textTheme.labelMedium);
//       default:
//         return Text(text, style: context.textTheme.titleLarge);
//     }
//   }
// }
