import 'package:flutter/material.dart';
import 'package:store_management/models/store.dart';
import 'package:store_management/views/pages/model_crud_page.dart';
import 'package:store_management/views/pages/model_module_pages.dart';

class StoresPage extends StatelessWidget {
  const StoresPage({
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
    return ModelCrudPage<Store>(
      title: title,
      entityLabel: 'Store',
      description: description,
      icon: icon,
      highlights: highlights,
      formDefinition: storeFormDefinition,
    );
  }
}
