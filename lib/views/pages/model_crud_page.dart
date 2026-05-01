import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:store_management/localization/app_localizations.dart';
import 'package:store_management/views/components/model_form.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ModelCrudPage<T extends Object> extends StatefulWidget {
  const ModelCrudPage({super.key, required this.title, required this.entityLabel, required this.description, required this.icon, required this.formDefinition, this.highlights = const <String>[]});

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
  static const String _actionsColumnName = '__actions__';
  late final List<T> _records;
  late T _draftModel;
  late final TextEditingController _searchController;
  final Map<String, double> _columnWidths = <String, double>{};
  bool _showCreateForm = false;
  String? _sortColumnName;
  bool _sortAscending = true;
  int _currentPage = 0;
  int _rowsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _draftModel = widget.formDefinition.sampleModel;
    _records = <T>[widget.formDefinition.sampleModel, widget.formDefinition.buildModel(widget.formDefinition.toMap(widget.formDefinition.sampleModel))];
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _ModuleHeader(title: widget.title, description: widget.description, icon: widget.icon, highlights: widget.highlights),
            const SizedBox(height: 24),
            _buildCreateFormToggle(context),
            if (_showCreateForm) ...[const SizedBox(height: 16), _buildCreateFormCard(context)],
            const SizedBox(height: 24),
            _buildTableCard(context, constraints),
          ],
        );
      },
    );
  }

  Widget _buildCreateFormToggle(BuildContext context) {
    final l10n = context.l10n;
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
                  Text(l10n.createEntity(widget.entityLabel), style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 6),
                  Text(l10n.showOrHideCreateForm, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_showCreateForm ? l10n.hideCreate : l10n.showCreate),
                const SizedBox(width: 8),
                Switch(
                  value: _showCreateForm,
                  onChanged: (value) {
                    setState(() {
                      _showCreateForm = value;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateFormCard(BuildContext context) {
    final l10n = context.l10n;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.saveEntity(widget.entityLabel), style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(l10n.addEntityToTable(widget.entityLabel), style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 24),
            ModelForm(
              key: ValueKey('${widget.entityLabel}-create-${widget.formDefinition.toMap(_draftModel)}'),
              definition: widget.formDefinition.fields,
              initialData: widget.formDefinition.toMap(_draftModel),
              submitLabel: l10n.saveEntity(widget.entityLabel),
              cancelLabel: l10n.reset,
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
    final l10n = context.l10n;
    final isCompactLayout = constraints.maxWidth < 720;
    final tableHorizontalInset = isCompactLayout ? 72.0 : 88.0;
    final rowHeight = isCompactLayout ? 72.0 : 60.0;
    final headerRowHeight = isCompactLayout ? 52.0 : 56.0;
    final visibleRecords = _paginatedRecords;
    final currentPage = _effectiveCurrentPage;
    final pageCount = _pageCount;
    final availableTableWidth = math.max(constraints.maxWidth - tableHorizontalInset - 20, 280.0);
    final columns = _buildColumns(availableTableWidth, isCompactLayout: isCompactLayout);
    final dataSource = _CrudDataGridSource<T>(
      records: visibleRecords,
      visibleFields: _visibleFields,
      toMap: widget.formDefinition.toMap,
      formatCellValue: _formatCellValue,
      entityLabel: widget.entityLabel,
      l10n: l10n,
      onView: _openDetailsPage,
      onEdit: _showEditSheet,
      onDelete: _confirmDelete,
      actionsColumnName: _actionsColumnName,
      errorColor: Theme.of(context).colorScheme.error,
    );

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
                      Text(l10n.dataTableTitle(widget.title), style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 8),
                      Text(l10n.actionsColumnHint, style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                _SummaryChip(label: l10n.rows, value: _summaryRowCountLabel),
              ],
            ),
            const SizedBox(height: 20),
            if (_records.isNotEmpty) ...[
              _buildSearchField(context),
              if (_searchQuery.isNotEmpty && _filteredRecords.isEmpty) ...[const SizedBox(height: 12), Text(l10n.noMatchingRecords, style: Theme.of(context).textTheme.bodyMedium)],
              const SizedBox(height: 20),
            ],
            if (_records.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Theme.of(context).colorScheme.surfaceContainerLowest),
                child: Text(l10n.noDataAvailable, style: Theme.of(context).textTheme.bodyLarge),
              )
            else
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: double.infinity,
                  constraints: BoxConstraints(minHeight: 220, maxHeight: isCompactLayout ? 460 : 560),
                  color: Theme.of(context).colorScheme.surface,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: availableTableWidth),
                    child: SfDataGrid(
                      source: dataSource,
                      columns: columns,
                      allowColumnsResizing: true,
                      onColumnResizeUpdate: (details) {
                        if (details.column.columnName == _actionsColumnName) {
                          return false;
                        }

                        setState(() {
                          _columnWidths[details.column.columnName] = details.width;
                        });
                        return true;
                      },
                      columnResizeMode: ColumnResizeMode.onResizeEnd,
                      columnWidthMode: ColumnWidthMode.none,
                      gridLinesVisibility: GridLinesVisibility.horizontal,
                      headerGridLinesVisibility: GridLinesVisibility.horizontal,
                      rowHeight: rowHeight,
                      headerRowHeight: headerRowHeight,
                    ),
                  ),
                ),
              ),
            if (_records.isNotEmpty) ...[const SizedBox(height: 16), _buildTableFooter(context, isCompactLayout: isCompactLayout, currentPage: currentPage, pageCount: pageCount)],
          ],
        ),
      ),
    );
  }

  List<GridColumn> _buildColumns(double tableWidth, {required bool isCompactLayout}) {
    final resolvedWidths = _resolvedColumnWidths(tableWidth, isCompactLayout: isCompactLayout);
    final dataColumnMinimumWidth = isCompactLayout ? 110.0 : 160.0;
    final actionsColumnMinimumWidth = isCompactLayout ? 132.0 : 156.0;
    final actionsColumnWidth = isCompactLayout ? 132.0 : 156.0;

    return [
      for (final field in _visibleFields)
        GridColumn(
          columnName: field.key,
          minimumWidth: dataColumnMinimumWidth,
          width: resolvedWidths[field.key] ?? 180,
          label: _GridHeaderCell(label: field.label, onTap: () => _handleSortChanged(field.key), sortDirection: _sortColumnName == field.key ? (_sortAscending ? AxisDirection.up : AxisDirection.down) : null),
        ),
      GridColumn(
        columnName: _actionsColumnName,
        minimumWidth: actionsColumnMinimumWidth,
        width: actionsColumnWidth,
        label: _GridHeaderCell(label: context.l10n.actions),
      ),
    ];
  }

  Map<String, double> _resolvedColumnWidths(double tableWidth, {required bool isCompactLayout}) {
    final defaultDataWidth = isCompactLayout ? 124.0 : 180.0;
    final defaultActionsWidth = isCompactLayout ? 132.0 : 156.0;
    final widths = <String, double>{for (final field in _visibleFields) field.key: _columnWidths[field.key] ?? defaultDataWidth};
    final dataColumnCount = _visibleFields.length;
    if (dataColumnCount == 0) {
      widths[_actionsColumnName] = defaultActionsWidth;
      return widths;
    }

    final totalWidth = widths.values.fold<double>(0, (sum, width) => sum + width) + defaultActionsWidth;
    if (totalWidth >= tableWidth) {
      widths[_actionsColumnName] = defaultActionsWidth;
      return widths;
    }

    final extraPerColumn = (tableWidth - totalWidth) / dataColumnCount;
    for (final field in _visibleFields) {
      widths[field.key] = (widths[field.key] ?? defaultDataWidth) + extraPerColumn;
    }
    widths[_actionsColumnName] = defaultActionsWidth;
    return widths;
  }

  List<ModelFormFieldDefinition> get _visibleFields {
    final preferredFields = widget.formDefinition.fields.take(5).toList();
    if (preferredFields.isNotEmpty) {
      return preferredFields;
    }
    return widget.formDefinition.fields;
  }

  String get _searchQuery => _searchController.text.trim();

  List<T> get _filteredRecords {
    if (_searchQuery.isEmpty) {
      return _records;
    }

    final normalizedQuery = _searchQuery.toLowerCase();
    return _records
        .where((record) {
          final data = widget.formDefinition.toMap(record);
          for (final field in _visibleFields) {
            final formattedValue = _formatCellValue(data[field.key]).toLowerCase();
            if (formattedValue.contains(normalizedQuery)) {
              return true;
            }

            final rawValue = data[field.key]?.toString().toLowerCase() ?? '';
            if (rawValue.contains(normalizedQuery)) {
              return true;
            }
          }
          return false;
        })
        .toList(growable: false);
  }

  List<T> get _sortedRecords {
    final records = List<T>.of(_filteredRecords);
    final sortColumnName = _sortColumnName;
    if (sortColumnName == null) {
      return records;
    }

    records.sort((left, right) {
      final leftValue = widget.formDefinition.toMap(left)[sortColumnName];
      final rightValue = widget.formDefinition.toMap(right)[sortColumnName];
      final result = _compareSortValues(leftValue, rightValue);
      return _sortAscending ? result : -result;
    });
    return records;
  }

  int get _pageCount {
    final totalRows = _sortedRecords.length;
    if (totalRows == 0) {
      return 1;
    }
    return (totalRows / _rowsPerPage).ceil();
  }

  int get _effectiveCurrentPage => math.min(_currentPage, _pageCount - 1);

  List<T> get _paginatedRecords {
    final sortedRecords = _sortedRecords;
    if (sortedRecords.isEmpty) {
      return <T>[];
    }

    final start = _effectiveCurrentPage * _rowsPerPage;
    final end = math.min(start + _rowsPerPage, sortedRecords.length);
    return sortedRecords.sublist(start, end);
  }

  String get _summaryRowCountLabel {
    if (_searchQuery.isEmpty) {
      return _sortedRecords.length.toString();
    }
    return '${_sortedRecords.length}/${_records.length}';
  }

  void _handleSearchChanged(String value) {
    setState(() {
      _currentPage = 0;
    });
  }

  void _handleSortChanged(String columnName) {
    setState(() {
      if (_sortColumnName == columnName) {
        _sortAscending = !_sortAscending;
      } else {
        _sortColumnName = columnName;
        _sortAscending = true;
      }
      _currentPage = 0;
    });
  }

  void _handleRowsPerPageChanged(int? value) {
    if (value == null || value == _rowsPerPage) {
      return;
    }

    setState(() {
      _rowsPerPage = value;
      _currentPage = 0;
    });
  }

  int _compareSortValues(Object? left, Object? right) {
    if (identical(left, right)) {
      return 0;
    }
    if (left == null) {
      return 1;
    }
    if (right == null) {
      return -1;
    }
    if (left is num && right is num) {
      return left.compareTo(right);
    }
    if (left is DateTime && right is DateTime) {
      return left.compareTo(right);
    }
    if (left is bool && right is bool) {
      return left == right ? 0 : (left ? 1 : -1);
    }
    if (left is Comparable<Object> && right is Comparable<Object> && left.runtimeType == right.runtimeType) {
      return left.compareTo(right);
    }

    return _formatCellValue(left).toLowerCase().compareTo(_formatCellValue(right).toLowerCase());
  }

  Widget _buildTableFooter(BuildContext context, {required bool isCompactLayout, required int currentPage, required int pageCount}) {
    final totalRows = _sortedRecords.length;
    final start = totalRows == 0 ? 0 : currentPage * _rowsPerPage + 1;
    final end = totalRows == 0 ? 0 : math.min((currentPage + 1) * _rowsPerPage, totalRows);
    final rowsPerPageOptions = isCompactLayout ? const <int>[5, 10, 15] : const <int>[10, 20, 30];
    final selectedRowsPerPage = rowsPerPageOptions.contains(_rowsPerPage) ? _rowsPerPage : rowsPerPageOptions.first;

    final footerChildren = <Widget>[
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('${context.l10n.rowsPerPage}: ', style: Theme.of(context).textTheme.bodyMedium),
          DropdownButton<int>(
            value: selectedRowsPerPage,
            onChanged: _handleRowsPerPageChanged,
            items: rowsPerPageOptions.map((value) => DropdownMenuItem<int>(value: value, child: Text(value.toString()))).toList(growable: false),
          ),
        ],
      ),
      Text('$start-$end / $totalRows', style: Theme.of(context).textTheme.bodyMedium),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: context.l10n.previousPage,
            onPressed: currentPage > 0
                ? () {
                    setState(() {
                      _currentPage = currentPage - 1;
                    });
                  }
                : null,
            icon: const Icon(Icons.chevron_left_rounded),
          ),
          Text('${currentPage + 1} / $pageCount', style: Theme.of(context).textTheme.bodyMedium),
          IconButton(
            tooltip: context.l10n.nextPage,
            onPressed: currentPage < pageCount - 1
                ? () {
                    setState(() {
                      _currentPage = currentPage + 1;
                    });
                  }
                : null,
            icon: const Icon(Icons.chevron_right_rounded),
          ),
        ],
      ),
    ];

    if (isCompactLayout) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Wrap(spacing: 12, runSpacing: 12, crossAxisAlignment: WrapCrossAlignment.center, children: footerChildren)],
      );
    }

    return Row(children: [footerChildren[0], const Spacer(), footerChildren[1], const SizedBox(width: 12), footerChildren[2]]);
  }

  Widget _buildSearchField(BuildContext context) {
    final l10n = context.l10n;
    return TextField(
      controller: _searchController,
      onChanged: _handleSearchChanged,
      decoration: InputDecoration(
        labelText: l10n.searchTable,
        hintText: l10n.searchTableHint,
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: _searchQuery.isEmpty
            ? null
            : IconButton(
                tooltip: l10n.clearSearch,
                onPressed: () {
                  _searchController.clear();
                  _handleSearchChanged('');
                },
                icon: const Icon(Icons.close_rounded),
              ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerLowest,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
    );
  }

  void _handleCreateSubmit(Map<String, dynamic> values) {
    final model = widget.formDefinition.buildModel(values);
    setState(() {
      _records.insert(0, model);
      _draftModel = widget.formDefinition.sampleModel;
      _showCreateForm = false;
      _currentPage = 0;
    });
    _showFeedback(context.l10n.savedEntitySuccessfully(widget.entityLabel));
  }

  Future<void> _showEditSheet(T record) async {
    final updatedModel = await showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 24, right: 24, top: 12, bottom: MediaQuery.of(context).viewInsets.bottom + 24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(context.l10n.editEntity(widget.entityLabel), style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 16),
                  ModelForm(
                    definition: widget.formDefinition.fields,
                    initialData: widget.formDefinition.toMap(record),
                    submitLabel: context.l10n.updateEntity(widget.entityLabel),
                    cancelLabel: context.l10n.close,
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

    if (!mounted) {
      return;
    }

    final index = _indexOfRecord(record);
    if (index == -1) {
      return;
    }

    setState(() {
      _records[index] = updatedModel;
      _currentPage = _effectiveCurrentPage;
    });
    _showFeedback(context.l10n.updatedEntitySuccessfully(widget.entityLabel));
  }

  Future<void> _confirmDelete(T record) async {
    final details = widget.formDefinition.toMap(record);
    final didDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        return AlertDialog(
          title: Text(context.l10n.deleteEntityQuestion(widget.entityLabel)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.l10n.deleteEntityMessage(widget.entityLabel)),
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
                    Text(_recordTitle(details), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    for (final field in _visibleFields.take(3)) ...[Text('${field.label}: ${_formatCellValue(details[field.key])}'), const SizedBox(height: 4)],
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(context.l10n.cancel)),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: colorScheme.error),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(context.l10n.deleteLabel),
            ),
          ],
        );
      },
    );

    if (didDelete != true) {
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _records.removeAt(_indexOfRecord(record));
      _currentPage = _effectiveCurrentPage;
    });
    _showFeedback(context.l10n.deletedEntitySuccessfully(widget.entityLabel));
  }

  void _openDetailsPage(T record) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => _ModelDetailsPage(entityLabel: widget.entityLabel, title: widget.title, icon: widget.icon, fields: widget.formDefinition.fields, data: widget.formDefinition.toMap(record)),
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

