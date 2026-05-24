import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:store_management/data/entity_mapper.dart';
import 'package:store_management/localization/app_localizations.dart';
import 'package:store_management/views/components/app_notification.dart';
import 'package:store_management/views/components/permission_visual_editor_dialog.dart';

enum ModelFormFieldType { text, multiline, email, phone, integer, decimal, dateTime, selection }

class ModelFormSelectOption {
  const ModelFormSelectOption({required this.label, required this.value});

  final String label;
  final Object value;
}

typedef ModelFormCreateOptionDelegate = Future<ModelFormSelectOption?> Function(String query);

class ModelFormFieldDefinition {
  const ModelFormFieldDefinition({
    required this.key,
    required this.label,
    required this.type,
    this.hintText,
    this.helperText,
    this.required = false,
    this.readOnly = false,
    this.options = const [],
    this.searchable = false,
    this.searchButtonLabel,
    this.addNewButtonLabel,
    this.onCreateOption,
    this.transformValue,
    this.formatValue,
    this.validator,
    this.usePermissionVisualEditor = false,
    this.relationTableName,
  });

  final String key;
  final String label;
  final ModelFormFieldType type;
  final String? hintText;
  final String? helperText;
  final bool required;
  final bool readOnly;
  final List<ModelFormSelectOption> options;
  final bool searchable;
  final String? searchButtonLabel;
  final String? addNewButtonLabel;
  final ModelFormCreateOptionDelegate? onCreateOption;
  final Object? Function(Object? rawValue)? transformValue;
  final String Function(Object? value)? formatValue;
  final String? Function(String? value)? validator;
  final bool usePermissionVisualEditor;
  final String? relationTableName;
}

ModelFormFieldDefinition? findModelFormFieldDefinition(List<ModelFormFieldDefinition> fields, String? key) {
  if (key == null) {
    return null;
  }

  for (final field in fields) {
    if (field.key == key) {
      return field;
    }
  }

  return null;
}

bool isModelRelationLikeField(String key) {
  return key.endsWith('Uuid') || key == 'uuid' || key.endsWith('Id') || key == 'id';
}

String formatModelFieldDisplayValue({required List<ModelFormFieldDefinition> fields, required String? fieldKey, required Object? value, required Map<String, dynamic> rowData, AppLocalizations? l10n}) {
  final key = fieldKey;
  final emptyLabel = l10n?.pick('-', '-') ?? '-';
  if (key == 'synced') {
    final boolValue = _boolFromValue(value);
    if (boolValue == null) {
      return value?.toString() ?? emptyLabel;
    }
    return boolValue ? (l10n?.pick('Yes', 'نعم') ?? 'Yes') : (l10n?.pick('No', 'لا') ?? 'No');
  }

  if (key == 'syncedAt') {
    final resolvedValue = value ?? rowData['synced_at'];
    if (resolvedValue == null) {
      return emptyLabel;
    }
    final millis = _millisecondsFromValue(resolvedValue);
    if (millis == null) {
      return resolvedValue.toString();
    }
    final date = DateTime.fromMillisecondsSinceEpoch(millis);
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '${date.year}-$month-$day $hour:$minute';
  }

  if (value == null) {
    return emptyLabel;
  }

  final optionLabel = key == null ? null : _resolveModelFieldOptionLabel(fields: fields, fieldKey: key, value: value);
  if (key != null && isModelRelationLikeField(key)) {
    final raw = value.toString().trim();
    if (raw.isEmpty) {
      return emptyLabel;
    }

    final linkedLabel = _resolveModelLinkedValueLabel(fields: fields, fieldKey: key, rowData: rowData, fallbackOptionLabel: optionLabel);
    final compactIdentifier = _compactIdentifier(raw);
    if (linkedLabel != null) {
      return '$linkedLabel ($compactIdentifier)';
    }
    return compactIdentifier;
  }

  if (optionLabel != null) {
    return optionLabel;
  }

  if (value is int && value > 100000000000) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(value);
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    return '${dateTime.year}-$month-$day';
  }

  if (value is DateTime) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return '${value.year}-$month-$day';
  }

  return value.toString();
}

