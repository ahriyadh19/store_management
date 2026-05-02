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

  static const supportedLocales = <Locale>[Locale('en'), Locale('ar')];

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    final localizations = Localizations.of<AppLocalizations>(context, AppLocalizations);
    assert(localizations != null, 'AppLocalizations not found in context');
    return localizations!;
  }

  bool get isArabic => locale.languageCode == 'ar';

  static final Map<String, String> _en = {
    'bodyFontFamily': 'Mulish',
    'displayFontFamily': 'Mulish',
    'appTitle': 'Store Management',
    'menu': 'Menu',
    'dashboard': 'Dashboard',
    'products': 'Products',
    'customers': 'Customers',
    'clients': 'Clients',
    'suppliers': 'Suppliers',
    'stores': 'Stores',
    'branches': 'Branches',
    'storeBranches': 'Store branches',
    'categories': 'Categories',
    'tags': 'Tags',
    'supplierProducts': 'Supplier products',
    'invoices': 'Invoices',
    'invoiceItems': 'Invoice items',
    'returns': 'Returns',
    'returnItems': 'Return items',
    'paymentVouchers': 'Payment vouchers',
    'paymentAllocations': 'Payment allocations',
    'users': 'Users',
    'storeUsers': 'Store users',
    'roles': 'Roles',
    'userRoles': 'User roles',
    'storeSuppliers': 'Store suppliers',
    'inventory': 'Inventory',
    'transactions': 'Transactions',
    'overview': 'Overview',
    'catalog': 'Catalog',
    'sales': 'Sales',
    'people': 'People',
    'operations': 'Operations',
    'activeModules': 'Active modules',
    'quickActions': 'Quick actions',
    'moduleStatusTitle': 'Status',
    'moduleStatusReady': 'Ready',
    'moduleStatusReadyCaption': 'Navigation is active and this screen is connected.',
    'moduleContentTitle': 'Content',
    'moduleContentEmpty': 'Empty',
    'moduleContentEmptyCaption': 'Add forms, tables, and filters here next.',
    'modulePlannedSections': 'Planned sections',
    'connectedWorkspace': 'Your workspace now surfaces the full product, sales, people, and operations stack from one compact control center.',
    'signedInAs': 'Signed in as',
    'readyToManage': 'Ready to manage',
    'catalogSummary': 'Keep products, categories, tags, and supplier-specific inventory organized from one place.',
    'salesSummary': 'Track invoices, returns, and payment workflows without digging through separate screens.',
    'peopleSummary': 'Manage customers, clients, users, and role assignments as one connected team layer.',
    'operationsSummary': 'Monitor stock movement, financial activity, stores, and reporting from the same dashboard.',
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
    'settings': 'Settings',
    'theme': 'Theme',
    'appBarBehavior': 'App bar behavior',
    'stickyAppBar': 'Sticky app bar',
    'hideAppBarOnScroll': 'Hide app bar on scroll down',
    'storagePreference': 'Storage preference',
    'storageHybrid': 'Online + local',
    'storageHybridDescription': 'Try online first and fall back to local storage if it fails. This keeps data available from anywhere when online and is recommended.',
    'storageOnlineOnly': 'Online only',
    'storageOnlineOnlyDescription': 'Always store data online so it stays available from anywhere.',
    'storageLocalOnly': 'Store local',
    'storageLocalOnlyDescription': 'Store data only on this device. Shared data will not be available everywhere.',
    'recommended': 'Recommended',
    'darkMode': 'Dark mode',
    'lightMode': 'Light mode',
    'systemMode': 'System mode',
    'recentEmails': 'Recent emails',
    'language': 'Language',
    'english': 'English',
    'arabic': 'العربية',
    'showCreate': 'Show create',
    'hideCreate': 'Hide create',
    'showOrHideCreateForm': 'Show or hide the create form.',
    'reset': 'Reset',
    'close': 'Close',
    'cancel': 'Cancel',
    'logoutQuestion': 'Sign out?',
    'logoutWarning': 'You will need to sign in again to continue using the workspace.',
    'closeApplicationQuestion': 'Close application?',
    'closeApplicationWarning': 'Any unsaved data will be lost if you close the app now.',
    'closeAnyway': 'Close anyway',
    'delete': 'Delete',
    'actions': 'Actions',
    'rows': 'Rows',
    'rowsPerPage': 'Rows per page',
    'searchTable': 'Search table',
    'searchTableHint': 'Search across the visible columns.',
    'clearSearch': 'Clear search',
    'noMatchingRecords': 'No records match the current search.',
    'noDataAvailable': 'No data available.',
    'dataTableTitle': '{title} Datatable',
    'recordsHeader': '{entity} records',
    'createEntity': 'Create {entity}',
    'saveEntity': 'Save {entity}',
    'editEntity': 'Edit {entity}',
    'updateEntity': 'Update {entity}',
    'deleteEntityQuestion': 'Delete {entity}?',
    'entityDetails': '{entity} Details',
    'addEntityToTable': 'Add a new {entity} to the table.',
    'actionsColumnHint': 'View, edit, and delete are in the last column.',
    'deleteEntityMessage': 'The selected {entity} will be removed.',
    'savedEntitySuccessfully': 'Saved {entity} successfully.',
    'updatedEntitySuccessfully': 'Updated {entity} successfully.',
    'deletedEntitySuccessfully': 'Deleted {entity} successfully.',
    'viewEntity': 'View {entity}',
    'previousPage': 'Previous page',
    'nextPage': 'Next page',
    'addFieldRequired': '{field} is required',
    'validFieldRequired': 'Enter a valid {field}',
    'fieldMustBeInteger': '{field} must be an integer',
    'fieldMustBeNumber': '{field} must be a number',
    'fieldMustUseDateTimeFormat': '{field} must use YYYY-MM-DD or YYYY-MM-DD HH:MM',
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
    'bodyFontFamily': 'Cairo',
    'displayFontFamily': 'Cairo',
    'appTitle': 'إدارة المتجر',
    'menu': 'القائمة',
    'dashboard': 'لوحة التحكم',
    'products': 'المنتجات',
    'customers': 'العملاء',
    'clients': 'العملاء المحتملون',
    'suppliers': 'الموردون',
    'stores': 'المتاجر',
    'branches': 'الفروع',
    'storeBranches': 'فروع المتاجر',
    'categories': 'الفئات',
    'tags': 'الوسوم',
    'supplierProducts': 'منتجات المورد',
    'invoices': 'الفواتير',
    'invoiceItems': 'عناصر الفاتورة',
    'returns': 'المرتجعات',
    'returnItems': 'عناصر المرتجع',
    'paymentVouchers': 'سندات الدفع',
    'paymentAllocations': 'تخصيصات الدفع',
    'users': 'المستخدمون',
    'storeUsers': 'مستخدمو المتجر',
    'roles': 'الأدوار',
    'userRoles': 'أدوار المستخدمين',
    'storeSuppliers': 'موردو المتجر',
    'inventory': 'المخزون',
    'transactions': 'المعاملات',
    'overview': 'نظرة عامة',
    'catalog': 'الكتالوج',
    'sales': 'المبيعات',
    'people': 'الأشخاص',
    'operations': 'العمليات',
    'activeModules': 'الوحدات النشطة',
    'quickActions': 'إجراءات سريعة',
    'moduleStatusTitle': 'الحالة',
    'moduleStatusReady': 'جاهز',
    'moduleStatusReadyCaption': 'التنقل نشط وهذه الشاشة متصلة.',
    'moduleContentTitle': 'المحتوى',
    'moduleContentEmpty': 'فارغ',
    'moduleContentEmptyCaption': 'أضف النماذج والجداول والفلاتر هنا لاحقًا.',
    'modulePlannedSections': 'الأقسام المخطط لها',
    'connectedWorkspace': 'تعرض مساحة العمل الآن كامل طبقات المنتجات والمبيعات والأشخاص والعمليات من مركز تحكم واحد مضغوط.',
    'signedInAs': 'تم تسجيل الدخول باسم',
    'readyToManage': 'جاهز للإدارة',
    'catalogSummary': 'نظّم المنتجات والفئات والوسوم ومخزون الشركة من مكان واحد.',
    'salesSummary': 'تابع الفواتير والمرتجعات وتدفقات الدفع بدون التنقل بين شاشات منفصلة.',
    'peopleSummary': 'أدر العملاء والمستخدمين وتعيينات الأدوار كطبقة فريق مترابطة.',
    'operationsSummary': 'راقب حركة المخزون والنشاط المالي والمتاجر والتقارير من نفس اللوحة.',
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
    'settings': 'الإعدادات',
    'theme': 'المظهر',
    'appBarBehavior': 'سلوك شريط التطبيق',
    'stickyAppBar': 'شريط تطبيق ثابت',
    'hideAppBarOnScroll': 'إخفاء شريط التطبيق عند التمرير لأسفل',
    'storagePreference': 'تفضيل التخزين',
    'storageHybrid': 'عبر الإنترنت + محلي',
    'storageHybridDescription': 'جرّب الحفظ عبر الإنترنت أولًا ثم استخدم التخزين المحلي إذا فشل. هذا يجعل البيانات متاحة من أي مكان عند الاتصال بالإنترنت وهو الخيار الموصى به.',
    'storageOnlineOnly': 'عبر الإنترنت فقط',
    'storageOnlineOnlyDescription': 'احفظ البيانات دائمًا عبر الإنترنت لتبقى متاحة من أي مكان.',
    'storageLocalOnly': 'تخزين محلي',
    'storageLocalOnlyDescription': 'احفظ البيانات على هذا الجهاز فقط. لن تكون البيانات المشتركة متاحة في كل مكان.',
    'recommended': 'موصى به',
    'darkMode': 'الوضع الداكن',
    'lightMode': 'الوضع الفاتح',
    'systemMode': 'وضع النظام',
    'recentEmails': 'رسائل البريد الأخيرة',
    'language': 'اللغة',
    'english': 'English',
    'arabic': 'العربية',
    'showCreate': 'إظهار الإنشاء',
    'hideCreate': 'إخفاء الإنشاء',
    'showOrHideCreateForm': 'إظهار أو إخفاء نموذج الإنشاء.',
    'reset': 'إعادة تعيين',
    'close': 'إغلاق',
    'cancel': 'إلغاء',
    'logoutQuestion': 'تسجيل الخروج؟',
    'logoutWarning': 'ستحتاج إلى تسجيل الدخول مرة أخرى لمتابعة استخدام مساحة العمل.',
    'closeApplicationQuestion': 'إغلاق التطبيق؟',
    'closeApplicationWarning': 'ستفقد أي بيانات غير محفوظة إذا أغلقت التطبيق الآن.',
    'closeAnyway': 'إغلاق على أي حال',
    'delete': 'حذف',
    'actions': 'الإجراءات',
    'rows': 'الصفوف',
    'rowsPerPage': 'عدد الصفوف في الصفحة',
    'searchTable': 'بحث في الجدول',
    'searchTableHint': 'ابحث في جميع الأعمدة الظاهرة.',
    'clearSearch': 'مسح البحث',
    'noMatchingRecords': 'لا توجد سجلات تطابق البحث الحالي.',
    'noDataAvailable': 'لا توجد بيانات.',
    'dataTableTitle': 'جدول {title}',
    'recordsHeader': 'سجلات {entity}',
    'createEntity': 'إنشاء {entity}',
    'saveEntity': 'حفظ {entity}',
    'editEntity': 'تعديل {entity}',
    'updateEntity': 'تحديث {entity}',
    'deleteEntityQuestion': 'حذف {entity}؟',
    'entityDetails': 'تفاصيل {entity}',
    'addEntityToTable': 'أضف {entity} جديدًا إلى الجدول.',
    'actionsColumnHint': 'العرض والتعديل والحذف موجودة في العمود الأخير.',
    'deleteEntityMessage': 'سيتم حذف {entity} المحدد.',
    'savedEntitySuccessfully': 'تم حفظ {entity} بنجاح.',
    'updatedEntitySuccessfully': 'تم تحديث {entity} بنجاح.',
    'deletedEntitySuccessfully': 'تم حذف {entity} بنجاح.',
    'viewEntity': 'عرض {entity}',
    'previousPage': 'الصفحة السابقة',
    'nextPage': 'الصفحة التالية',
    'addFieldRequired': '{field} مطلوب',
    'validFieldRequired': 'أدخل {field} صالحًا',
    'fieldMustBeInteger': 'يجب أن يكون {field} عددًا صحيحًا',
    'fieldMustBeNumber': 'يجب أن يكون {field} رقمًا',
    'fieldMustUseDateTimeFormat': 'يجب أن يستخدم {field} التنسيق YYYY-MM-DD أو YYYY-MM-DD HH:MM',
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

  String get bodyFontFamily => _text('bodyFontFamily');
  String get displayFontFamily => _text('displayFontFamily');

  String get appTitle => _text('appTitle');
  String get menu => _text('menu');
  String get dashboard => _text('dashboard');
  String get products => _text('products');
  String get customers => _text('customers');
  String get clients => _text('clients');
  String get suppliers => _text('suppliers');
  String get stores => _text('stores');
  String get branches => _text('branches');
  String get storeBranches => _text('storeBranches');
  String get categories => _text('categories');
  String get tags => _text('tags');
  String get supplierProducts => _text('supplierProducts');
  String get invoices => _text('invoices');
  String get invoiceItems => _text('invoiceItems');
  String get returns => _text('returns');
  String get returnItems => _text('returnItems');
  String get paymentVouchers => _text('paymentVouchers');
  String get paymentAllocations => _text('paymentAllocations');
  String get users => _text('users');
  String get storeUsers => _text('storeUsers');
  String get roles => _text('roles');
  String get userRoles => _text('userRoles');
  String get storeSuppliers => _text('storeSuppliers');
  String get inventory => _text('inventory');
  String get transactions => _text('transactions');
  String get overview => _text('overview');
  String get catalog => _text('catalog');
  String get sales => _text('sales');
  String get people => _text('people');
  String get operations => _text('operations');
  String get activeModules => _text('activeModules');
  String get quickActions => _text('quickActions');
  String get moduleStatusTitle => _text('moduleStatusTitle');
  String get moduleStatusReady => _text('moduleStatusReady');
  String get moduleStatusReadyCaption => _text('moduleStatusReadyCaption');
  String get moduleContentTitle => _text('moduleContentTitle');
  String get moduleContentEmpty => _text('moduleContentEmpty');
  String get moduleContentEmptyCaption => _text('moduleContentEmptyCaption');
  String get modulePlannedSections => _text('modulePlannedSections');
  String get connectedWorkspace => _text('connectedWorkspace');
  String get signedInAs => _text('signedInAs');
  String get readyToManage => _text('readyToManage');
  String get catalogSummary => _text('catalogSummary');
  String get salesSummary => _text('salesSummary');
  String get peopleSummary => _text('peopleSummary');
  String get operationsSummary => _text('operationsSummary');
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
  String get settings => _text('settings');
  String get theme => _text('theme');
  String get appBarBehavior => _text('appBarBehavior');
  String get stickyAppBar => _text('stickyAppBar');
  String get hideAppBarOnScroll => _text('hideAppBarOnScroll');
  String get storagePreference => _text('storagePreference');
  String get storageHybrid => _text('storageHybrid');
  String get storageHybridDescription => _text('storageHybridDescription');
  String get storageOnlineOnly => _text('storageOnlineOnly');
  String get storageOnlineOnlyDescription => _text('storageOnlineOnlyDescription');
  String get storageLocalOnly => _text('storageLocalOnly');
  String get storageLocalOnlyDescription => _text('storageLocalOnlyDescription');
  String get recommended => _text('recommended');
  String get darkMode => _text('darkMode');
  String get lightMode => _text('lightMode');
  String get systemMode => _text('systemMode');
  String get recentEmails => _text('recentEmails');
  String get language => _text('language');
  String get english => _text('english');
  String get arabic => _text('arabic');
  String get showCreate => _text('showCreate');
  String get hideCreate => _text('hideCreate');
  String get showOrHideCreateForm => _text('showOrHideCreateForm');
  String get reset => _text('reset');
  String get close => _text('close');
  String get cancel => _text('cancel');
  String get logoutQuestion => _text('logoutQuestion');
  String get logoutWarning => _text('logoutWarning');
  String get closeApplicationQuestion => _text('closeApplicationQuestion');
  String get closeApplicationWarning => _text('closeApplicationWarning');
  String get closeAnyway => _text('closeAnyway');
  String get deleteLabel => _text('delete');
  String get actions => _text('actions');
  String get rows => _text('rows');
  String get rowsPerPage => _text('rowsPerPage');
  String get searchTable => _text('searchTable');
  String get searchTableHint => _text('searchTableHint');
  String get clearSearch => _text('clearSearch');
  String get noMatchingRecords => _text('noMatchingRecords');
  String get noDataAvailable => _text('noDataAvailable');
  String dataTableTitle(String title) => _text('dataTableTitle', {'title': title});
  String recordsHeader(String entity) => _text('recordsHeader', {'entity': entity});
  String createEntity(String entity) => _text('createEntity', {'entity': entity});
  String saveEntity(String entity) => _text('saveEntity', {'entity': entity});
  String editEntity(String entity) => _text('editEntity', {'entity': entity});
  String updateEntity(String entity) => _text('updateEntity', {'entity': entity});
  String deleteEntityQuestion(String entity) => _text('deleteEntityQuestion', {'entity': entity});
  String entityDetails(String entity) => _text('entityDetails', {'entity': entity});
  String addEntityToTable(String entity) => _text('addEntityToTable', {'entity': entity});
  String get actionsColumnHint => _text('actionsColumnHint');
  String deleteEntityMessage(String entity) => _text('deleteEntityMessage', {'entity': entity});
  String savedEntitySuccessfully(String entity) => _text('savedEntitySuccessfully', {'entity': entity});
  String updatedEntitySuccessfully(String entity) => _text('updatedEntitySuccessfully', {'entity': entity});
  String deletedEntitySuccessfully(String entity) => _text('deletedEntitySuccessfully', {'entity': entity});
  String viewEntity(String entity) => _text('viewEntity', {'entity': entity});
  String get previousPage => _text('previousPage');
  String get nextPage => _text('nextPage');
  String fieldRequired(String field) => _text('addFieldRequired', {'field': field});
  String validField(String field) => _text('validFieldRequired', {'field': field});
  String fieldMustBeInteger(String field) => _text('fieldMustBeInteger', {'field': field});
  String fieldMustBeNumber(String field) => _text('fieldMustBeNumber', {'field': field});
  String fieldMustUseDateTimeFormat(String field) => _text('fieldMustUseDateTimeFormat', {'field': field});

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
