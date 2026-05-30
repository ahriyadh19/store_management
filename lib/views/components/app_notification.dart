import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toastification/toastification.dart';

enum AppNotificationType { error, success, warning, unknown }

const Duration kAppNotificationDuration = Duration(seconds: 6);

class AppNotification {
  const AppNotification._();

  static void show(
    BuildContext context, {
    required String message,
    AppNotificationType type = AppNotificationType.unknown,
  }) {
    final palette = _paletteFor(context, type);
    final isTestEnvironment = _isTestEnvironment();

    toastification.dismissAll(delayForAnimation: false);

    toastification.show(
      context: context,
      alignment: Alignment.topRight,
      type: _toastTypeFor(type),
      style: ToastificationStyle.flat,
      animationDuration: isTestEnvironment ? Duration.zero : null,
      autoCloseDuration: isTestEnvironment ? null : kAppNotificationDuration,
      title: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: palette.foregroundColor, height: 1.35, fontWeight: FontWeight.w600),
      ),
      primaryColor: palette.accentColor,
      backgroundColor: palette.backgroundColor,
      foregroundColor: palette.foregroundColor,
      borderSide: BorderSide(color: palette.borderColor, width: 1.2),
      showProgressBar: false,
      closeButton: ToastCloseButton(
        showType: CloseButtonShowType.always,
        buttonBuilder: (context, onClose) {
          final material = MaterialLocalizations.of(context);
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ToastActionButton(
                tooltip: material.copyButtonLabel,
                icon: Icons.content_copy_rounded,
                color: palette.foregroundColor,
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: message));
                },
              ),
              _ToastActionButton(tooltip: material.closeButtonTooltip, icon: Icons.close_rounded, color: palette.foregroundColor, onPressed: onClose,
              ),
            ],
          );
        },
      ),
      callbacks: ToastificationCallbacks(
        onTap: (_) {
          Clipboard.setData(ClipboardData(text: message));
        },
      ),
    );
  }

  static bool _isTestEnvironment() {
    final bindingType = WidgetsBinding.instance.runtimeType.toString();
    return bindingType.contains('TestWidgetsFlutterBinding') || bindingType.contains('AutomatedTestWidgetsFlutterBinding') || bindingType.contains('LiveTestWidgetsFlutterBinding');
  }

  static _AppNotificationPalette _paletteFor(BuildContext context, AppNotificationType type) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;
    final accentColor = switch (type) {
      AppNotificationType.error => colorScheme.error,
      AppNotificationType.success => isDark ? const Color(0xFF4DD4AC) : const Color(0xFF1E8E5A),
      AppNotificationType.warning => isDark ? const Color(0xFFFFC857) : const Color(0xFFB26A00),
      AppNotificationType.unknown => colorScheme.primary,
    };
    final baseSurface = isDark ? colorScheme.surfaceContainerHighest : colorScheme.surface;
    final backgroundColor = Color.alphaBlend(accentColor.withValues(alpha: isDark ? 0.22 : 0.12), baseSurface);

    switch (type) {
      case AppNotificationType.error:
      case AppNotificationType.success:
      case AppNotificationType.warning:
      case AppNotificationType.unknown:
        return _AppNotificationPalette(
          accentColor: accentColor,
          backgroundColor: backgroundColor,
          foregroundColor: colorScheme.onSurface,
          borderColor: accentColor.withValues(alpha: isDark ? 0.72 : 0.36),
        );
    }
  }

  static ToastificationType _toastTypeFor(AppNotificationType type) {
    switch (type) {
      case AppNotificationType.error:
        return ToastificationType.error;
      case AppNotificationType.success:
        return ToastificationType.success;
      case AppNotificationType.warning:
        return ToastificationType.warning;
      case AppNotificationType.unknown:
        return ToastificationType.info;
    }
  }
}

class _AppNotificationPalette {
  const _AppNotificationPalette({required this.accentColor, required this.backgroundColor, required this.foregroundColor, required this.borderColor});

  final Color accentColor;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;
}

class _ToastActionButton extends StatelessWidget {
  const _ToastActionButton({required this.tooltip, required this.icon, required this.color, required this.onPressed});

  final String tooltip;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 30,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(5),
        child: IconButton(
          tooltip: tooltip,
          padding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
          onPressed: onPressed,
          icon: Icon(icon, size: 18, color: color),
        ),
      ),
    );
  }
}
