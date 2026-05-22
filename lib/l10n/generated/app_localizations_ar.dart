// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get accessDeniedActionNotAllowed =>
      'تم رفض الوصول: دورك لا يسمح بهذا الإجراء.';

  @override
  String get accessDeniedPageUnavailable =>
      'تم رفض الوصول: هذه الصفحة غير متاحة لدورك.';

  @override
  String get accountCreatedConfirmEmail =>
      'تم إنشاء الحساب. أكد بريدك الإلكتروني قبل تسجيل الدخول.';

  @override
  String get accountCreatedSuccessfully => 'تم إنشاء الحساب بنجاح.';

  @override
  String get actions => 'الإجراءات';

  @override
  String get actionsColumnHint =>
      'العرض والتعديل والحذف موجودة في العمود الأخير.';

  @override
  String get activeModules => 'الوحدات النشطة';

  @override
  String addEntityToTable(Object entity) {
    return 'أضف $entity جديدًا إلى الجدول.';
  }

  @override
  String fieldRequired(Object field) {
    return '$field مطلوب';
  }

  @override
  String get addNew => 'إضافة جديد';

  @override
  String get appBarBehavior => 'سلوك شريط التطبيق';

  @override
  String get appTitle => 'إدارة المتجر';

  @override
  String get apply => 'تطبيق';

  @override
  String get arabic => 'العربية';

  @override
  String get authOperationFailed => 'فشلت المصادقة. يرجى المحاولة مرة أخرى.';

  @override
  String get availablePlatformsSubtitle =>
      'تابع عملك على سطح المكتب والجوال والويب باستخدام الحساب نفسه.';

  @override
  String get availablePlatformsTitle => 'متاح على';

  @override
  String get backToSignIn => 'العودة لتسجيل الدخول';

  @override
  String get batchNumberLabel => 'رقم الدفعة';

  @override
  String get bodyFontFamily => 'Cairo';

  @override
  String get branchUuidLabel => 'معرف الفرع';

  @override
  String get branches => 'الفروع';

  @override
  String get cancel => 'إلغاء';

  @override
  String get catalog => 'الكتالوج';

  @override
  String get catalogSummary =>
      'نظّم المنتجات والفئات والوسوم ومخزون الشركة من مكان واحد.';

  @override
  String get categories => 'الفئات';

  @override
  String get clearSearch => 'مسح البحث';

  @override
  String get clients => 'العملاء المحتملون';

  @override
  String get close => 'إغلاق';

  @override
  String get closeAll => 'إغلاق الكل';

  @override
  String get closeAllTabsQuestion => 'تحذير: إغلاق جميع علامات التبويب؟';

  @override
  String get closeAllUnpinnedTabs => 'إغلاق جميع علامات التبويب غير المثبتة';

  @override
  String get closeAnyway => 'إغلاق على أي حال';

  @override
  String get closeApplicationQuestion => 'إغلاق التطبيق؟';

  @override
  String get closeApplicationWarning =>
      'ستفقد أي بيانات غير محفوظة إذا أغلقت التطبيق الآن.';

  @override
  String get closeTabAction => 'إغلاق علامة التبويب';

  @override
  String get closeTabQuestion => 'إغلاق علامة التبويب؟';

  @override
  String closeTabWarning(Object tab) {
    return 'سيتم إغلاق \"$tab\" وقد تكون بيانات هذه العلامة غير محفوظة.';
  }

  @override
  String get closeTabsToRight => 'إغلاق علامات التبويب إلى اليمين';

  @override
  String get collapseAll => 'طي الكل';

  @override
  String get completeConfirmation => 'إكمال التأكيد';

  @override
  String get completeResetPassword => 'تحديث كلمة المرور';

  @override
  String confirmEmailDescription(Object email) {
    return 'أرسلنا رابط تأكيد إلى $email. افتح الرابط في بريدك الإلكتروني لتأكيد حسابك.';
  }

  @override
  String get confirmEmailPasteHint =>
      'إذا لم يكتمل التأكيد تلقائيًا، انسخ الرابط النهائي من المتصفح والصقه هنا.';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get confirmPasswordHint => 'أعد إدخال كلمة المرور';

  @override
  String get confirmYourEmail => 'أكد بريدك الإلكتروني';

  @override
  String confirmationEmailResent(Object email) {
    return 'تمت إعادة إرسال رسالة التأكيد إلى $email.';
  }

  @override
  String get confirmationLink => 'رابط التأكيد';

  @override
  String get confirmationLinkFullRequired =>
      'الصق رابط التأكيد الكامل من بريدك الإلكتروني.';

  @override
  String get confirmationLinkHint =>
      'https://...token_hash=... أو https://...code=...';

  @override
  String get confirmationLinkMissingDetails =>
      'رابط التأكيد لا يحتوي على بيانات التحقق المطلوبة.';

  @override
  String get confirmationLinkRequired =>
      'الصق رابط التأكيد من بريدك الإلكتروني.';

  @override
  String conflictedRecords(Object count) {
    return 'السجلات المتعارضة: $count';
  }

  @override
  String get connectedWorkspace =>
      'تعرض مساحة العمل الآن كامل طبقات المنتجات والمبيعات والأشخاص والعمليات من مركز تحكم واحد مضغوط.';

  @override
  String get connectionSQLite => 'SQLite (Drift)';

  @override
  String get connectionStatusChecking => 'جارٍ التحقق';

  @override
  String get connectionStatusConnected => 'متصل';

  @override
  String get connectionStatusDisconnected => 'غير متصل';

  @override
  String connectionStatusTooltip(Object source, Object status) {
    return '$source: $status';
  }

  @override
  String get connectionSupabase => 'Supabase';

  @override
  String get continueLabel => 'متابعة';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String createEntity(Object entity) {
    return 'إنشاء $entity';
  }

  @override
  String get createdAt => 'تاريخ الإنشاء';

  @override
  String get customers => 'العملاء';

  @override
  String get dangerCloseAllUnpinnedTabsQuestion =>
      'تحذير: إغلاق جميع علامات التبويب غير المثبتة؟';

  @override
  String get dangerCloseAllUnpinnedTabsWarning => 'سيتم إغلاق الصفحات التالية:';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get dashboard => 'لوحة التحكم';

  @override
  String dataTableTitle(Object title) {
    return 'جدول $title';
  }

  @override
  String get deleteLabel => 'حذف';

  @override
  String deleteEntityMessage(Object entity) {
    return 'سيتم حذف $entity المحدد.';
  }

  @override
  String deleteEntityQuestion(Object entity) {
    return 'حذف $entity؟';
  }

  @override
  String deletedEntitySuccessfully(Object entity) {
    return 'تم حذف $entity بنجاح.';
  }

  @override
  String get displayFontFamily => 'Cairo';

  @override
  String editEntity(Object entity) {
    return 'تعديل $entity';
  }

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get emailAndPasswordRequired =>
      'البريد الإلكتروني وكلمة المرور مطلوبان.';

  @override
  String get emailConfirmedSignIn =>
      'تم تأكيد البريد الإلكتروني. سجّل الدخول للمتابعة.';

  @override
  String get emailConfirmedSuccessfully => 'تم تأكيد البريد الإلكتروني بنجاح.';

  @override
  String get emailHint => 'name@store.com';

  @override
  String get english => 'English';

  @override
  String entityDetails(Object entity) {
    return 'تفاصيل $entity';
  }

  @override
  String get expandAll => 'توسيع الكل';

  @override
  String get expiryDateFormatError =>
      'يجب أن يستخدم تاريخ الانتهاء التنسيق YYYY-MM-DD.';

  @override
  String get expiryDateLabel => 'تاريخ الانتهاء (YYYY-MM-DD)';

  @override
  String fieldMustBeInteger(Object field) {
    return 'يجب أن يكون $field عددًا صحيحًا';
  }

  @override
  String fieldMustBeNumber(Object field) {
    return 'يجب أن يكون $field رقمًا';
  }

  @override
  String fieldMustUseDateTimeFormat(Object field) {
    return 'يجب أن يستخدم $field التنسيق YYYY-MM-DD أو YYYY-MM-DD HH:MM';
  }

  @override
  String get forgotPasswordAction => 'نسيت كلمة المرور؟';

  @override
  String get forgotPasswordDescription =>
      'أدخل بريدك الإلكتروني وسنرسل لك رابطًا لإعادة تعيين كلمة المرور.';

  @override
  String get forgotPasswordTitle => 'نسيت كلمة المرور؟';

  @override
  String get hideAppBarOnScroll => 'إخفاء شريط التطبيق عند التمرير لأسفل';

  @override
  String get hideCreate => 'إخفاء الإنشاء';

  @override
  String get inventory => 'المخزون';

  @override
  String get invoiceItems => 'عناصر الفاتورة';

  @override
  String get invoices => 'الفواتير';

  @override
  String get language => 'اللغة';

  @override
  String latestConflictAt(Object dateTime) {
    return 'آخر تعارض في: $dateTime';
  }

  @override
  String get lightMode => 'الوضع الفاتح';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get logoutQuestion => 'تسجيل الخروج؟';

  @override
  String get logoutWarning =>
      'ستحتاج إلى تسجيل الدخول مرة أخرى لمتابعة استخدام مساحة العمل.';

  @override
  String get menu => 'القائمة';

  @override
  String get moduleContentEmpty => 'فارغ';

  @override
  String get moduleContentEmptyCaption =>
      'أضف النماذج والجداول والفلاتر هنا لاحقًا.';

  @override
  String get moduleContentTitle => 'المحتوى';

  @override
  String get modulePlannedSections => 'الأقسام المخطط لها';

  @override
  String get moduleStatusReady => 'جاهز';

  @override
  String get moduleStatusReadyCaption => 'التنقل نشط وهذه الشاشة متصلة.';

  @override
  String get moduleStatusTitle => 'الحالة';

  @override
  String get moveTabLeft => 'نقل علامة التبويب لليسار';

  @override
  String get moveTabRight => 'نقل علامة التبويب لليمين';

  @override
  String get name => 'الاسم';

  @override
  String get nameHint => 'اسم صاحب المتجر';

  @override
  String get nameRequired => 'الاسم مطلوب.';

  @override
  String get nextPage => 'الصفحة التالية';

  @override
  String get noDataAvailable => 'لا توجد بيانات.';

  @override
  String get noMatchingRecords => 'لا توجد سجلات تطابق البحث الحالي.';

  @override
  String noSyncDelegateAvailable(Object entity) {
    return 'لا توجد آلية مزامنة متاحة لـ $entity.';
  }

  @override
  String get noValueSelected => 'لم يتم تحديد قيمة';

  @override
  String get openDashboard => 'فتح لوحة التحكم';

  @override
  String openTabsTooltip(Object count) {
    return 'علامات التبويب المفتوحة ($count)';
  }

  @override
  String get openVisualPermissionEditor => 'فتح محرر الصلاحيات المرئي';

  @override
  String get operations => 'العمليات';

  @override
  String get operationsSummary =>
      'راقب حركة المخزون والنشاط المالي والمتاجر والتقارير من نفس اللوحة.';

  @override
  String get overview => 'نظرة عامة';

  @override
  String get ownerUuidLabel => 'معرف المالك';

  @override
  String get password => 'كلمة المرور';

  @override
  String get passwordHint => '6 أحرف على الأقل';

  @override
  String passwordResetInstructionsSent(Object email) {
    return 'تم إرسال تعليمات إعادة تعيين كلمة المرور إلى $email.';
  }

  @override
  String get passwordTooShort => 'يجب أن تكون كلمة المرور 6 أحرف على الأقل.';

  @override
  String get passwordUpdatedSuccessfully => 'تم تحديث كلمة المرور بنجاح.';

  @override
  String get passwordsDoNotMatch => 'كلمتا المرور غير متطابقتين.';

  @override
  String get paymentAllocations => 'تخصيصات الدفع';

  @override
  String get paymentVouchers => 'سندات الدفع';

  @override
  String get people => 'الأشخاص';

  @override
  String get peopleSummary =>
      'أدر العملاء والمستخدمين وتعيينات الأدوار كطبقة فريق مترابطة.';

  @override
  String get permissionEditorTitle => 'محرر الصلاحيات';

  @override
  String get pinTab => 'تثبيت علامة التبويب';

  @override
  String get platformAndroid => 'أندرويد';

  @override
  String get platformIos => 'iOS';

  @override
  String get platformLinux => 'لينكس';

  @override
  String get platformMacos => 'macOS';

  @override
  String get platformWeb => 'الويب';

  @override
  String get platformWindows => 'ويندوز';

  @override
  String get postPurchaseReceipt => 'ترحيل استلام الشراء';

  @override
  String get posting => 'جارٍ الترحيل...';

  @override
  String get previousPage => 'الصفحة السابقة';

  @override
  String get productUuidLabel => 'معرف المنتج';

  @override
  String get products => 'المنتجات';

  @override
  String purchaseReceiptPostFailed(Object error) {
    return 'فشل ترحيل استلام الشراء: $error';
  }

  @override
  String purchaseReceiptPosted(Object batchUuid) {
    return 'تم ترحيل استلام الشراء. الدفعة: $batchUuid';
  }

  @override
  String get purchaseReceiving => 'استلام المشتريات';

  @override
  String get purchaseReceivingDescription =>
      'أنشئ دفعة مخزون وسجّل استلام الشراء في إجراء واحد.';

  @override
  String get quantityLabel => 'الكمية';

  @override
  String get quickActions => 'إجراءات سريعة';

  @override
  String get readyToManage => 'جاهز للإدارة';

  @override
  String get recentEmails => 'رسائل البريد الأخيرة';

  @override
  String get recommended => 'موصى به';

  @override
  String get recommendedLabel => 'الموصى به:';

  @override
  String get recordSyncedSuccessfully => 'تمت مزامنة السجل بنجاح.';

  @override
  String recordsHeader(Object entity) {
    return 'سجلات $entity';
  }

  @override
  String get refresh => 'تحديث';

  @override
  String get reports => 'التقارير';

  @override
  String get resendEmail => 'إعادة إرسال البريد';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get resetLink => 'رابط إعادة التعيين';

  @override
  String get resetLinkFullRequired =>
      'الصق رابط إعادة تعيين كلمة المرور الكامل من بريدك الإلكتروني.';

  @override
  String get resetLinkHint =>
      'https://...token_hash=... أو https://...code=...';

  @override
  String get resetLinkMissingDetails =>
      'رابط إعادة تعيين كلمة المرور لا يحتوي على بيانات التحقق المطلوبة.';

  @override
  String get resetLinkRequired =>
      'الصق رابط إعادة تعيين كلمة المرور من بريدك الإلكتروني.';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get resetPasswordPasteHint =>
      'الصق رابط إعادة تعيين كلمة المرور من بريدك الإلكتروني، ثم اختر كلمة مرور جديدة.';

  @override
  String resetPasswordSentDescription(Object email) {
    return 'تم إرسال رابط إعادة التعيين إلى $email. استخدم الرابط في بريدك الإلكتروني لاختيار كلمة مرور جديدة.';
  }

  @override
  String get returnItems => 'عناصر المرتجع';

  @override
  String get returns => 'المرتجعات';

  @override
  String get roles => 'الأدوار';

  @override
  String get rows => 'الصفوف';

  @override
  String get rowsPerPage => 'عدد الصفوف في الصفحة';

  @override
  String get sales => 'المبيعات';

  @override
  String get salesSummary =>
      'تابع الفواتير والمرتجعات وتدفقات الدفع بدون التنقل بين شاشات منفصلة.';

  @override
  String saveEntity(Object entity) {
    return 'حفظ $entity';
  }

  @override
  String savedEntitySuccessfully(Object entity) {
    return 'تم حفظ $entity بنجاح.';
  }

  @override
  String get scrollLeft => 'التمرير لليسار';

  @override
  String get scrollRight => 'التمرير لليمين';

  @override
  String get searchAction => 'بحث';

  @override
  String get searchPermissions => 'بحث في الصلاحيات';

  @override
  String get searchPermissionsHint => 'ابحث بالمفتاح أو التسمية';

  @override
  String get searchTable => 'بحث في الجدول';

  @override
  String get searchTableHint => 'ابحث في جميع الأعمدة الظاهرة.';

  @override
  String get sendAgain => 'إرسال مرة أخرى';

  @override
  String get sendResetLink => 'إرسال رابط إعادة التعيين';

  @override
  String get settings => 'الإعدادات';

  @override
  String get showCreate => 'إظهار الإنشاء';

  @override
  String get showOrHideCreateForm => 'إظهار أو إخفاء نموذج الإنشاء.';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get signInFooter =>
      'سجّل الدخول باستخدام بريدك الإلكتروني وكلمة المرور.';

  @override
  String get signInSubtitle => 'استخدم بريدك الإلكتروني وكلمة المرور للمتابعة.';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get signUpFooter => 'أدخل بياناتك أدناه لإنشاء حسابك.';

  @override
  String get signUpSubtitle => 'أنشئ حسابك للبدء.';

  @override
  String get signedInAs => 'تم تسجيل الدخول باسم';

  @override
  String get signedInFallback => 'تم تسجيل دخولك.';

  @override
  String get signedInSuccessfully => 'تم تسجيل الدخول بنجاح.';

  @override
  String get stackTraceLabel => 'تتبّع المكدس';

  @override
  String get staffUserUuidLabel => 'معرف الموظف';

  @override
  String get startupConfigurationError => 'خطأ في إعدادات التشغيل';

  @override
  String get startupRecoveryDesktop =>
      'على سطح المكتب، يمكن أيضًا استخدام .env.local.json من جذر المشروع كخيار احتياطي أثناء التشغيل.';

  @override
  String get startupRecoveryMobile =>
      'على الهاتف المحمول، لا يمكن للتطبيق قراءة .env.local.json مباشرة من جذر المشروع أثناء التشغيل.';

  @override
  String get startupRecoveryMobileHint =>
      'استخدم ملف التشغيل في VS Code \"store_management (env)\" أو مرر --dart-define/--dart-define-from-file يدويًا.';

  @override
  String get startupRecoveryProvideKeys =>
      'وفّر SUPABASE_URL و SUPABASE_ANON_KEY عند التشغيل.';

  @override
  String get stickyAppBar => 'شريط تطبيق ثابت';

  @override
  String get storageHybrid => 'عبر الإنترنت + محلي';

  @override
  String get storageHybridDescription =>
      'يبقى Supabase المصدر المعتمد للمصادقة والمزامنة بينما تعمل SQLite كذاكرة محلية للوصول دون اتصال. أعطال الاتصال تضع التغييرات في قائمة مزامنة لاحقة، وهذا هو الخيار الموصى به.';

  @override
  String get storageLocalOnly => 'تخزين محلي';

  @override
  String get storageLocalOnlyDescription =>
      'احتفظ بالبيانات على هذا الجهاز فقط داخل SQLite. هذا أسرع ويعمل بالكامل دون اتصال، لكنه لا يوفّر مزامنة بين الأجهزة أو تحديثات لحظية أو تحكمًا مركزيًا.';

  @override
  String get storageOnlineOnly => 'عبر الإنترنت فقط';

  @override
  String get storageOnlineOnlyDescription =>
      'يكون Supabase هو المصدر الوحيد للحقيقة. هذا يبسّط مسار التخزين لكنه يعتمد على الشبكة وقد يزيد زمن الاستجابة في العمليات الكبيرة.';

  @override
  String get storagePreference => 'تفضيل التخزين';

  @override
  String get storeBranches => 'فروع المتاجر';

  @override
  String get storeSuppliers => 'موردو المتجر';

  @override
  String get storeUsers => 'مستخدمو المتجر';

  @override
  String get storeUuidLabel => 'معرف المتجر';

  @override
  String get stores => 'المتاجر';

  @override
  String get supplierInvoiceUuidLabel => 'معرف فاتورة المورد';

  @override
  String get supplierProducts => 'منتجات المورد';

  @override
  String get supplierUuidLabel => 'معرف المورد';

  @override
  String get suppliers => 'الموردون';

  @override
  String get sync => 'مزامنة';

  @override
  String get syncAll => 'مزامنة الكل';

  @override
  String get syncConflictDiagnostics => 'تشخيص تعارضات المزامنة';

  @override
  String get syncConflictOverrodePendingLocalEdits =>
      'تجاوزت التغييرات البعيدة التعديلات المحلية المعلقة.';

  @override
  String get synced => 'متزامن';

  @override
  String syncedRecords(Object count) {
    return 'تمت مزامنة $count سجلات.';
  }

  @override
  String get systemMode => 'وضع النظام';

  @override
  String get tags => 'الوسوم';

  @override
  String get theme => 'المظهر';

  @override
  String get transactions => 'المعاملات';

  @override
  String get unauthorizedSectionMessage =>
      'ليست لديك صلاحية الوصول إلى هذا القسم.';

  @override
  String get unitCostLabel => 'تكلفة الوحدة';

  @override
  String get unknown => 'غير معروف';

  @override
  String get unpinTab => 'إلغاء تثبيت علامة التبويب';

  @override
  String updateEntity(Object entity) {
    return 'تحديث $entity';
  }

  @override
  String get updatedAt => 'تاريخ التحديث';

  @override
  String updatedEntitySuccessfully(Object entity) {
    return 'تم تحديث $entity بنجاح.';
  }

  @override
  String get userRoles => 'أدوار المستخدمين';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get usernameHint => 'store_owner';

  @override
  String get usernameInvalid =>
      'يمكن أن يحتوي اسم المستخدم على أحرف وأرقام وشرطة سفلية فقط.';

  @override
  String get usernameRequired => 'اسم المستخدم مطلوب.';

  @override
  String get users => 'المستخدمون';

  @override
  String get validEmailRequired => 'أدخل بريدًا إلكترونيًا صالحًا.';

  @override
  String validField(Object field) {
    return 'أدخل $field صالحًا';
  }

  @override
  String get validPositiveNumbersRequired =>
      'يجب أن تكون الكمية وتكلفة الوحدة أرقامًا موجبة صالحة.';

  @override
  String viewEntity(Object entity) {
    return 'عرض $entity';
  }

  @override
  String get welcomeTitle => 'مرحبًا بك في إدارة المتجر!';
}