class _CrudDataGridSource<T extends Object> extends DataGridSource {
  _CrudDataGridSource({
    required List<T> records,
    required List<ModelFormFieldDefinition> visibleFields,
    required Map<String, dynamic> Function(T record) toMap,
    required String Function(Object? value) formatCellValue,
    required String entityLabel,
    required AppLocalizations l10n,
    required void Function(T record) onView,
    required Future<void> Function(T record) onEdit,
    required Future<void> Function(T record) onDelete,
    required String actionsColumnName,
    required Color errorColor,
  }) : _records = records,
       _formatCellValue = formatCellValue,
       _entityLabel = entityLabel,
       _l10n = l10n,
       _onView = onView,
       _onEdit = onEdit,
       _onDelete = onDelete,
       _actionsColumnName = actionsColumnName,
       _errorColor = errorColor,
       _rows = records
           .map((record) {
             final data = toMap(record);
             return DataGridRow(
               cells: [
                 for (final field in visibleFields) DataGridCell<Object?>(columnName: field.key, value: data[field.key]),
                 DataGridCell<String>(columnName: actionsColumnName, value: ''),
               ],
             );
           })
           .toList(growable: false);

  final List<T> _records;
  final List<DataGridRow> _rows;
  final String Function(Object? value) _formatCellValue;
  final String _entityLabel;
  final AppLocalizations _l10n;
  final void Function(T record) _onView;
  final Future<void> Function(T record) _onEdit;
  final Future<void> Function(T record) _onDelete;
  final String _actionsColumnName;
  final Color _errorColor;

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final index = _rows.indexOf(row);
    final record = _records[index];

