import 'package:flutter/material.dart';
import 'package:store_management/models/client.dart';
import 'package:store_management/views/pages/model_crud_page.dart';
import 'package:store_management/views/pages/model_module_pages.dart';

class ClientsPage extends StatelessWidget {
  const ClientsPage({
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
    return ModelCrudPage<Client>(
      title: title,
      entityLabel: 'Client',
      description: description,
      icon: icon,
      highlights: highlights,
      formDefinition: clientFormDefinition,
    );
  }
}
