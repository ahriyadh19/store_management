import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:store_management/lang/localizations_registry.dart';
import 'package:store_management/l10n/generated/app_localizations.dart' as generated;

export 'package:store_management/l10n/generated/app_localizations.dart' show AppLocalizations;

const Locale appLocalizationFallbackLocale = Locale(appLocalizationFallbackLocaleCode);

generated.AppLocalizations appLocalizationsFor(Locale locale) {
  return generated.lookupAppLocalizations(locale);
}

generated.AppLocalizations appLocalizationsForLocaleOrFallback(Locale? locale) {
  if (locale == null) {
    return appLocalizationsFor(appLocalizationFallbackLocale);
  }

  for (final supportedLocale in generated.AppLocalizations.supportedLocales) {
    if (supportedLocale.languageCode == locale.languageCode) {
      return appLocalizationsFor(supportedLocale);
    }
  }

  return appLocalizationsFor(appLocalizationFallbackLocale);
}

enum AppMessageKey {
  authOperationFailed,
  nameRequired,
  usernameRequired,
  usernameInvalid,
  emailAndPasswordRequired,
  validEmailRequired,
  passwordTooShort,
  confirmationEmailResent,
  confirmationLinkRequired,
  confirmationLinkFullRequired,
  confirmationLinkMissingDetails,
  resetLinkRequired,
  resetLinkFullRequired,
  resetLinkMissingDetails,
  passwordsDoNotMatch,
  signedInSuccessfully,
  accountCreatedSuccessfully,
  accountCreatedConfirmEmail,
  passwordResetInstructionsSent,
  passwordUpdatedSuccessfully,
  emailConfirmedSignIn,
  emailConfirmedSuccessfully,
}

extension AppLocalizationsCompat on generated.AppLocalizations {
  bool get isArabic => localeName.startsWith('ar');

  String pick(String english, String arabic) => isArabic ? arabic : english;

  String localizedNotificationError(Object error, {String englishFallback = 'An unexpected error occurred. Please try again.', String arabicFallback = 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.'}) {
    final message = error.toString().trim();
    if (kDebugMode && message.isNotEmpty) {
      return message;
    }

    return pick(englishFallback, arabicFallback);
  }

  String message(AppMessageKey key, {String? email}) {
    switch (key) {
      case AppMessageKey.authOperationFailed:
        return authOperationFailed;
      case AppMessageKey.nameRequired:
        return nameRequired;
      case AppMessageKey.usernameRequired:
        return usernameRequired;
      case AppMessageKey.usernameInvalid:
        return usernameInvalid;
      case AppMessageKey.emailAndPasswordRequired:
        return emailAndPasswordRequired;
      case AppMessageKey.validEmailRequired:
        return validEmailRequired;
      case AppMessageKey.passwordTooShort:
        return passwordTooShort;
      case AppMessageKey.confirmationEmailResent:
        return confirmationEmailResent(email ?? '');
      case AppMessageKey.confirmationLinkRequired:
        return confirmationLinkRequired;
      case AppMessageKey.confirmationLinkFullRequired:
        return confirmationLinkFullRequired;
      case AppMessageKey.confirmationLinkMissingDetails:
        return confirmationLinkMissingDetails;
      case AppMessageKey.resetLinkRequired:
        return resetLinkRequired;
      case AppMessageKey.resetLinkFullRequired:
        return resetLinkFullRequired;
      case AppMessageKey.resetLinkMissingDetails:
        return resetLinkMissingDetails;
      case AppMessageKey.passwordsDoNotMatch:
        return passwordsDoNotMatch;
      case AppMessageKey.signedInSuccessfully:
        return signedInSuccessfully;
      case AppMessageKey.accountCreatedSuccessfully:
        return accountCreatedSuccessfully;
      case AppMessageKey.accountCreatedConfirmEmail:
        return accountCreatedConfirmEmail;
      case AppMessageKey.passwordResetInstructionsSent:
        return passwordResetInstructionsSent(email ?? '');
      case AppMessageKey.passwordUpdatedSuccessfully:
        return passwordUpdatedSuccessfully;
      case AppMessageKey.emailConfirmedSignIn:
        return emailConfirmedSignIn;
      case AppMessageKey.emailConfirmedSuccessfully:
        return emailConfirmedSuccessfully;
    }
  }
}

extension AppLocalizationsX on BuildContext {
  generated.AppLocalizations get l10n => generated.AppLocalizations.of(this);
}
