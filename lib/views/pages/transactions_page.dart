import 'package:flutter/material.dart';
import 'package:store_management/models/store_financial_transaction.dart';
import 'package:store_management/views/pages/model_crud_page.dart';
import 'package:store_management/views/pages/model_module_pages.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.highlights = const <String>[],
  });

  final String title;
  final String description;
  final IconData icon;
  final List<String> highlights;

  @override
  Widget build(BuildContext context) {
    return ModelCrudPage<StoreFinancialTransaction>(
      title: title,
      entityLabel: 'Transaction',
      description: description,
      icon: icon,
      highlights: highlights,
      formDefinition: transactionFormDefinition,
    );
  }
}
