import 'package:flutter/material.dart';
import 'package:store_management/models/inventory_movement.dart';
import 'package:store_management/views/pages/model_crud_page.dart';
import 'package:store_management/views/pages/model_module_pages.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({
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
    return ModelCrudPage<InventoryMovement>(
      title: title,
      entityLabel: 'Inventory movement',
      description: description,
      icon: icon,
      highlights: highlights,
      formDefinition: inventoryMovementFormDefinition,
    );
  }
}
