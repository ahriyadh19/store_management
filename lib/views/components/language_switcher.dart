import 'package:flutter/material.dart';
import 'package:store_management/localization/app_localizations.dart';
import 'package:store_management/localization/locale_controller.dart';

const _englishFlagAsset = 'lib/assets/icons/en.png';
const _arabicFlagAsset = 'lib/assets/icons/ar.png';

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
        _LanguageFlagButton(tooltip: l10n.english, assetPath: _englishFlagAsset, isSelected: currentCode == 'en', onPressed: () => localeController.setLocale(const Locale('en'))),
        const SizedBox(width: 8),
        _LanguageFlagButton(tooltip: l10n.arabic, assetPath: _arabicFlagAsset, isSelected: currentCode == 'ar', onPressed: () => localeController.setLocale(const Locale('ar'))),
      ],
    );
  }
}

class _LanguageFlagButton extends StatelessWidget {
  const _LanguageFlagButton({required this.tooltip, required this.assetPath, required this.isSelected, required this.onPressed});

  final String tooltip;
  final String assetPath;
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
            child: Image.asset(assetPath, width: 22, height: 22, fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}