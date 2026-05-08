import 'package:flutter/material.dart';
import 'package:store_management/services/access_control_service.dart';

class PermissionVisualEditorDialog extends StatefulWidget {
  const PermissionVisualEditorDialog({super.key, required this.initialValues});

  final Map<String, dynamic> initialValues;

  @override
  State<PermissionVisualEditorDialog> createState() => _PermissionVisualEditorDialogState();
}

class _PermissionVisualEditorDialogState extends State<PermissionVisualEditorDialog> {
  late final Map<String, bool?> _values;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _values = <String, bool?>{};
    for (final entry in widget.initialValues.entries) {
      final raw = entry.value;
      if (raw is bool) {
        _values[entry.key] = raw;
      } else if (raw is num) {
        _values[entry.key] = raw != 0;
      } else if (raw is String) {
        final normalized = raw.trim().toLowerCase();
        if (normalized == 'true' || normalized == 'allow' || normalized == '1') {
          _values[entry.key] = true;
        } else if (normalized == 'false' || normalized == 'deny' || normalized == '0') {
          _values[entry.key] = false;
        }
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final groups = PermissionCatalog.permissionGroups();
    final query = _searchController.text.trim().toLowerCase();

    return AlertDialog(
      title: const Text('Permission Editor'),
      content: SizedBox(
        width: 880,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search permissions',
                hintText: 'Search by key or label',
                prefixIcon: Icon(Icons.search_rounded),
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: [
                  for (final group in groups)
                    _buildGroup(
                      group,
                      query: query,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final output = <String, dynamic>{
              for (final entry in _values.entries)
                if (entry.value != null) entry.key: entry.value,
            };
            Navigator.of(context).pop(output);
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }

  Widget _buildGroup(PermissionGroupDefinition group, {required String query}) {
    final visible = group.options.where((option) {
      if (query.isEmpty) {
        return true;
      }
      return option.key.toLowerCase().contains(query) ||
          option.label.toLowerCase().contains(query) ||
          (option.description?.toLowerCase().contains(query) ?? false);
    }).toList(growable: false);

    if (visible.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ExpansionTile(
        title: Text(group.title),
        initiallyExpanded: query.isNotEmpty,
        children: [
          for (final option in visible)
            CheckboxListTile(
              tristate: true,
              value: _values[option.key],
              title: Text(option.label),
              subtitle: Text(option.description ?? option.key),
              secondary: _stateIcon(_values[option.key]),
              onChanged: (next) {
                setState(() {
                  _values[option.key] = next;
                });
              },
            ),
        ],
      ),
    );
  }

  Widget _stateIcon(bool? state) {
    if (state == true) {
      return const Icon(Icons.check_circle_outline_rounded, color: Colors.green);
    }
    if (state == false) {
      return const Icon(Icons.block_rounded, color: Colors.red);
    }
    return const Icon(Icons.remove_circle_outline_rounded, color: Colors.grey);
  }
}
