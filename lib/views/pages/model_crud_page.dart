import 'package:flutter/material.dart';
import 'package:store_management/views/components/model_form.dart';

enum CreateFormVisibility { show, hide }

enum ModelCrudMode { create, edit }

class ModelCrudPage<T extends Object> extends StatefulWidget {
  const ModelCrudPage({
    super.key,
    required this.title,
    required this.entityLabel,
    required this.description,
    required this.icon,
    required this.formDefinition,
    this.highlights = const <String>[],
  });

  final String title;
  final String entityLabel;
  final String description;
  final IconData icon;
  final ModelFormDefinition<T> formDefinition;
  final List<String> highlights;

  @override
  State<ModelCrudPage<T>> createState() => _ModelCrudPageState<T>();
}

class _ModelCrudPageState<T extends Object> extends State<ModelCrudPage<T>> {
  late final List<T> _records;
  late T _draftModel;
  CreateFormVisibility _createFormVisibility = CreateFormVisibility.show;

  @override
  void initState() {
    super.initState();
    _draftModel = widget.formDefinition.sampleModel;
    _records = <T>[
      widget.formDefinition.sampleModel,
      widget.formDefinition.buildModel(
        widget.formDefinition.toMap(widget.formDefinition.sampleModel),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ModuleHeader(
                title: widget.title,
                description: widget.description,
                icon: widget.icon,
                highlights: widget.highlights,
              ),
              const SizedBox(height: 24),
              _buildCreateFormToggle(context),
              if (_createFormVisibility == CreateFormVisibility.show) ...[
                const SizedBox(height: 16),
                _buildCreateFormCard(context),
              ],
              const SizedBox(height: 24),
              _buildTableCard(context, constraints),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCreateFormToggle(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create ${widget.entityLabel}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Use the radio buttons to show or hide the create form above the ${widget.title.toLowerCase()} table.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _CreateFormRadioButton(
                  label: 'Show form',
                  value: CreateFormVisibility.show,
                  groupValue: _createFormVisibility,
                  onChanged: _handleCreateFormVisibilityChanged,
                ),
                _CreateFormRadioButton(
                  label: 'Hide form',
                  value: CreateFormVisibility.hide,
                  groupValue: _createFormVisibility,
                  onChanged: _handleCreateFormVisibilityChanged,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateFormCard(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Save ${widget.entityLabel}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Create a new ${widget.entityLabel.toLowerCase()} and it will be added directly to the table below.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ModelForm(
              key: ValueKey('${widget.entityLabel}-create-${widget.formDefinition.toMap(_draftModel)}'),
              definition: widget.formDefinition.fields,
              initialData: widget.formDefinition.toMap(_draftModel),
              submitLabel: 'Save ${widget.entityLabel}',
              cancelLabel: 'Reset',
              onCancel: () {
                setState(() {
                  _draftModel = widget.formDefinition.sampleModel;
                });
              },
              onSubmit: _handleCreateSubmit,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableCard(BuildContext context, BoxConstraints constraints) {
    final columns = _buildColumns();
    final rows = _buildRows(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.title} Datatable',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Each row shows ${widget.entityLabel.toLowerCase()} information with view, edit, and delete actions in the last column.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                _SummaryChip(label: 'Rows', value: _records.length.toString()),
              ],
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth - 48),
                  child: DataTable(
                    columns: columns,
                    rows: rows,
                    columnSpacing: 24,
                    dataRowMinHeight: 64,
                    dataRowMaxHeight: 72,
                    headingRowColor: WidgetStateProperty.resolveWith(
                      (_) => Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    final visibleFields = _visibleFields;
    return [
      for (final field in visibleFields) DataColumn(label: Text(field.label)),
      const DataColumn(label: Text('Actions')),
    ];
  }

  List<DataRow> _buildRows(BuildContext context) {
    return _records.map((record) {
      final data = widget.formDefinition.toMap(record);
      return DataRow(
        cells: [
          for (final field in _visibleFields)
            DataCell(
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 180),
                child: Text(
                  _formatCellValue(data[field.key]),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ),
          DataCell(
            Wrap(
              spacing: 8,
              children: [
                IconButton(
                  tooltip: 'View ${widget.entityLabel}',
                  onPressed: () => _openDetailsPage(record),
                  icon: const Icon(Icons.visibility_outlined),
                ),
                IconButton(
                  tooltip: 'Edit ${widget.entityLabel}',
                  onPressed: () => _showEditSheet(record),
                  icon: const Icon(Icons.edit_outlined),
                ),
                IconButton(
                  tooltip: 'Delete ${widget.entityLabel}',
                  onPressed: () => _confirmDelete(record),
                  icon: Icon(Icons.delete_outline_rounded, color: Theme.of(context).colorScheme.error),
                ),
              ],
            ),
          ),
        ],
      );
    }).toList();
  }

  List<ModelFormFieldDefinition> get _visibleFields {
    final preferredFields = widget.formDefinition.fields.take(5).toList();
    if (preferredFields.isNotEmpty) {
      return preferredFields;
    }
    return widget.formDefinition.fields;
  }

  void _handleCreateFormVisibilityChanged(CreateFormVisibility? value) {
    if (value == null) {
      return;
    }
    setState(() {
      _createFormVisibility = value;
    });
  }

  void _handleCreateSubmit(Map<String, dynamic> values) {
    final model = widget.formDefinition.buildModel(values);
    setState(() {
      _records.insert(0, model);
      _draftModel = widget.formDefinition.sampleModel;
      _createFormVisibility = CreateFormVisibility.hide;
    });
    _showFeedback('Saved ${widget.entityLabel.toLowerCase()} successfully.');
  }

  Future<void> _showEditSheet(T record) async {
    final updatedModel = await showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 12,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Edit ${widget.entityLabel}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Update the selected ${widget.entityLabel.toLowerCase()} in a modal sheet, then submit the changes.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  ModelForm(
                    definition: widget.formDefinition.fields,
                    initialData: widget.formDefinition.toMap(record),
                    submitLabel: 'Update ${widget.entityLabel}',
                    cancelLabel: 'Close',
                    onCancel: () => Navigator.of(context).pop(),
                    onSubmit: (values) {
                      final model = widget.formDefinition.buildModel(values, existingModel: record);
                      Navigator.of(context).pop(model);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (updatedModel == null) {
      return;
    }

    final index = _indexOfRecord(record);
    if (index == -1) {
      return;
    }

    setState(() {
      _records[index] = updatedModel;
    });
    _showFeedback('Updated ${widget.entityLabel.toLowerCase()} successfully.');
  }

  Future<void> _confirmDelete(T record) async {
    final details = widget.formDefinition.toMap(record);
    final didDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        return AlertDialog(
          title: Text('Delete ${widget.entityLabel}?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This is a destructive action. The selected ${widget.entityLabel.toLowerCase()} will be removed from the table.',
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colorScheme.error.withValues(alpha: 0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _recordTitle(details),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    for (final field in _visibleFields.take(3)) ...[
                      Text('${field.label}: ${_formatCellValue(details[field.key])}'),
                      const SizedBox(height: 4),
                    ],
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: colorScheme.error),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (didDelete != true) {
      return;
    }

    setState(() {
      _records.removeAt(_indexOfRecord(record));
    });
    _showFeedback('Deleted ${widget.entityLabel.toLowerCase()} successfully.');
  }

  void _openDetailsPage(T record) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => _ModelDetailsPage(
          entityLabel: widget.entityLabel,
          title: widget.title,
          icon: widget.icon,
          data: widget.formDefinition.toMap(record),
        ),
      ),
    );
  }

  int _indexOfRecord(T record) {
    final target = widget.formDefinition.toMap(record);
    final targetUuid = target['uuid'];
    if (targetUuid != null) {
      return _records.indexWhere((item) => widget.formDefinition.toMap(item)['uuid'] == targetUuid);
    }

    final targetId = target['id'];
    return _records.indexWhere((item) => widget.formDefinition.toMap(item)['id'] == targetId);
  }

  void _showFeedback(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  String _recordTitle(Map<String, dynamic> data) {
    const titleKeys = ['name', 'invoiceNumber', 'returnNumber', 'voucherNumber', 'transactionNumber', 'username'];
    for (final key in titleKeys) {
      final value = data[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString();
      }
    }
    return '${widget.entityLabel} ${data['uuid'] ?? data['id'] ?? ''}'.trim();
  }

  String _formatCellValue(Object? value) {
    if (value == null) {
      return '-';
    }
    if (value is int && value > 100000000000) {
      final dateTime = DateTime.fromMillisecondsSinceEpoch(value);
      final month = dateTime.month.toString().padLeft(2, '0');
      final day = dateTime.day.toString().padLeft(2, '0');
      return '${dateTime.year}-$month-$day';
    }
    return value.toString();
  }
}

class _ModuleHeader extends StatelessWidget {
  const _ModuleHeader({
    required this.title,
    required this.description,
    required this.icon,
    required this.highlights,
  });

  final String title;
  final String description;
  final IconData icon;
  final List<String> highlights;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primaryContainer,
            colorScheme.secondaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: colorScheme.surface,
                  child: Icon(icon, color: colorScheme.primary),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (highlights.isNotEmpty) ...[
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final highlight in highlights)
                    Chip(
                      label: Text(highlight),
                      avatar: const Icon(Icons.check_circle_outline_rounded, size: 18),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CreateFormRadioButton extends StatelessWidget {
  const _CreateFormRadioButton({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  final String label;
  final CreateFormVisibility value;
  final CreateFormVisibility groupValue;
  final ValueChanged<CreateFormVisibility?> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(999),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: groupValue == value ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                groupValue == value ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                color: groupValue == value ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _ModelDetailsPage extends StatelessWidget {
  const _ModelDetailsPage({
    required this.entityLabel,
    required this.title,
    required this.icon,
    required this.data,
  });

  final String entityLabel;
  final String title;
  final IconData icon;
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$entityLabel Details')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  CircleAvatar(radius: 28, child: Icon(icon)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: Theme.of(context).textTheme.headlineSmall),
                        const SizedBox(height: 8),
                        Text('This details page shows the selected $entityLabel record from the index datatable.'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  for (final entry in data.entries) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 180,
                          child: Text(
                            entry.key,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(child: Text(entry.value?.toString() ?? '-')),
                      ],
                    ),
                    if (entry.key != data.keys.last) const Divider(height: 24),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
