import 'package:flutter/widgets.dart';

enum AppMessageKey {
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

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = <Locale>[
    Locale('en'),
    Locale('ar'),
  ];

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    final localizations = Localizations.of<AppLocalizations>(context, AppLocalizations);
    assert(localizations != null, 'AppLocalizations not found in context');
    return localizations!;
  }

  bool get isArabic => locale.languageCode == 'ar';

  static final Map<String, String> _en = {
    'appTitle': 'Store Management',
    'menu': 'Menu',
    'dashboard': 'Dashboard',
    'products': 'Products',
    'customers': 'Customers',
    'reports': 'Reports',
    'logout': 'Logout',
    'welcomeTitle': 'Welcome to Store Management!',
    'signedInFallback': 'You are signed in.',
    'signIn': 'Sign in',
    'signUp': 'Sign up',
    'createAccount': 'Create account',
    'continue': 'Continue',
    'confirmYourEmail': 'Confirm your email',
    'confirmEmailDescription': 'We sent a confirmation link to {email}. Open the link in your email to verify your account.',
    'confirmEmailPasteHint': 'If confirmation does not complete automatically, copy the final link from your browser and paste it here.',
    'confirmationLink': 'Confirmation link',
    'confirmationLinkHint': 'https://...token_hash=... or https://...code=...',
    'resendEmail': 'Resend email',
    'completeConfirmation': 'Complete confirmation',
    'backToSignIn': 'Back to sign in',
    'resetPassword': 'Reset password',
    'forgotPasswordTitle': 'Forgot password?',
    'resetPasswordSentDescription': 'A reset link was sent to {email}. Use the link in your email to choose a new password.',
    'resetPasswordPasteHint': 'Paste the password reset link from your email, then choose a new password.',
    'resetLink': 'Reset link',
    'resetLinkHint': 'https://...token_hash=... or https://...code=...',
    'forgotPasswordDescription': 'Enter your email address and we will send you a link to reset your password.',
    'sendAgain': 'Send again',
    'sendResetLink': 'Send reset link',
    'completeResetPassword': 'Update password',
    'email': 'Email',
    'emailHint': 'name@store.com',
    'name': 'Name',
    'nameHint': 'Store owner name',
    'username': 'Username',
    'usernameHint': 'store_owner',
    'password': 'Password',
    'passwordHint': 'At least 6 characters',
    'confirmPassword': 'Confirm password',
    'confirmPasswordHint': 'Re-enter your password',
    'signInSubtitle': 'Use your email and password to continue.',
    'signUpSubtitle': 'Create your account to get started.',
    'forgotPasswordAction': 'Forgot password?',
    'signInFooter': 'Sign in with your email and password.',
    'signUpFooter': 'Enter your details below to create your account.',
    'availablePlatformsTitle': 'Available at',
    'theme': 'Theme',
    'darkMode': 'Dark mode',
    'language': 'Language',
    'english': 'English',
    'arabic': 'العربية',
    'nameRequired': 'Name is required.',
    'usernameRequired': 'Username is required.',
    'usernameInvalid': 'Username can use letters, numbers, and underscores only.',
    'emailAndPasswordRequired': 'Email and password are required.',
    'validEmailRequired': 'Enter a valid email address.',
    'passwordTooShort': 'Password must be at least 6 characters.',
    'confirmationEmailResent': 'Confirmation email sent again to {email}.',
    'confirmationLinkRequired': 'Paste the confirmation link from your email.',
    'confirmationLinkFullRequired': 'Paste the full confirmation link from your email.',
    'confirmationLinkMissingDetails': 'The confirmation link is missing the required verification details.',
    'resetLinkRequired': 'Paste the password reset link from your email.',
    'resetLinkFullRequired': 'Paste the full password reset link from your email.',
    'resetLinkMissingDetails': 'The password reset link is missing the required verification details.',
    'passwordsDoNotMatch': 'Passwords do not match.',
    'signedInSuccessfully': 'Signed in successfully.',
    'accountCreatedSuccessfully': 'Account created successfully.',
    'accountCreatedConfirmEmail': 'Account created. Confirm your email before signing in.',
    'passwordResetInstructionsSent': 'Password reset instructions sent to {email}.',
    'passwordUpdatedSuccessfully': 'Password updated successfully.',
    'emailConfirmedSignIn': 'Email confirmed. Sign in to continue.',
    'emailConfirmedSuccessfully': 'Email confirmed successfully.',
  };

  static final Map<String, String> _ar = {
    'appTitle': 'إدارة المتجر',
    'menu': 'القائمة',
    'dashboard': 'لوحة التحكم',
    'products': 'المنتجات',
    'customers': 'العملاء',
    'reports': 'التقارير',
    'logout': 'تسجيل الخروج',
    'welcomeTitle': 'مرحبًا بك في إدارة المتجر!',
    'signedInFallback': 'تم تسجيل دخولك.',
    'signIn': 'تسجيل الدخول',
    'signUp': 'إنشاء حساب',
    'createAccount': 'إنشاء حساب',
    'continue': 'متابعة',
    'confirmYourEmail': 'أكد بريدك الإلكتروني',
    'confirmEmailDescription': 'أرسلنا رابط تأكيد إلى {email}. افتح الرابط في بريدك الإلكتروني لتأكيد حسابك.',
    'confirmEmailPasteHint': 'إذا لم يكتمل التأكيد تلقائيًا، انسخ الرابط النهائي من المتصفح والصقه هنا.',
    'confirmationLink': 'رابط التأكيد',
    'confirmationLinkHint': 'https://...token_hash=... أو https://...code=...',
    'resendEmail': 'إعادة إرسال البريد',
    'completeConfirmation': 'إكمال التأكيد',
    'backToSignIn': 'العودة لتسجيل الدخول',
    'resetPassword': 'إعادة تعيين كلمة المرور',
    'forgotPasswordTitle': 'نسيت كلمة المرور؟',
    'resetPasswordSentDescription': 'تم إرسال رابط إعادة التعيين إلى {email}. استخدم الرابط في بريدك الإلكتروني لاختيار كلمة مرور جديدة.',
    'resetPasswordPasteHint': 'الصق رابط إعادة تعيين كلمة المرور من بريدك الإلكتروني، ثم اختر كلمة مرور جديدة.',
    'resetLink': 'رابط إعادة التعيين',
    'resetLinkHint': 'https://...token_hash=... أو https://...code=...',
    'forgotPasswordDescription': 'أدخل بريدك الإلكتروني وسنرسل لك رابطًا لإعادة تعيين كلمة المرور.',
    'sendAgain': 'إرسال مرة أخرى',
    'sendResetLink': 'إرسال رابط إعادة التعيين',
    'completeResetPassword': 'تحديث كلمة المرور',
    'email': 'البريد الإلكتروني',
    'emailHint': 'name@store.com',
    'name': 'الاسم',
    'nameHint': 'اسم صاحب المتجر',
    'username': 'اسم المستخدم',
    'usernameHint': 'store_owner',
    'password': 'كلمة المرور',
    'passwordHint': '6 أحرف على الأقل',
    'confirmPassword': 'تأكيد كلمة المرور',
    'confirmPasswordHint': 'أعد إدخال كلمة المرور',
    'signInSubtitle': 'استخدم بريدك الإلكتروني وكلمة المرور للمتابعة.',
    'signUpSubtitle': 'أنشئ حسابك للبدء.',
    'forgotPasswordAction': 'نسيت كلمة المرور؟',
    'signInFooter': 'سجّل الدخول باستخدام بريدك الإلكتروني وكلمة المرور.',
    'signUpFooter': 'أدخل بياناتك أدناه لإنشاء حسابك.',
    'availablePlatformsTitle': 'متاح على',
    'availablePlatformsSubtitle': 'تابع عملك على سطح المكتب والجوال والويب باستخدام الحساب نفسه.',
    'platformWeb': 'الويب',
    'platformAndroid': 'أندرويد',
    'platformIos': 'iOS',
    'platformLinux': 'لينكس',
    'platformMacos': 'macOS',
    'platformWindows': 'ويندوز',
    'theme': 'المظهر',
    'darkMode': 'الوضع الداكن',
    'language': 'اللغة',
    'english': 'English',
    'arabic': 'العربية',
    'nameRequired': 'الاسم مطلوب.',
    'usernameRequired': 'اسم المستخدم مطلوب.',
    'usernameInvalid': 'يمكن أن يحتوي اسم المستخدم على أحرف وأرقام وشرطة سفلية فقط.',
    'emailAndPasswordRequired': 'البريد الإلكتروني وكلمة المرور مطلوبان.',
    'validEmailRequired': 'أدخل بريدًا إلكترونيًا صالحًا.',
    'passwordTooShort': 'يجب أن تكون كلمة المرور 6 أحرف على الأقل.',
    'confirmationEmailResent': 'تمت إعادة إرسال رسالة التأكيد إلى {email}.',
    'confirmationLinkRequired': 'الصق رابط التأكيد من بريدك الإلكتروني.',
    'confirmationLinkFullRequired': 'الصق رابط التأكيد الكامل من بريدك الإلكتروني.',
    'confirmationLinkMissingDetails': 'رابط التأكيد لا يحتوي على بيانات التحقق المطلوبة.',
    'resetLinkRequired': 'الصق رابط إعادة تعيين كلمة المرور من بريدك الإلكتروني.',
    'resetLinkFullRequired': 'الصق رابط إعادة تعيين كلمة المرور الكامل من بريدك الإلكتروني.',
    'resetLinkMissingDetails': 'رابط إعادة تعيين كلمة المرور لا يحتوي على بيانات التحقق المطلوبة.',
    'passwordsDoNotMatch': 'كلمتا المرور غير متطابقتين.',
    'signedInSuccessfully': 'تم تسجيل الدخول بنجاح.',
    'accountCreatedSuccessfully': 'تم إنشاء الحساب بنجاح.',
    'accountCreatedConfirmEmail': 'تم إنشاء الحساب. أكد بريدك الإلكتروني قبل تسجيل الدخول.',
    'passwordResetInstructionsSent': 'تم إرسال تعليمات إعادة تعيين كلمة المرور إلى {email}.',
    'passwordUpdatedSuccessfully': 'تم تحديث كلمة المرور بنجاح.',
    'emailConfirmedSignIn': 'تم تأكيد البريد الإلكتروني. سجّل الدخول للمتابعة.',
    'emailConfirmedSuccessfully': 'تم تأكيد البريد الإلكتروني بنجاح.',
  };

  Map<String, String> get _strings => isArabic ? _ar : _en;

  String _text(String key, [Map<String, String> params = const {}]) {
    var value = _strings[key] ?? _en[key] ?? key;
    for (final entry in params.entries) {
      value = value.replaceAll('{${entry.key}}', entry.value);
    }
    return value;
  }

  String get appTitle => _text('appTitle');
  String get menu => _text('menu');
  String get dashboard => _text('dashboard');
  String get products => _text('products');
  String get customers => _text('customers');
  String get reports => _text('reports');
  String get logout => _text('logout');
  String get welcomeTitle => _text('welcomeTitle');
  String get signedInFallback => _text('signedInFallback');
  String get signIn => _text('signIn');
  String get signUp => _text('signUp');
  String get createAccount => _text('createAccount');
  String get continueLabel => _text('continue');
  String get confirmYourEmail => _text('confirmYourEmail');
  String confirmEmailDescription(String email) => _text('confirmEmailDescription', {'email': email});
  String get confirmEmailPasteHint => _text('confirmEmailPasteHint');
  String get confirmationLink => _text('confirmationLink');
  String get confirmationLinkHint => _text('confirmationLinkHint');
  String get resendEmail => _text('resendEmail');
  String get completeConfirmation => _text('completeConfirmation');
  String get backToSignIn => _text('backToSignIn');
  String get resetPassword => _text('resetPassword');
  String get forgotPasswordTitle => _text('forgotPasswordTitle');
  String resetPasswordSentDescription(String email) => _text('resetPasswordSentDescription', {'email': email});
  String get resetPasswordPasteHint => _text('resetPasswordPasteHint');
  String get resetLink => _text('resetLink');
  String get resetLinkHint => _text('resetLinkHint');
  String get forgotPasswordDescription => _text('forgotPasswordDescription');
  String get sendAgain => _text('sendAgain');
  String get sendResetLink => _text('sendResetLink');
  String get completeResetPassword => _text('completeResetPassword');
  String get email => _text('email');
  String get emailHint => _text('emailHint');
  String get name => _text('name');
  String get nameHint => _text('nameHint');
  String get username => _text('username');
  String get usernameHint => _text('usernameHint');
  String get password => _text('password');
  String get passwordHint => _text('passwordHint');
  String get confirmPassword => _text('confirmPassword');
  String get confirmPasswordHint => _text('confirmPasswordHint');
  String get signInSubtitle => _text('signInSubtitle');
  String get signUpSubtitle => _text('signUpSubtitle');
  String get forgotPasswordAction => _text('forgotPasswordAction');
  String get signInFooter => _text('signInFooter');
  String get signUpFooter => _text('signUpFooter');
  String get availablePlatformsTitle => _text('availablePlatformsTitle');
  String get availablePlatformsSubtitle => _text('availablePlatformsSubtitle');
  String get platformWeb => _text('platformWeb');
  String get platformAndroid => _text('platformAndroid');
  String get platformIos => _text('platformIos');
  String get platformLinux => _text('platformLinux');
  String get platformMacos => _text('platformMacos');
  String get platformWindows => _text('platformWindows');
  String get theme => _text('theme');
  String get darkMode => _text('darkMode');
  String get language => _text('language');
  String get english => _text('english');
  String get arabic => _text('arabic');

  String message(AppMessageKey key, {String? email}) {
    switch (key) {
      case AppMessageKey.nameRequired:
        return _text('nameRequired');
      case AppMessageKey.usernameRequired:
        return _text('usernameRequired');
      case AppMessageKey.usernameInvalid:
        return _text('usernameInvalid');
      case AppMessageKey.emailAndPasswordRequired:
        return _text('emailAndPasswordRequired');
      case AppMessageKey.validEmailRequired:
        return _text('validEmailRequired');
      case AppMessageKey.passwordTooShort:
        return _text('passwordTooShort');
      case AppMessageKey.confirmationEmailResent:
        return _text('confirmationEmailResent', {'email': email ?? ''});
      case AppMessageKey.confirmationLinkRequired:
        return _text('confirmationLinkRequired');
      case AppMessageKey.confirmationLinkFullRequired:
        return _text('confirmationLinkFullRequired');
      case AppMessageKey.confirmationLinkMissingDetails:
        return _text('confirmationLinkMissingDetails');
      case AppMessageKey.resetLinkRequired:
        return _text('resetLinkRequired');
      case AppMessageKey.resetLinkFullRequired:
        return _text('resetLinkFullRequired');
      case AppMessageKey.resetLinkMissingDetails:
        return _text('resetLinkMissingDetails');
      case AppMessageKey.passwordsDoNotMatch:
        return _text('passwordsDoNotMatch');
      case AppMessageKey.signedInSuccessfully:
        return _text('signedInSuccessfully');
      case AppMessageKey.accountCreatedSuccessfully:
        return _text('accountCreatedSuccessfully');
      case AppMessageKey.accountCreatedConfirmEmail:
        return _text('accountCreatedConfirmEmail');
      case AppMessageKey.passwordResetInstructionsSent:
        return _text('passwordResetInstructionsSent', {'email': email ?? ''});
      case AppMessageKey.passwordUpdatedSuccessfully:
        return _text('passwordUpdatedSuccessfully');
      case AppMessageKey.emailConfirmedSignIn:
        return _text('emailConfirmedSignIn');
      case AppMessageKey.emailConfirmedSuccessfully:
        return _text('emailConfirmedSuccessfully');
    }
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalizations.supportedLocales.any((item) => item.languageCode == locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}