    return DataGridRowAdapter(
      cells: row
          .getCells()
          .map((cell) {
            if (cell.columnName == _actionsColumnName) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 4,
                  children: [
                    IconButton(tooltip: _l10n.viewEntity(_entityLabel), onPressed: () => _onView(record), icon: const Icon(Icons.visibility_outlined, size: 20)),
                    IconButton(tooltip: _l10n.editEntity(_entityLabel), onPressed: () => _onEdit(record), icon: const Icon(Icons.edit_outlined, size: 20)),
                    IconButton(
                      tooltip: _l10n.deleteEntityQuestion(_entityLabel),
                      onPressed: () => _onDelete(record),
                      icon: Icon(Icons.delete_outline_rounded, size: 20, color: _errorColor),
                    ),
                  ],
                ),
              );
            }

            return Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(_formatCellValue(cell.value), overflow: TextOverflow.ellipsis, maxLines: 2),
            );
          })
          .toList(growable: false),
    );
  }
}

class _ModuleHeader extends StatelessWidget {
  const _ModuleHeader({required this.title, required this.description, required this.icon, required this.highlights});

  final String title;
  final String description;
  final IconData icon;
  final List<String> highlights;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [colorScheme.primaryContainer, colorScheme.secondaryContainer], begin: Alignment.topLeft, end: Alignment.bottomRight),
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
                      Text(title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      Text(description, style: Theme.of(context).textTheme.bodyLarge),
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
                children: [for (final highlight in highlights) Chip(label: Text(highlight), avatar: const Icon(Icons.check_circle_outline_rounded, size: 18))],
              ),
            ],
          ],
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
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.8), borderRadius: BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$label: ', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
          Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _ModelDetailsPage extends StatelessWidget {
  const _ModelDetailsPage({required this.entityLabel, required this.title, required this.icon, required this.fields, required this.data});

  final String entityLabel;
  final String title;
  final IconData icon;
  final List<ModelFormFieldDefinition> fields;
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.entityDetails(entityLabel))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  CircleAvatar(radius: 20, child: Icon(icon, size: 20)),
                  const SizedBox(width: 12),
                  Expanded(child: Text(title, style: Theme.of(context).textTheme.titleLarge)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  for (final entry in data.entries) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 132,
                          child: Text(_fieldLabel(context, entry.key), style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Text(entry.value?.toString() ?? '-', maxLines: 3, overflow: TextOverflow.ellipsis)),
                      ],
                    ),
                    if (entry.key != data.keys.last) const Divider(height: 16),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _fieldLabel(BuildContext context, String key) {
    for (final field in fields) {
      if (field.key == key) {
        return field.label;
      }
    }

    final l10n = context.l10n;
    switch (key) {
      case 'id':
        return 'ID';
      case 'uuid':
        return 'UUID';
      case 'createdAt':
        return l10n.isArabic ? 'تاريخ الإنشاء' : 'Created at';
      case 'updatedAt':
        return l10n.isArabic ? 'تاريخ التحديث' : 'Updated at';
      default:
        return key;
    }
  }
}

class _GridHeaderCell extends StatelessWidget {
  const _GridHeaderCell({required this.label, this.onTap, this.sortDirection});

  final String label;
  final VoidCallback? onTap;
  final AxisDirection? sortDirection;

  @override
  Widget build(BuildContext context) {
    final icon = switch (sortDirection) {
      AxisDirection.up => Icons.arrow_upward_rounded,
      AxisDirection.down => Icons.arrow_downward_rounded,
      _ => null,
    };

    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleSmall),
              ),
              if (icon != null) ...[const SizedBox(width: 8), Icon(icon, size: 16)],
            ],
          ),
        ),
      ),
    );
  }
}
