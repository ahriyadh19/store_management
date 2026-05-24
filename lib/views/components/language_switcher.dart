import 'package:flutter/material.dart';
import 'package:store_management/localization/app_localizations.dart';
import 'package:store_management/localization/locale_controller.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key, required this.localeController});

  final LocaleController localeController;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final currentCode = localeController.locale?.languageCode ?? Localizations.localeOf(context).languageCode;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _LanguageFlagButton(
          tooltip: l10n.english,
          icon: Icons.language_rounded,
          label: 'EN',
          isSelected: currentCode == 'en',
          onPressed: () => localeController.setLocale(const Locale('en')),
        ),
        const SizedBox(width: 8),
        _LanguageFlagButton(tooltip: l10n.arabic, icon: Icons.translate_rounded, label: 'AR', isSelected: currentCode == 'ar', onPressed: () => localeController.setLocale(const Locale('ar'))),
      ],
    );
  }
}

class _LanguageFlagButton extends StatelessWidget {
  const _LanguageFlagButton({required this.tooltip, required this.icon, required this.label, required this.isSelected, required this.onPressed});

  final String tooltip;
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Tooltip(
      message: tooltip,
      child: Material(
        color: isSelected ? colorScheme.primaryContainer : colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: InkWell(
          onTap: isSelected ? null : onPressed,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18, color: isSelected ? colorScheme.onPrimaryContainer : colorScheme.onSurfaceVariant),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700, color: isSelected ? colorScheme.onPrimaryContainer : colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}