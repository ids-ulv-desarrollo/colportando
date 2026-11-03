import 'package:colportando/core/extensions/theme_extensions.dart';
import 'package:colportando/core/theme/app_text.dart';
import 'package:flutter/material.dart';

class TextFormat {
  static Widget title(String text, {TextAlign? textAlign}) {
    return Builder(
      builder: (context) {
        return Text(
          text,
          style: context.textTheme.titleMedium,
          textAlign: textAlign ?? .start,
        );
      },
    );
  }

  static Widget subtitle(String text, {TextAlign? textAlign}) {
    return Builder(
      builder: (context) {
        return Text(
          text,
          style: context.textTheme.titleSmall,
          textAlign: textAlign ?? .start,
        );
      },
    );
  }

  static Widget body(String text, {TextAlign? textAlign}) {
    return Builder(
      builder: (context) {
        return Text(
          text,
          style: context.textTheme.bodyLarge,
          textAlign: textAlign ?? .start,
        );
      },
    );
  }

  static Widget bodyWhite(String text, {TextAlign? textAlign}) {
    return Builder(
      builder: (context) {
        return Text(
          text,
          style: AppText.bodyWhite,
          textAlign: textAlign ?? .start,
        );
      },
    );
  }

  static Widget bodySecondary(String text, {TextAlign? textAlign}) {
    return Builder(
      builder: (context) {
        return Text(
          text,
          style: context.textTheme.bodyMedium,
          textAlign: textAlign ?? .start,
        );
      },
    );
  }

  static Widget label(String text, {TextAlign? textAlign, Color? color}) {
    return Builder(
      builder: (context) {
        return Text(
          text,
          style: context.textTheme.labelMedium?.copyWith(color: color),
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
