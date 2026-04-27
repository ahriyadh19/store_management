import 'package:flutter/material.dart';
import 'package:store_management/localization/app_localizations.dart';
import 'package:store_management/localization/locale_controller.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key, required this.localeController, this.iconColor});

  final LocaleController localeController;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final currentCode = localeController.locale?.languageCode ?? Localizations.localeOf(context).languageCode;

    return PopupMenuButton<String>(
      tooltip: l10n.language,
      icon: Icon(Icons.language_rounded, color: iconColor),
      onSelected: (value) {
        localeController.setLocale(Locale(value));
      },
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: 'en',
          child: Row(
            children: [
              if (currentCode == 'en') const Icon(Icons.check_rounded, size: 18) else const SizedBox(width: 18),
              const SizedBox(width: 8),
              Text(l10n.english),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'ar',
          child: Row(
            children: [
              if (currentCode == 'ar') const Icon(Icons.check_rounded, size: 18) else const SizedBox(width: 18),
              const SizedBox(width: 8),
              Text(l10n.arabic),
            ],
          ),
        ),
      ],
    );
  }
}