Object? modelFieldSortValue({required List<ModelFormFieldDefinition> fields, required String? fieldKey, required Object? value, required Map<String, dynamic> rowData, AppLocalizations? l10n}) {
  final key = fieldKey;
  if (key == null) {
    return value;
  }

  if (key == 'syncedAt') {
    return _millisecondsFromValue(value ?? rowData['synced_at']) ?? formatModelFieldDisplayValue(fields: fields, fieldKey: key, value: value, rowData: rowData, l10n: l10n).toLowerCase();
  }

  final field = findModelFormFieldDefinition(fields, key);
  if (field?.type == ModelFormFieldType.selection || isModelRelationLikeField(key)) {
    return formatModelFieldDisplayValue(fields: fields, fieldKey: key, value: value, rowData: rowData, l10n: l10n).toLowerCase();
  }

  if (value is DateTime) {
    return value.millisecondsSinceEpoch;
  }

  return value;
}

String buildModelSearchBlob({required List<ModelFormFieldDefinition> fields, required Map<String, dynamic> rowData, AppLocalizations? l10n}) {
  final searchBuffer = StringBuffer();
  final visitedKeys = <String>{};

  for (final field in fields) {
    visitedKeys.add(field.key);
    final value = rowData[field.key];
    searchBuffer
      ..write(' ')
      ..write(formatModelFieldDisplayValue(fields: fields, fieldKey: field.key, value: value, rowData: rowData, l10n: l10n).toLowerCase())
      ..write(' ')
      ..write(value?.toString().toLowerCase() ?? '');
  }

  for (final entry in rowData.entries) {
    if (!visitedKeys.add(entry.key)) {
      continue;
    }

    searchBuffer
      ..write(' ')
      ..write(entry.key.toLowerCase())
      ..write(' ')
      ..write(entry.value?.toString().toLowerCase() ?? '');
  }

  return searchBuffer.toString();
}

String? _resolveModelFieldOptionLabel({required List<ModelFormFieldDefinition> fields, required String fieldKey, required Object? value}) {
  final field = findModelFormFieldDefinition(fields, fieldKey);
  if (field == null || field.type != ModelFormFieldType.selection || value == null) {
    return null;
  }

  final normalizedValue = value.toString();
  for (final option in field.options) {
    if (option.value == value || option.value.toString() == normalizedValue) {
      final label = option.label.trim();
      if (label.isNotEmpty) {
        return label;
      }
    }
  }

  return null;
}

String? _resolveModelLinkedValueLabel({required List<ModelFormFieldDefinition> fields, required String fieldKey, required Map<String, dynamic> rowData, String? fallbackOptionLabel}) {
  if (fieldKey == 'referenceUuid') {
    final referenceType = rowData['referenceType']?.toString().trim();
    if (referenceType != null && referenceType.isNotEmpty) {
      return referenceType;
    }
  }

  var baseKey = fieldKey;
  if (fieldKey.endsWith('Uuid')) {
    baseKey = fieldKey.substring(0, fieldKey.length - 4);
  } else if (fieldKey.endsWith('Id')) {
    baseKey = fieldKey.substring(0, fieldKey.length - 2);
  }

  final candidateKeys = <String>[
    '${baseKey}Name',
    '${baseKey}Number',
    '${baseKey}Code',
    '${baseKey}Title',
    '${baseKey}Username',
    '${baseKey}Email',
    '${baseKey}_name',
    '${baseKey}_number',
    '${baseKey}_code',
    '${baseKey}_title',
    '${baseKey}_username',
    '${baseKey}_email',
  ];

  if (baseKey == 'client' || baseKey == 'customer') {
    candidateKeys.addAll(const <String>['clientName', 'customerName']);
  }
  if (baseKey == 'user') {
    candidateKeys.addAll(const <String>['userName', 'name', 'username']);
  }
  if (baseKey == 'product') {
    candidateKeys.add('productName');
  }
  if (baseKey == 'branch') {
    candidateKeys.add('branchName');
  }
  if (baseKey == 'store') {
    candidateKeys.add('storeName');
  }

  for (final candidate in candidateKeys) {
    final candidateValue = rowData[candidate];
    if (candidateValue == null) {
      continue;
    }
    final normalized = candidateValue.toString().trim();
    if (normalized.isNotEmpty && normalized != '-') {
      return normalized;
    }
  }

  return fallbackOptionLabel;
}

