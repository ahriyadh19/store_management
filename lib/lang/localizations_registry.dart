import 'package:store_management/lang/ar.dart';
import 'package:store_management/lang/en.dart';

const String appLocalizationFallbackLocaleCode = 'en';

const Map<String, String> appLocalizationArbAliases = {
  'continue': 'continueLabel',
  'stackTrace': 'stackTraceLabel',
  'delete': 'deleteLabel',
  'addFieldRequired': 'fieldRequired',
  'validFieldRequired': 'validField',
};

const Map<String, Map<String, String>> appLocalizationRegistry = {
  'en': appLocalizationsEn,
  'ar': appLocalizationsAr,
};

const List<String> appLocalizationSupportedLocaleCodes = ['en', 'ar'];
