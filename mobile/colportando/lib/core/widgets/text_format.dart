import 'package:colportando/core/extensions/theme_extensions.dart';
import 'package:colportando/core/theme/app_text.dart';
import 'package:flutter/material.dart';

class TextFormat {
  static Widget title(String text, {bool? alignCenter}) {
    return Builder(
      builder: (context) {
        return Text(
          text,
          style: context.textTheme.titleMedium,
          textAlign: alignCenter == true ? TextAlign.center : null,
        );
      },
    );
  }

  static Widget subtitle(String text, {bool? alignCenter}) {
    return Builder(
      builder: (context) {
        return Text(
          text,
          style: context.textTheme.titleSmall,
          textAlign: alignCenter == true ? TextAlign.center : null,
        );
      },
    );
  }

  static Widget body(String text, {bool? alignCenter}) {
    return Builder(
      builder: (context) {
        return Text(
          text,
          style: context.textTheme.bodyLarge,
          textAlign: alignCenter == true ? TextAlign.center : null,
        );
      },
    );
  }

  static Widget bodyWhite(String text, {bool? alignCenter}) {
    return Builder(
      builder: (context) {
        return Text(
          text,
          style: AppText.bodyWhite,
          textAlign: alignCenter == true ? TextAlign.center : null,
        );
      },
    );
  }

  static Widget bodySecondary(String text, {bool? alignCenter}) {
    return Builder(
      builder: (context) {
        return Text(
          text,
          style: context.textTheme.bodyMedium,
          textAlign: alignCenter == true ? TextAlign.center : null,
        );
      },
    );
  }

  static Widget label(String text, {bool? alignCenter, Color? color}) {
    return Builder(
      builder: (context) {
        return Text(
          text,
          style: context.textTheme.labelMedium?.copyWith(color: color),
          textAlign: alignCenter == true ? TextAlign.center : null,
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