String _compactIdentifier(String raw) {
  if (raw.length <= 14) {
    return raw;
  }
  return '${raw.substring(0, 8)}...${raw.substring(raw.length - 4)}';
}

bool? _boolFromValue(Object? value) {
  if (value is bool) {
    return value;
  }
  if (value is num) {
    return value != 0;
  }
  if (value is String) {
    final normalized = value.trim().toLowerCase();
    if (normalized == 'true' || normalized == '1' || normalized == 'yes') {
      return true;
    }
    if (normalized == 'false' || normalized == '0' || normalized == 'no') {
      return false;
    }
  }
  return null;
}

int? _millisecondsFromValue(Object? value) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  if (value is DateTime) {
    return value.millisecondsSinceEpoch;
  }
  if (value is String) {
    final asInt = int.tryParse(value.trim());
    if (asInt != null) {
      return asInt;
    }
    final asDate = DateTime.tryParse(value.trim());
    if (asDate != null) {
      return asDate.millisecondsSinceEpoch;
    }
  }
  return null;
}

class ModelQueryRequest {
  const ModelQueryRequest({required this.searchQuery, required this.sortColumnName, required this.sortAscending, required this.pageIndex, required this.pageSize});

  final String searchQuery;
  final String? sortColumnName;
  final bool sortAscending;
  final int pageIndex;
  final int pageSize;
}

class ModelQueryResult<T extends Object> {
  const ModelQueryResult({required this.records, required this.totalCount, this.overallCount});

  final List<T> records;
  final int totalCount;
  final int? overallCount;
}

typedef ModelQueryDelegate<T extends Object> = Future<ModelQueryResult<T>> Function(ModelQueryRequest request);
typedef ModelCreateDelegate<T extends Object> = Future<T> Function(T model);
typedef ModelUpdateDelegate<T extends Object> = Future<T> Function(T model);
typedef ModelDeleteDelegate<T extends Object> = Future<void> Function(T model);
typedef ModelAfterCreateHook<T extends Object> = Future<void> Function({required T model, required Map<String, dynamic> values});
typedef ModelPrepareCreateValuesHook = Future<Map<String, dynamic>> Function(Map<String, dynamic> values);

class ModelFormDefinition<T extends Object> {
  const ModelFormDefinition({
    this.tableName,
    required this.fields,
    required this.mapper,
    required this.sampleModel,
    this.tableFieldPriorityKeys = const <String>[],
    this.queryDelegate,
    this.createDelegate,
    this.updateDelegate,
    this.deleteDelegate,
    this.afterCreateHook,
    this.prepareCreateValues,
  });

  final String? tableName;
  final List<ModelFormFieldDefinition> fields;
  final EntityMapper<T> mapper;
  final T sampleModel;
  final List<String> tableFieldPriorityKeys;
  final ModelQueryDelegate<T>? queryDelegate;
  final ModelCreateDelegate<T>? createDelegate;
  final ModelUpdateDelegate<T>? updateDelegate;
  final ModelDeleteDelegate<T>? deleteDelegate;
  final ModelAfterCreateHook<T>? afterCreateHook;
  final ModelPrepareCreateValuesHook? prepareCreateValues;

  T Function(Map<String, dynamic> map) get fromMap => mapper.fromDomainMap;

  Map<String, dynamic> Function(T model) get toMap => mapper.toDomainMap;

  T buildModel(Map<String, dynamic> values, {T? existingModel}) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final existingData = existingModel == null ? const <String, dynamic>{} : mapper.toDomainMap(existingModel);

