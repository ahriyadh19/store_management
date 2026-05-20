import 'package:flutter/material.dart';
import 'package:store_management/localization/app_localizations.dart';

enum IndexPage { dashboard, reports, stores, branches, products, categories, tags, invoices, returns, paymentVouchers, clients, suppliers, users, roles, inventory, transactions, settings }

enum IndexPageMenuSection { overview, catalog, sales, people, operations }

enum IndexPageTabGroup { overview, catalog, sales, people, operations, system }

class IndexPageMetadata {
  const IndexPageMetadata({
    required this.routeKey,
    required this.permissionKey,
    required this.menuSection,
    required this.tabGroup,
    required this.icon,
    required this.iconName,
    this.countsAsModule = true,
    this.supportsModuleScaffold = true,
  });

  final String routeKey;
  final String permissionKey;
  final IndexPageMenuSection menuSection;
  final IndexPageTabGroup tabGroup;
  final IconData icon;
  final String iconName;
  final bool countsAsModule;
  final bool supportsModuleScaffold;
}

const Map<IndexPage, IndexPageMetadata> _indexPageMetadata = <IndexPage, IndexPageMetadata>{
  IndexPage.dashboard: IndexPageMetadata(
    routeKey: 'dashboard',
    permissionKey: 'page.dashboard.view',
    menuSection: IndexPageMenuSection.overview,
    tabGroup: IndexPageTabGroup.overview,
    icon: Icons.dashboard_rounded,
    iconName: 'dashboard_rounded',
    countsAsModule: false,
    supportsModuleScaffold: false,
  ),
  IndexPage.reports: IndexPageMetadata(
    routeKey: 'reports',
    permissionKey: 'page.reports.view',
    menuSection: IndexPageMenuSection.overview,
    tabGroup: IndexPageTabGroup.overview,
    icon: Icons.bar_chart_rounded,
    iconName: 'bar_chart_rounded',
    countsAsModule: false,
    supportsModuleScaffold: false,
  ),
  IndexPage.stores: IndexPageMetadata(
    routeKey: 'stores',
    permissionKey: 'page.stores.view',
    menuSection: IndexPageMenuSection.overview,
    tabGroup: IndexPageTabGroup.overview,
    icon: Icons.store_mall_directory_rounded,
    iconName: 'store_mall_directory_rounded',
  ),
  IndexPage.branches: IndexPageMetadata(
    routeKey: 'branches',
    permissionKey: 'page.branches.view',
    menuSection: IndexPageMenuSection.overview,
    tabGroup: IndexPageTabGroup.overview,
    icon: Icons.storefront_rounded,
    iconName: 'storefront_rounded',
  ),
  IndexPage.products: IndexPageMetadata(
    routeKey: 'products',
    permissionKey: 'page.products.view',
    menuSection: IndexPageMenuSection.catalog,
    tabGroup: IndexPageTabGroup.catalog,
    icon: Icons.inventory_2_rounded,
    iconName: 'inventory_2_rounded',
  ),
  IndexPage.categories: IndexPageMetadata(
    routeKey: 'categories',
    permissionKey: 'page.categories.view',
    menuSection: IndexPageMenuSection.catalog,
    tabGroup: IndexPageTabGroup.catalog,
    icon: Icons.category_rounded,
    iconName: 'category_rounded',
  ),
  IndexPage.tags: IndexPageMetadata(routeKey: 'tags', permissionKey: 'page.tags.view', menuSection: IndexPageMenuSection.catalog, tabGroup: IndexPageTabGroup.catalog, icon: Icons.sell_rounded, iconName: 'sell_rounded'),
  IndexPage.invoices: IndexPageMetadata(
    routeKey: 'invoices',
    permissionKey: 'page.invoices.view',
    menuSection: IndexPageMenuSection.sales,
    tabGroup: IndexPageTabGroup.sales,
    icon: Icons.receipt_long_rounded,
    iconName: 'receipt_long_rounded',
  ),
  IndexPage.returns: IndexPageMetadata(
    routeKey: 'returns',
    permissionKey: 'page.returns.view',
    menuSection: IndexPageMenuSection.sales,
    tabGroup: IndexPageTabGroup.sales,
    icon: Icons.assignment_return_rounded,
    iconName: 'assignment_return_rounded',
  ),
  IndexPage.paymentVouchers: IndexPageMetadata(
    routeKey: 'paymentVouchers',
    permissionKey: 'page.paymentVouchers.view',
    menuSection: IndexPageMenuSection.sales,
    tabGroup: IndexPageTabGroup.sales,
    icon: Icons.account_balance_wallet_rounded,
    iconName: 'account_balance_wallet_rounded',
  ),
  IndexPage.clients: IndexPageMetadata(
    routeKey: 'clients',
    permissionKey: 'page.clients.view',
    menuSection: IndexPageMenuSection.people,
    tabGroup: IndexPageTabGroup.people,
    icon: Icons.support_agent_rounded,
    iconName: 'support_agent_rounded',
  ),
  IndexPage.suppliers: IndexPageMetadata(
    routeKey: 'suppliers',
    permissionKey: 'page.suppliers.view',
    menuSection: IndexPageMenuSection.people,
    tabGroup: IndexPageTabGroup.people,
    icon: Icons.apartment_rounded,
    iconName: 'apartment_rounded',
  ),
  IndexPage.users: IndexPageMetadata(
    routeKey: 'users',
    permissionKey: 'page.users.view',
    menuSection: IndexPageMenuSection.people,
    tabGroup: IndexPageTabGroup.people,
    icon: Icons.person_outline_rounded,
    iconName: 'person_outline_rounded',
  ),
  IndexPage.roles: IndexPageMetadata(
    routeKey: 'roles',
    permissionKey: 'page.roles.view',
    menuSection: IndexPageMenuSection.people,
    tabGroup: IndexPageTabGroup.people,
    icon: Icons.admin_panel_settings_rounded,
    iconName: 'admin_panel_settings_rounded',
  ),
  IndexPage.inventory: IndexPageMetadata(
    routeKey: 'inventory',
    permissionKey: 'page.inventory.view',
    menuSection: IndexPageMenuSection.operations,
    tabGroup: IndexPageTabGroup.operations,
    icon: Icons.warehouse_rounded,
    iconName: 'warehouse_rounded',
  ),
  IndexPage.transactions: IndexPageMetadata(
    routeKey: 'transactions',
    permissionKey: 'page.transactions.view',
    menuSection: IndexPageMenuSection.operations,
    tabGroup: IndexPageTabGroup.operations,
    icon: Icons.sync_alt_rounded,
    iconName: 'sync_alt_rounded',
  ),
  IndexPage.settings: IndexPageMetadata(
    routeKey: 'settings',
    permissionKey: 'page.settings.view',
    menuSection: IndexPageMenuSection.operations,
    tabGroup: IndexPageTabGroup.system,
    icon: Icons.settings_rounded,
    iconName: 'settings_rounded',
    countsAsModule: false,
    supportsModuleScaffold: false,
  ),
};

