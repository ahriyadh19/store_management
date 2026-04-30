import 'package:flutter/material.dart';
import 'package:store_management/localization/app_localizations.dart';

enum ModelFormFieldType { text, multiline, email, phone, integer, decimal, dateTime, selection }

class ModelFormSelectOption {
  const ModelFormSelectOption({required this.label, required this.value});

  final String label;
  final Object value;
}

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
    this.transformValue,
    this.formatValue,
    this.validator,
  });

  final String key;
  final String label;
  final ModelFormFieldType type;
  final String? hintText;
  final String? helperText;
  final bool required;
  final bool readOnly;
  final List<ModelFormSelectOption> options;
  final Object? Function(Object? rawValue)? transformValue;
  final String Function(Object? value)? formatValue;
  final String? Function(String? value)? validator;
}

class ModelFormDefinition<T extends Object> {
  const ModelFormDefinition({
    required this.fields,
    required this.fromMap,
    required this.toMap,
    required this.sampleModel,
  });

  final List<ModelFormFieldDefinition> fields;
  final T Function(Map<String, dynamic> map) fromMap;
  final Map<String, dynamic> Function(T model) toMap;
  final T sampleModel;

  T buildModel(Map<String, dynamic> values, {T? existingModel}) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final existingData = existingModel == null ? const <String, dynamic>{} : toMap(existingModel);

    return fromMap({
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
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var index = 0; index < widget.definition.length; index++) ...[
            _buildField(context, widget.definition[index]),
            if (index < widget.definition.length - 1) const SizedBox(height: 16),
          ],
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.end,
            children: [
              if (widget.onCancel != null)
                OutlinedButton(
                  onPressed: widget.onCancel,
                  child: Text(widget.cancelLabel ?? l10n.cancel),
                ),
              FilledButton.icon(
                onPressed: _handleSubmit,
                icon: const Icon(Icons.save_rounded),
                label: Text(widget.submitLabel),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildField(BuildContext context, ModelFormFieldDefinition field) {
    final l10n = context.l10n;
    if (field.type == ModelFormFieldType.selection) {
      return DropdownButtonFormField<Object?>(
        initialValue: _selectedValues[field.key],
        items: field.options
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
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(error.toString()),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
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
}
