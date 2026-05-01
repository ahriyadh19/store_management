import 'package:flutter/material.dart';
import 'package:store_management/controllers/auth_controller.dart';
import 'package:store_management/localization/app_localizations.dart';
import 'package:store_management/localization/locale_controller.dart';
import 'package:store_management/services/app_preferences_controller.dart';
import 'package:store_management/views/index/dashboard_home_page.dart';
import 'package:store_management/views/index/index_page.dart';
import 'package:store_management/views/index/module_page_view.dart';
import 'package:store_management/views/pages/main_module_pages.dart';
import 'package:store_management/views/pages/settings_page.dart';

Map<IndexPage, IndexPageDefinition> buildIndexPageDefinitions(BuildContext context, AuthState authState, {required LocaleController localeController, required AppPreferencesController appPreferencesController}) {
  final l10n = context.l10n;

  return {
    IndexPage.dashboard: IndexPageDefinition(
      title: l10n.dashboard,
      bodyBuilder: (_) => DashboardHomePage(authState: authState),
    ),
    IndexPage.reports: _placeholderModulePage(
      title: l10n.reports,
      icon: Icons.bar_chart_rounded,
      description: _t(l10n, 'Track store performance, sales movement, and operational summaries from one place.', 'تابع أداء المتجر وحركة المبيعات والملخصات التشغيلية من مكان واحد.'),
      highlights: _list(l10n, ['Sales summary', 'Store performance', 'Export area'], ['ملخص المبيعات', 'أداء المتجر', 'منطقة التصدير']),
    ),
    IndexPage.stores: _modulePage(
      page: IndexPage.stores,
      title: l10n.stores,
      icon: Icons.store_mall_directory_rounded,
      description: _t(l10n, 'Manage the main store records that organize your business structure.', 'أدر سجلات المتجر الرئيسية التي تنظم هيكل أعمالك.'),
      highlights: _list(l10n, ['Store profile', 'Contacts', 'Availability'], ['ملف المتجر', 'جهات الاتصال', 'التوفر']),
    ),
    IndexPage.branches: _modulePage(
      page: IndexPage.branches,
      title: l10n.branches,
      icon: Icons.storefront_rounded,
      description: _t(l10n, 'Set up branch locations and keep each location ready for inventory and sales flows.', 'هيئ مواقع الفروع واجعل كل موقع جاهزًا لتدفقات المخزون والمبيعات.'),
      highlights: _list(l10n, ['Branch list', 'Addresses', 'Assignments'], ['قائمة الفروع', 'العناوين', 'التعيينات']),
    ),
    IndexPage.products: _modulePage(
      page: IndexPage.products,
      title: l10n.products,
      icon: Icons.inventory_2_rounded,
      description: _t(l10n, 'Prepare the product catalog with stock-ready items, pricing, and identifiers.', 'جهز كتالوج المنتجات بعناصر جاهزة للمخزون مع الأسعار والمعرّفات.'),
      highlights: _list(l10n, ['Product table', 'Pricing', 'Availability'], ['جدول المنتجات', 'التسعير', 'التوفر']),
    ),
    IndexPage.categories: _modulePage(
      page: IndexPage.categories,
      title: l10n.categories,
      icon: Icons.category_rounded,
      description: _t(l10n, 'Organize products into clear category structures for faster browsing and maintenance.', 'نظّم المنتجات ضمن هياكل فئات واضحة لتصفح وصيانة أسرع.'),
      highlights: _list(l10n, ['Category tree', 'Parent categories', 'Sorting'], ['شجرة الفئات', 'الفئات الأصلية', 'الترتيب']),
    ),
    IndexPage.tags: _modulePage(
      page: IndexPage.tags,
      title: l10n.tags,
      icon: Icons.sell_rounded,
      description: _t(l10n, 'Label products with reusable tags for search, filtering, and grouping.', 'وسم المنتجات بوسوم قابلة لإعادة الاستخدام للبحث والتصفية والتجميع.'),
      highlights: _list(l10n, ['Tag list', 'Usage tracking', 'Quick filters'], ['قائمة الوسوم', 'تتبع الاستخدام', 'فلاتر سريعة']),
    ),
    IndexPage.invoices: _modulePage(
      page: IndexPage.invoices,
      title: l10n.invoices,
      icon: Icons.receipt_long_rounded,
      description: _t(l10n, 'Create and review invoices for daily selling activity and customer billing.', 'أنشئ وراجع الفواتير لنشاط البيع اليومي وفوترة العملاء.'),
      highlights: _list(l10n, ['Invoice list', 'Totals', 'Invoice details'], ['قائمة الفواتير', 'الإجماليات', 'تفاصيل الفاتورة']),
    ),
    IndexPage.returns: _modulePage(
      page: IndexPage.returns,
      title: l10n.returns,
      icon: Icons.assignment_return_rounded,
      description: _t(l10n, 'Handle product returns and keep return records aligned with inventory movement.', 'تعامل مع مرتجعات المنتجات وحافظ على توافق سجلات المرتجعات مع حركة المخزون.'),
      highlights: _list(l10n, ['Return records', 'Reason codes', 'Status flow'], ['سجلات المرتجعات', 'أكواد الأسباب', 'تدفق الحالة']),
    ),
    IndexPage.paymentVouchers: _modulePage(
      page: IndexPage.paymentVouchers,
      title: l10n.paymentVouchers,
      icon: Icons.account_balance_wallet_rounded,
      description: _t(l10n, 'Record incoming and outgoing payment vouchers linked to financial activity.', 'سجل سندات الدفع الواردة والصادرة المرتبطة بالنشاط المالي.'),
      highlights: _list(l10n, ['Voucher list', 'Allocations', 'Source links'], ['قائمة السندات', 'التخصيصات', 'روابط المصدر']),
    ),
    IndexPage.clients: _modulePage(
      page: IndexPage.clients,
      title: l10n.clients,
      icon: Icons.support_agent_rounded,
      description: _t(l10n, 'Maintain client profiles used across invoicing, reporting, and communication.', 'حافظ على ملفات العملاء المستخدمة عبر الفوترة والتقارير والتواصل.'),
      highlights: _list(l10n, ['Client table', 'Credit info', 'Activity history'], ['جدول العملاء', 'معلومات الائتمان', 'سجل النشاط']),
    ),
    IndexPage.companies: _modulePage(
      page: IndexPage.companies,
      title: l10n.companies,
      icon: Icons.apartment_rounded,
      description: _t(l10n, 'Store company records and connect them to products, branches, and operations.', 'احفظ سجلات الشركات واربطها بالمنتجات والفروع والعمليات.'),
      highlights: _list(l10n, ['Company list', 'Contacts', 'Relationships'], ['قائمة الشركات', 'جهات الاتصال', 'العلاقات']),
    ),
    IndexPage.users: _modulePage(
      page: IndexPage.users,
      title: l10n.users,
      icon: Icons.person_outline_rounded,
      description: _t(l10n, 'Manage user access and prepare the workspace for permission-based actions.', 'أدر وصول المستخدمين وجهز مساحة العمل للإجراءات المعتمدة على الصلاحيات.'),
      highlights: _list(l10n, ['User list', 'Assignments', 'Access state'], ['قائمة المستخدمين', 'التعيينات', 'حالة الوصول']),
    ),
    IndexPage.roles: _modulePage(
      page: IndexPage.roles,
      title: l10n.roles,
      icon: Icons.admin_panel_settings_rounded,
      description: _t(l10n, 'Define role structures that shape who can access each area of the application.', 'عرّف هياكل الأدوار التي تحدد من يمكنه الوصول إلى كل جزء من التطبيق.'),
      highlights: _list(l10n, ['Role matrix', 'Permissions', 'Role assignment'], ['مصفوفة الأدوار', 'الصلاحيات', 'تعيين الدور']),
    ),
    IndexPage.inventory: _modulePage(
      page: IndexPage.inventory,
      title: l10n.inventory,
      icon: Icons.warehouse_rounded,
      description: _t(l10n, 'Track inventory operations and prepare movement tools for stock control.', 'تابع عمليات المخزون وجهز أدوات الحركة للتحكم في الرصيد.'),
      highlights: _list(l10n, ['Stock balance', 'Movements', 'Adjustments'], ['رصيد المخزون', 'الحركات', 'التسويات']),
    ),
    IndexPage.transactions: _modulePage(
      page: IndexPage.transactions,
      title: l10n.transactions,
      icon: Icons.sync_alt_rounded,
      description: _t(l10n, 'Review operational and financial transactions in a single navigation area.', 'راجع العمليات التشغيلية والمالية في مساحة تنقل واحدة.'),
      highlights: _list(l10n, ['Transaction feed', 'Filters', 'Linked records'], ['سجل العمليات', 'الفلاتر', 'السجلات المرتبطة']),
    ),
    IndexPage.settings: IndexPageDefinition(
      title: l10n.settings,
      bodyBuilder: (_) => SettingsPage(localeController: localeController, appPreferencesController: appPreferencesController),
    ),
  };
}

String _t(AppLocalizations l10n, String english, String arabic) {
  return l10n.isArabic ? arabic : english;
}

List<String> _list(AppLocalizations l10n, List<String> english, List<String> arabic) {
  return l10n.isArabic ? arabic : english;
}

IndexPageDefinition _modulePage({required IndexPage page, required String title, required IconData icon, required String description, List<String> highlights = const []}) {
  return IndexPageDefinition(
    title: title,
    bodyBuilder: (_) => buildMainModulePage(page: page, title: title, description: description, icon: icon, highlights: highlights),
  );
}

IndexPageDefinition _placeholderModulePage({required String title, required IconData icon, required String description, List<String> highlights = const []}) {
  return IndexPageDefinition(
    title: title,
    bodyBuilder: (_) => ModulePageView(title: title, icon: icon, description: description, highlights: highlights),
  );
}