IndexPageMetadata indexPageMetadata(IndexPage page) => _indexPageMetadata[page]!;

Iterable<IndexPage> get allIndexPages => IndexPage.values;

String localizedIndexPageTitle(AppLocalizations l10n, IndexPage page) {
  return switch (page) {
    IndexPage.dashboard => l10n.dashboard,
    IndexPage.reports => l10n.reports,
    IndexPage.stores => l10n.stores,
    IndexPage.branches => l10n.branches,
    IndexPage.products => l10n.products,
    IndexPage.categories => l10n.categories,
    IndexPage.tags => l10n.tags,
    IndexPage.invoices => l10n.invoices,
    IndexPage.returns => l10n.returns,
    IndexPage.paymentVouchers => l10n.paymentVouchers,
    IndexPage.clients => l10n.clients,
    IndexPage.suppliers => l10n.suppliers,
    IndexPage.users => l10n.users,
    IndexPage.roles => l10n.roles,
    IndexPage.inventory => l10n.inventory,
    IndexPage.transactions => l10n.transactions,
    IndexPage.settings => l10n.settings,
  };
}

String localizedIndexPageDescription(AppLocalizations l10n, IndexPage page) {
  return switch (page) {
    IndexPage.dashboard => _t(l10n, 'Review business activity, alerts, and key system indicators at a glance.', 'راجع نشاط العمل والتنبيهات ومؤشرات النظام الرئيسية بسرعة.'),
    IndexPage.reports => _t(l10n, 'Analyze profitability, inventory health, and synchronization trends.', 'حلل الربحية وصحة المخزون واتجاهات المزامنة.'),
    IndexPage.stores => _t(l10n, 'Manage the main store records that organize your business structure.', 'أدر سجلات المتجر الرئيسية التي تنظم هيكل أعمالك.'),
    IndexPage.branches => _t(l10n, 'Set up branch locations and keep each location ready for inventory and sales flows.', 'هيئ مواقع الفروع واجعل كل موقع جاهزًا لتدفقات المخزون والمبيعات.'),
    IndexPage.products => _t(l10n, 'Prepare the product catalog with stock-ready items, pricing, and identifiers.', 'جهز كتالوج المنتجات بعناصر جاهزة للمخزون مع الأسعار والمعرّفات.'),
    IndexPage.categories => _t(l10n, 'Organize products into clear category structures for faster browsing and maintenance.', 'نظّم المنتجات ضمن هياكل فئات واضحة لتصفح وصيانة أسرع.'),
    IndexPage.tags => _t(l10n, 'Label products with reusable tags for search, filtering, and grouping.', 'وسم المنتجات بوسوم قابلة لإعادة الاستخدام للبحث والتصفية والتجميع.'),
    IndexPage.invoices => _t(l10n, 'Create and review invoices for daily selling activity and customer billing.', 'أنشئ وراجع الفواتير لنشاط البيع اليومي وفوترة العملاء.'),
    IndexPage.returns => _t(l10n, 'Handle product returns and keep return records aligned with inventory movement.', 'تعامل مع مرتجعات المنتجات وحافظ على توافق سجلات المرتجعات مع حركة المخزون.'),
    IndexPage.paymentVouchers => _t(l10n, 'Record incoming and outgoing payment vouchers linked to financial activity.', 'سجل سندات الدفع الواردة والصادرة المرتبطة بالنشاط المالي.'),
    IndexPage.clients => _t(l10n, 'Maintain client profiles used across invoicing, reporting, and communication.', 'حافظ على ملفات العملاء المستخدمة عبر الفوترة والتقارير والتواصل.'),
    IndexPage.suppliers => _t(l10n, 'Store supplier records and connect them to products, branches, and operations.', 'احفظ سجلات الموردين واربطها بالمنتجات والفروع والعمليات.'),
    IndexPage.users => _t(l10n, 'Manage user access and prepare the workspace for permission-based actions.', 'أدر وصول المستخدمين وجهز مساحة العمل للإجراءات المعتمدة على الصلاحيات.'),
    IndexPage.roles => _t(l10n, 'Define role structures that shape who can access each area of the application.', 'عرّف هياكل الأدوار التي تحدد من يمكنه الوصول إلى كل جزء من التطبيق.'),
    IndexPage.inventory => _t(l10n, 'Track inventory operations and prepare movement tools for stock control.', 'تابع عمليات المخزون وجهز أدوات الحركة للتحكم في الرصيد.'),
    IndexPage.transactions => _t(l10n, 'Review operational and financial transactions in a single navigation area.', 'راجع العمليات التشغيلية والمالية في مساحة تنقل واحدة.'),
    IndexPage.settings => _t(l10n, 'Control language, theme, and workspace preferences.', 'تحكم في اللغة والمظهر وتفضيلات مساحة العمل.'),
  };
}

