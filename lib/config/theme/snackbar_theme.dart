import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_text_styles.dart';

class SnackbarTheme {
  void newSnackBarSuccess(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.of(context);
    final colors = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'success',
            message: message,
            messageTextStyle: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white,
            ),
            contentType: ContentType.success,
            color: colors.tertiary,
          ),
        ),
      );
  }

  void newSnackBarError(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.of(context);

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'error',
            message: message,
            contentType: ContentType.failure,
          ),
        ),
      );
  }

  void newSnackBarInfo(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.of(context);

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'info',
            message: message,
            contentType: ContentType.help,
          ),
        ),
      );
  }
}
