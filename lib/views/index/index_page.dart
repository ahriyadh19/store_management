import 'package:flutter/widgets.dart';

enum IndexPage { dashboard, reports, stores, branches, products, categories, tags, invoices, returns, paymentVouchers, clients, suppliers, users, roles, inventory, transactions, settings }

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
