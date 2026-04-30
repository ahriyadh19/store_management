import 'package:flutter/material.dart';
import 'package:store_management/views/index/index_page.dart';
import 'package:store_management/views/pages/branches_page.dart';
import 'package:store_management/views/pages/categories_page.dart';
import 'package:store_management/views/pages/clients_page.dart';
import 'package:store_management/views/pages/companies_page.dart';
import 'package:store_management/views/pages/inventory_page.dart';
import 'package:store_management/views/pages/invoices_page.dart';
import 'package:store_management/views/pages/payment_vouchers_page.dart';
import 'package:store_management/views/pages/products_page.dart';
import 'package:store_management/views/pages/returns_page.dart';
import 'package:store_management/views/pages/roles_page.dart';
import 'package:store_management/views/pages/stores_page.dart';
import 'package:store_management/views/pages/tags_page.dart';
import 'package:store_management/views/pages/transactions_page.dart';
import 'package:store_management/views/pages/users_page.dart';

Widget buildMainModulePage({
  required IndexPage page,
  required String title,
  required String description,
  required IconData icon,
  List<String> highlights = const <String>[],
}) {
  switch (page) {
    case IndexPage.stores:
      return StoresPage(title: title, description: description, icon: icon, highlights: highlights);
    case IndexPage.branches:
      return BranchesPage(title: title, description: description, icon: icon, highlights: highlights);
    case IndexPage.products:
      return ProductsPage(title: title, description: description, icon: icon, highlights: highlights);
    case IndexPage.categories:
      return CategoriesPage(title: title, description: description, icon: icon, highlights: highlights);
    case IndexPage.tags:
      return TagsPage(title: title, description: description, icon: icon, highlights: highlights);
    case IndexPage.invoices:
      return InvoicesPage(title: title, description: description, icon: icon, highlights: highlights);
    case IndexPage.returns:
      return ReturnsPage(title: title, description: description, icon: icon, highlights: highlights);
    case IndexPage.paymentVouchers:
      return PaymentVouchersPage(title: title, description: description, icon: icon, highlights: highlights);
    case IndexPage.clients:
      return ClientsPage(title: title, description: description, icon: icon, highlights: highlights);
    case IndexPage.companies:
      return CompaniesPage(title: title, description: description, icon: icon, highlights: highlights);
    case IndexPage.users:
      return UsersPage(title: title, description: description, icon: icon, highlights: highlights);
    case IndexPage.roles:
      return RolesPage(title: title, description: description, icon: icon, highlights: highlights);
    case IndexPage.inventory:
      return InventoryPage(title: title, description: description, icon: icon, highlights: highlights);
    case IndexPage.transactions:
      return TransactionsPage(title: title, description: description, icon: icon, highlights: highlights);
    default:
      throw ArgumentError('No concrete page is configured for $page');
  }
}