    return mapper.fromDomainMap({
      ...existingData,
      ...values,
      'id': values['id'] ?? existingData['id'] ?? 0,
      'uuid': existingData['uuid'],
      'createdAt': existingData['createdAt'] ?? now,
      'updatedAt': now,
    });
  }
}

class ModelForm extends StatefulWidget {
  const ModelForm({
    super.key,
    required this.definition,
    required this.submitLabel,
    required this.onSubmit,
    this.initialData = const <String, dynamic>{},
    this.onCancel,
    this.cancelLabel,
  });

  final List<ModelFormFieldDefinition> definition;
  final Map<String, dynamic> initialData;
  final String submitLabel;
  final ValueChanged<Map<String, dynamic>> onSubmit;
  final VoidCallback? onCancel;
  final String? cancelLabel;

  @override
  State<ModelForm> createState() => _ModelFormState();
}

class _ModelFormState extends State<ModelForm> {
  final _formKey = GlobalKey<FormState>();
  late final Map<String, TextEditingController> _controllers;
  late final Map<String, Object?> _selectedValues;
  late final Map<String, List<ModelFormSelectOption>> _selectionOptions;

  @override
  void initState() {
    super.initState();
    _controllers = {
      for (final field in widget.definition.where((field) => field.type != ModelFormFieldType.selection))
        field.key: TextEditingController(text: _formatInitialValue(field, widget.initialData[field.key])),
    };
    _selectedValues = {
      for (final field in widget.definition.where((field) => field.type == ModelFormFieldType.selection)) field.key: widget.initialData[field.key],
    };
    _selectionOptions = {for (final field in widget.definition.where((field) => field.type == ModelFormFieldType.selection)) field.key: _mergedSelectionOptions(field: field, initialData: widget.initialData)};
  }

  @override
  void didUpdateWidget(covariant ModelForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialData == widget.initialData) {
      return;
    }

