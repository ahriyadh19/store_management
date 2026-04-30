import 'package:flutter/material.dart';
import 'package:store_management/localization/app_localizations.dart';
import 'package:store_management/models/roles.dart';
import 'package:store_management/views/pages/model_crud_page.dart';
import 'package:store_management/views/pages/model_module_pages.dart';

class RolesPage extends StatelessWidget {
  const RolesPage({
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
    final l10n = context.l10n;
    return ModelCrudPage<Roles>(
      title: title,
      entityLabel: roleEntityLabel(l10n),
      description: description,
      icon: icon,
      highlights: highlights,
      formDefinition: roleFormDefinition(l10n),
    );
  }
}
