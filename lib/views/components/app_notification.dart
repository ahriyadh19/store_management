import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:store_management/localization/app_localizations.dart';

enum AppNotificationType { error, success, warning, unknown }

const Duration kAppNotificationDuration = Duration(seconds: 6);

class AppNotification {
  const AppNotification._();

  static void show(
    BuildContext context, {
    required String message,
    AppNotificationType type = AppNotificationType.unknown,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    final palette = _paletteFor(type);
    final l10n = context.l10n;

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: palette.backgroundColor,
          duration: kAppNotificationDuration,
          content: Row(
            children: [
              Expanded(
                child: Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: palette.foregroundColor),
                ),
              ),
              IconButton(
                tooltip: l10n.pick('Copy', 'نسخ'),
                visualDensity: VisualDensity.compact,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                padding: EdgeInsets.zero,
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: message));
                },
                icon: Icon(Icons.content_copy_rounded, size: 18, color: palette.foregroundColor),
              ),
              IconButton(
                tooltip: l10n.pick('Close', 'إغلاق'),
                visualDensity: VisualDensity.compact,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                padding: EdgeInsets.zero,
                onPressed: messenger.hideCurrentSnackBar,
                icon: Icon(Icons.close_rounded, size: 18, color: palette.foregroundColor),
              ),
            ],
          ),
        ),
      );
  }

  static _AppNotificationPalette _paletteFor(AppNotificationType type) {
    switch (type) {
      case AppNotificationType.error:
        return const _AppNotificationPalette(backgroundColor: Color(0xFFC62828), foregroundColor: Colors.white);
      case AppNotificationType.success:
        return const _AppNotificationPalette(backgroundColor: Color(0xFF2E7D32), foregroundColor: Colors.white);
      case AppNotificationType.warning:
        return const _AppNotificationPalette(backgroundColor: Color(0xFFF9A825), foregroundColor: Color(0xFF1A1A1A));
      case AppNotificationType.unknown:
        return const _AppNotificationPalette(backgroundColor: Color(0xFF1565C0), foregroundColor: Colors.white);
    }
  }
}

class _AppNotificationPalette {
  const _AppNotificationPalette({required this.backgroundColor, required this.foregroundColor});

  final Color backgroundColor;
  final Color foregroundColor;
}