    for (final field in widget.definition) {
      if (field.type == ModelFormFieldType.selection) {
        _selectedValues[field.key] = widget.initialData[field.key];
        _selectionOptions[field.key] = _mergedSelectionOptions(field: field, initialData: widget.initialData);
        continue;
      }

      _controllers[field.key]?.text = _formatInitialValue(field, widget.initialData[field.key]);
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return LayoutBuilder(
      builder: (context, constraints) {
        final useTwoColumns = constraints.maxWidth >= 720;
        final halfWidth = useTwoColumns ? (constraints.maxWidth - 16) / 2 : constraints.maxWidth;

        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  for (final field in widget.definition)
                    SizedBox(
                      width: _fieldUsesFullWidth(field, useTwoColumns: useTwoColumns) ? constraints.maxWidth : halfWidth,
                      child: _buildField(context, field),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.end,
                children: [
                  if (widget.onCancel != null) OutlinedButton(onPressed: widget.onCancel, child: Text(widget.cancelLabel ?? l10n.cancel)),
                  FilledButton.icon(onPressed: _handleSubmit, icon: const Icon(Icons.save_rounded), label: Text(widget.submitLabel)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  bool _fieldUsesFullWidth(ModelFormFieldDefinition field, {required bool useTwoColumns}) {
    if (!useTwoColumns) {
      return true;
    }

    return field.type == ModelFormFieldType.multiline;
  }

  Widget _buildField(BuildContext context, ModelFormFieldDefinition field) {
    final l10n = context.l10n;
    if (field.type == ModelFormFieldType.selection) {
      if (field.searchable) {
        return _buildSearchableSelectionField(context, field, l10n);
      }

      final options = _selectionOptions[field.key] ?? field.options;
      return DropdownButtonFormField<Object?>(
        initialValue: _selectedValues[field.key],
        items: options
            .map(
              (option) => DropdownMenuItem<Object?>(
                value: option.value,
                child: Text(option.label),
              ),
            )
            .toList(),
        onChanged: field.readOnly
            ? null
            : (value) {
                setState(() {
                  _selectedValues[field.key] = value;
                });
              },
        decoration: InputDecoration(
          labelText: field.label,
          hintText: field.hintText,
          helperText: field.helperText,
          border: const OutlineInputBorder(),
        ),
        validator: (_) {
          final selected = _selectedValues[field.key];
          if (field.required && selected == null) {
            return l10n.fieldRequired(field.label);
          }
          return null;
        },
      );
    }

    final keyboardType = switch (field.type) {
      ModelFormFieldType.email => TextInputType.emailAddress,
      ModelFormFieldType.phone => TextInputType.phone,
      ModelFormFieldType.integer => TextInputType.number,
      ModelFormFieldType.decimal => const TextInputType.numberWithOptions(decimal: true),
      ModelFormFieldType.dateTime => TextInputType.datetime,
      _ => TextInputType.text,
    };
    final maxLines = field.type == ModelFormFieldType.multiline ? 4 : 1;
    final minLines = field.type == ModelFormFieldType.multiline ? 3 : 1;

    if (field.type == ModelFormFieldType.multiline && field.usePermissionVisualEditor) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _controllers[field.key],
            readOnly: field.readOnly,
            keyboardType: keyboardType,
            minLines: minLines,
            maxLines: maxLines,
            decoration: InputDecoration(labelText: field.label, hintText: field.hintText, helperText: field.helperText, border: const OutlineInputBorder()),
            validator: (value) => _validateField(field, value),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              onPressed: field.readOnly
                  ? null
                  : () async {
                      final controller = _controllers[field.key];
                      if (controller == null) {
                        return;
                      }

                      final initialMap = _parsePermissionMap(controller.text);
                      final updated = await showDialog<Map<String, dynamic>>(
                        context: context,
                        builder: (_) => PermissionVisualEditorDialog(initialValues: initialMap),
                      );

                      if (!mounted || updated == null) {
                        return;
                      }

                      controller.text = const JsonEncoder.withIndent('  ').convert(updated);
                    },
              icon: const Icon(Icons.admin_panel_settings_rounded),
              label: Text(l10n.openVisualPermissionEditor),
            ),
          ),
        ],
      );
    }

    return TextFormField(
      controller: _controllers[field.key],
      readOnly: field.readOnly,
      keyboardType: keyboardType,
      minLines: minLines,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: field.label,
        hintText: field.hintText,
        helperText: field.helperText,
        border: const OutlineInputBorder(),
      ),
      validator: (value) => _validateField(field, value),
    );
  }