List<String> localizedIndexPageHighlights(AppLocalizations l10n, IndexPage page) {
  return switch (page) {
    IndexPage.dashboard => _list(l10n, <String>['Overview', 'Alerts', 'Quick actions'], <String>['نظرة عامة', 'تنبيهات', 'إجراءات سريعة']),
    IndexPage.reports => _list(l10n, <String>['Analytics', 'Sync health', 'Trends'], <String>['تحليلات', 'صحة المزامنة', 'اتجاهات']),
    IndexPage.stores => _list(l10n, <String>['Store profile', 'Contacts', 'Availability'], <String>['ملف المتجر', 'جهات الاتصال', 'التوفر']),
    IndexPage.branches => _list(l10n, <String>['Branch list', 'Addresses', 'Assignments'], <String>['قائمة الفروع', 'العناوين', 'التعيينات']),
    IndexPage.products => _list(l10n, <String>['Product table', 'Pricing', 'Availability'], <String>['جدول المنتجات', 'التسعير', 'التوفر']),
    IndexPage.categories => _list(l10n, <String>['Category tree', 'Parent categories', 'Sorting'], <String>['شجرة الفئات', 'الفئات الأصلية', 'الترتيب']),
    IndexPage.tags => _list(l10n, <String>['Tag list', 'Usage tracking', 'Quick filters'], <String>['قائمة الوسوم', 'تتبع الاستخدام', 'فلاتر سريعة']),
    IndexPage.invoices => _list(l10n, <String>['Invoice list', 'Totals', 'Invoice details'], <String>['قائمة الفواتير', 'الإجماليات', 'تفاصيل الفاتورة']),
    IndexPage.returns => _list(l10n, <String>['Return records', 'Reason codes', 'Status flow'], <String>['سجلات المرتجعات', 'أكواد الأسباب', 'تدفق الحالة']),
    IndexPage.paymentVouchers => _list(l10n, <String>['Voucher list', 'Allocations', 'Source links'], <String>['قائمة السندات', 'التخصيصات', 'روابط المصدر']),
    IndexPage.clients => _list(l10n, <String>['Client table', 'Credit info', 'Activity history'], <String>['جدول العملاء', 'معلومات الائتمان', 'سجل النشاط']),
    IndexPage.suppliers => _list(l10n, <String>['Supplier list', 'Contacts', 'Relationships'], <String>['قائمة الموردين', 'جهات الاتصال', 'العلاقات']),
    IndexPage.users => _list(l10n, <String>['User list', 'Assignments', 'Access state'], <String>['قائمة المستخدمين', 'التعيينات', 'حالة الوصول']),
    IndexPage.roles => _list(l10n, <String>['Role matrix', 'Permissions', 'Role assignment'], <String>['مصفوفة الأدوار', 'الصلاحيات', 'تعيين الدور']),
    IndexPage.inventory => _list(l10n, <String>['Stock balance', 'Movements', 'Adjustments'], <String>['رصيد المخزون', 'الحركات', 'التسويات']),
    IndexPage.transactions => _list(l10n, <String>['Transaction feed', 'Filters', 'Linked records'], <String>['سجل العمليات', 'الفلاتر', 'السجلات المرتبطة']),
    IndexPage.settings => const <String>[],
  };
}

String _t(AppLocalizations l10n, String english, String arabic) {
  return l10n.isArabic ? arabic : english;
}

List<String> _list(AppLocalizations l10n, List<String> english, List<String> arabic) {
  return l10n.isArabic ? arabic : english;
}

extension IndexPageStorage on IndexPage {
  String get storageKey => name;

  static IndexPage fromStorageKey(String? value) {
    for (final page in IndexPage.values) {
      if (page.name == value) {
        return page;
      }
    }

    return IndexPage.dashboard;
  }
}

class IndexPageDefinition {
  const IndexPageDefinition({required this.title, required this.bodyBuilder});

  final String title;
  final WidgetBuilder bodyBuilder;
}
