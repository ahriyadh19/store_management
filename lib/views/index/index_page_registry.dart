import 'package:flutter/material.dart';
import 'package:store_management/controllers/auth_controller.dart';
import 'package:store_management/localization/app_localizations.dart';
import 'package:store_management/views/index/dashboard_home_page.dart';
import 'package:store_management/views/index/index_page.dart';
import 'package:store_management/views/index/module_page_view.dart';

Map<IndexPage, IndexPageDefinition> buildIndexPageDefinitions(BuildContext context, AuthState authState) {
  final l10n = context.l10n;

  return {
    IndexPage.dashboard: IndexPageDefinition(
      title: l10n.dashboard,
      body: DashboardHomePage(authState: authState),
    ),
    IndexPage.reports: _modulePage(
      title: l10n.reports,
      icon: Icons.bar_chart_rounded,
      description: 'Track store performance, sales movement, and operational summaries from one place.',
      highlights: ['Sales summary', 'Store performance', 'Export area'],
    ),
    IndexPage.stores: _modulePage(
      title: l10n.stores,
      icon: Icons.store_mall_directory_rounded,
      description: 'Manage the main store records that organize your business structure.',
      highlights: ['Store profile', 'Contacts', 'Availability'],
    ),
    IndexPage.branches: _modulePage(
      title: l10n.branches,
      icon: Icons.storefront_rounded,
      description: 'Set up branch locations and keep each location ready for inventory and sales flows.',
      highlights: ['Branch list', 'Addresses', 'Assignments'],
    ),
    IndexPage.products: _modulePage(
      title: l10n.products,
      icon: Icons.inventory_2_rounded,
      description: 'Prepare the product catalog with stock-ready items, pricing, and identifiers.',
      highlights: ['Product table', 'Pricing', 'Availability'],
    ),
    IndexPage.categories: _modulePage(
      title: l10n.categories,
      icon: Icons.category_rounded,
      description: 'Organize products into clear category structures for faster browsing and maintenance.',
      highlights: ['Category tree', 'Parent categories', 'Sorting'],
    ),
    IndexPage.tags: _modulePage(
      title: l10n.tags,
      icon: Icons.sell_rounded,
      description: 'Label products with reusable tags for search, filtering, and grouping.',
      highlights: ['Tag list', 'Usage tracking', 'Quick filters'],
    ),
    IndexPage.invoices: _modulePage(
      title: l10n.invoices,
      icon: Icons.receipt_long_rounded,
      description: 'Create and review invoices for daily selling activity and customer billing.',
      highlights: ['Invoice list', 'Totals', 'Invoice details'],
    ),
    IndexPage.returns: _modulePage(
      title: l10n.returns,
      icon: Icons.assignment_return_rounded,
      description: 'Handle product returns and keep return records aligned with inventory movement.',
      highlights: ['Return records', 'Reason codes', 'Status flow'],
    ),
    IndexPage.paymentVouchers: _modulePage(
      title: l10n.paymentVouchers,
      icon: Icons.account_balance_wallet_rounded,
      description: 'Record incoming and outgoing payment vouchers linked to financial activity.',
      highlights: ['Voucher list', 'Allocations', 'Source links'],
    ),
    IndexPage.clients: _modulePage(
      title: l10n.clients,
      icon: Icons.support_agent_rounded,
      description: 'Maintain client profiles used across invoicing, reporting, and communication.',
      highlights: ['Client table', 'Credit info', 'Activity history'],
    ),
    IndexPage.companies: _modulePage(
      title: l10n.companies,
      icon: Icons.apartment_rounded,
      description: 'Store company records and connect them to products, branches, and operations.',
      highlights: ['Company list', 'Contacts', 'Relationships'],
    ),
    IndexPage.users: _modulePage(
      title: l10n.users,
      icon: Icons.person_outline_rounded,
      description: 'Manage user access and prepare the workspace for permission-based actions.',
      highlights: ['User list', 'Assignments', 'Access state'],
    ),
    IndexPage.roles: _modulePage(
      title: l10n.roles,
      icon: Icons.admin_panel_settings_rounded,
      description: 'Define role structures that shape who can access each area of the application.',
      highlights: ['Role matrix', 'Permissions', 'Role assignment'],
    ),
    IndexPage.inventory: _modulePage(
      title: l10n.inventory,
      icon: Icons.warehouse_rounded,
      description: 'Track inventory operations and prepare movement tools for stock control.',
      highlights: ['Stock balance', 'Movements', 'Adjustments'],
    ),
    IndexPage.transactions: _modulePage(
      title: l10n.transactions,
      icon: Icons.sync_alt_rounded,
      description: 'Review operational and financial transactions in a single navigation area.',
      highlights: ['Transaction feed', 'Filters', 'Linked records'],
    ),
  };
}

IndexPageDefinition _modulePage({required String title, required IconData icon, required String description, List<String> highlights = const []}) {
  return IndexPageDefinition(
    title: title,
    body: ModulePageView(title: title, icon: icon, description: description, highlights: highlights),
  );
}