  Widget _buildSearchableSelectionField(BuildContext context, ModelFormFieldDefinition field, AppLocalizations l10n) {
    final options = _selectionOptions[field.key] ?? field.options;
    final selectedValue = _selectedValues[field.key];
    final selectedOption = options.where((option) => option.value == selectedValue).cast<ModelFormSelectOption?>().firstWhere((option) => option != null, orElse: () => null);

    return FormField<Object?>(
      validator: (_) {
        final selected = _selectedValues[field.key];
        if (field.required && selected == null) {
          return l10n.fieldRequired(field.label);
        }
        return null;
      },
      builder: (state) {
        return InputDecorator(
          decoration: InputDecoration(labelText: field.label, hintText: field.hintText, helperText: field.helperText, border: const OutlineInputBorder(), errorText: state.errorText),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  selectedOption?.label ?? _searchFieldPlaceholder(context),
                  style: selectedOption == null ? Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).hintColor) : Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: field.readOnly
                    ? null
                    : () async {
                        final result = await _showSelectionSearchDialog(context: context, field: field, options: options);
                        if (!mounted || result == null) {
                          return;
                        }
                        setState(() {
                          if (result.createdOption != null) {
                            final existing = _selectionOptions[field.key] ?? <ModelFormSelectOption>[];
                            final merged = <ModelFormSelectOption>[...existing.where((option) => option.value != result.createdOption!.value), result.createdOption!];
                            merged.sort((left, right) => left.label.toLowerCase().compareTo(right.label.toLowerCase()));
                            _selectionOptions[field.key] = merged;
                          }
                          _selectedValues[field.key] = result.value;
                        });
                        state.didChange(result.value);
                      },
                icon: const Icon(Icons.search_rounded),
                label: Text(field.searchButtonLabel ?? l10n.searchAction),
              ),
              if (!field.readOnly && selectedValue != null)
                IconButton(
                  tooltip: l10n.clearSearch,
                  onPressed: () {
                    setState(() {
                      _selectedValues[field.key] = null;
                    });
                    state.didChange(null);
                  },
                  icon: const Icon(Icons.close_rounded),
                ),
            ],
          ),
        );
      },
    );
  }

  String _searchFieldPlaceholder(BuildContext context) {
    final l10n = context.l10n;
    return l10n.noValueSelected;
  }

  List<ModelFormSelectOption> _mergedSelectionOptions({required ModelFormFieldDefinition field, required Map<String, dynamic> initialData}) {
    final options = List<ModelFormSelectOption>.from(field.options);
    final selectedValue = initialData[field.key];
    if (selectedValue == null) {
      return options;
    }

    final alreadyPresent = options.any((option) => option.value == selectedValue || option.value.toString() == selectedValue.toString());
    if (alreadyPresent) {
      return options;
    }

    options.add(
      ModelFormSelectOption(
        label: _initialSelectionLabel(field: field, selectedValue: selectedValue, initialData: initialData),
        value: selectedValue,
      ),
    );
    options.sort((left, right) => left.label.toLowerCase().compareTo(right.label.toLowerCase()));
    return options;
  }

  String _initialSelectionLabel({required ModelFormFieldDefinition field, required Object selectedValue, required Map<String, dynamic> initialData}) {
    for (final option in field.options) {
      if (option.value == selectedValue || option.value.toString() == selectedValue.toString()) {
        return option.label;
      }
    }

    final key = field.key;
    var baseKey = key;
    if (key.endsWith('Uuid')) {
      baseKey = key.substring(0, key.length - 4);
    } else if (key.endsWith('Id')) {
      baseKey = key.substring(0, key.length - 2);
    }

    final candidateKeys = <String>[
      '${baseKey}Name',
      '${baseKey}Number',
      '${baseKey}Code',
      '${baseKey}Title',
      '${baseKey}Username',
      '${baseKey}Email',
      '${baseKey}_name',
      '${baseKey}_number',
      '${baseKey}_code',
      '${baseKey}_title',
      '${baseKey}_username',
      '${baseKey}_email',
      'name',
      'title',
      'username',
      'email',
    ];

    for (final candidate in candidateKeys) {
      final value = initialData[candidate]?.toString().trim();
      if (value != null && value.isNotEmpty) {
        return value;
      }
    }

    return selectedValue.toString();
  }

  Future<_SelectionSearchResult?> _showSelectionSearchDialog({required BuildContext context, required ModelFormFieldDefinition field, required List<ModelFormSelectOption> options}) async {
    final l10n = context.l10n;
    final controller = TextEditingController();
    var query = '';

    List<ModelFormSelectOption> filteredOptions() {
      final normalized = query.trim().toLowerCase();
      if (normalized.isEmpty) {
        return options;
      }
      return options.where((option) => option.label.toLowerCase().contains(normalized)).toList(growable: false);
    }

    final result = await showDialog<_SelectionSearchResult>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            final visibleOptions = filteredOptions();
            return AlertDialog(
              title: Text(field.label),
              content: SizedBox(
                width: 520,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: controller,
                      onChanged: (value) {
                        setDialogState(() {
                          query = value;
                        });
                      },
                      decoration: InputDecoration(prefixIcon: const Icon(Icons.search_rounded), hintText: l10n.searchTableHint, border: const OutlineInputBorder()),
                    ),
                    const SizedBox(height: 12),
                    Flexible(
                      child: visibleOptions.isEmpty
                          ? Align(alignment: Alignment.centerLeft, child: Text(l10n.noMatchingRecords))
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: visibleOptions.length,
                              itemBuilder: (context, index) {
                                final option = visibleOptions[index];
                                return ListTile(
                                  title: Text(option.label),
                                  onTap: () {
                                    Navigator.of(dialogContext).pop(_SelectionSearchResult(value: option.value));
                                  },
                                );
                              },
                            ),
                    ),
                    if (field.onCreateOption != null && query.trim().isNotEmpty)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () async {
                            final created = await field.onCreateOption!(query.trim());
                            if (!dialogContext.mounted || created == null) {
                              return;
                            }
                            Navigator.of(dialogContext).pop(_SelectionSearchResult(value: created.value, createdOption: created));
                          },
                          icon: const Icon(Icons.add_rounded),
                          label: Text(field.addNewButtonLabel ?? l10n.addNew),
                        ),
                      ),
                  ],
                ),
              ),
              actions: [TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: Text(l10n.cancel))],
            );
          },
        );
      },
    );

    controller.dispose();
    return result;
  }

  String? _validateField(ModelFormFieldDefinition field, String? value) {
    final l10n = context.l10n;
    final trimmedValue = value?.trim() ?? '';
    if (field.required && trimmedValue.isEmpty) {
      return l10n.fieldRequired(field.label);
    }
    if (trimmedValue.isEmpty) {
      return null;
    }

    switch (field.type) {
      case ModelFormFieldType.email:
        if (!trimmedValue.contains('@')) {
          return l10n.validField(field.label.toLowerCase());
        }
      case ModelFormFieldType.integer:
        if (int.tryParse(trimmedValue) == null) {
          return l10n.fieldMustBeInteger(field.label);
        }
      case ModelFormFieldType.decimal:
        if (num.tryParse(trimmedValue) == null) {
          return l10n.fieldMustBeNumber(field.label);
        }
      case ModelFormFieldType.dateTime:
        if (DateTime.tryParse(trimmedValue) == null) {
          return l10n.fieldMustUseDateTimeFormat(field.label);
        }
      default:
        break;
    }

    return field.validator?.call(trimmedValue);
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final values = <String, dynamic>{};
      for (final field in widget.definition) {
        if (field.type == ModelFormFieldType.selection) {
          final selectedValue = _selectedValues[field.key];
          values[field.key] = field.transformValue?.call(selectedValue) ?? selectedValue;
          continue;
        }

        final rawValue = _controllers[field.key]!.text.trim();
        final normalizedRawValue = rawValue.isEmpty ? null : rawValue;
        values[field.key] = field.transformValue?.call(normalizedRawValue) ?? normalizedRawValue;
      }
      widget.onSubmit(values);
    } catch (error) {
      AppNotification.show(context, message: error.toString(), type: AppNotificationType.error);
    }
  }

  String _formatInitialValue(ModelFormFieldDefinition field, Object? value) {
    if (field.formatValue != null) {
      return field.formatValue!(value);
    }
    if (value == null) {
      return '';
    }
    if (field.type == ModelFormFieldType.dateTime) {
      final dateTime = switch (value) {
        DateTime dateTime => dateTime,
        int milliseconds => DateTime.fromMillisecondsSinceEpoch(milliseconds),
        _ => null,
      };
      if (dateTime == null) {
        return value.toString();
      }
      final month = dateTime.month.toString().padLeft(2, '0');
      final day = dateTime.day.toString().padLeft(2, '0');
      final hour = dateTime.hour.toString().padLeft(2, '0');
      final minute = dateTime.minute.toString().padLeft(2, '0');
      return '${dateTime.year}-$month-$day $hour:$minute';
    }
    return value.toString();
  }

  Map<String, dynamic> _parsePermissionMap(String raw) {
    final normalized = raw.trim();
    if (normalized.isEmpty) {
      return const <String, dynamic>{};
    }

    try {
      final decoded = json.decode(normalized);
      if (decoded is Map<String, dynamic>) {
        return Map<String, dynamic>.from(decoded);
      }
      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
    } catch (_) {
      // Fall back to empty map when current text is not valid JSON.
    }

    return const <String, dynamic>{};
  }
}

class _SelectionSearchResult {
  const _SelectionSearchResult({required this.value, this.createdOption});

  final Object? value;
  final ModelFormSelectOption? createdOption;
}
