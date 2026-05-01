import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart' as sf_theme;
import 'package:syncfusion_flutter_datagrid/datagrid.dart' as sf;
import 'package:store_management/localization/app_localizations.dart';
import 'package:store_management/views/components/model_form.dart';

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
  late final List<T> _records;
  late T _draftModel;
  late final sf.DataPagerController _dataPagerController;
  late final TextEditingController _searchController;
  late final _ModelTableSource<T> _tableSource;
  bool _showCreateForm = false;
  int _rowsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _draftModel = widget.formDefinition.sampleModel;
    _records = <T>[widget.formDefinition.sampleModel, widget.formDefinition.buildModel(widget.formDefinition.toMap(widget.formDefinition.sampleModel))];
    _dataPagerController = sf.DataPagerController();
    _searchController = TextEditingController();
    _tableSource = _createTableSource();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ModelCrudPage<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.formDefinition != widget.formDefinition || oldWidget.entityLabel != widget.entityLabel) {
      _syncTableSource(resetToFirstPage: true);
    }
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
              _ModuleHeader(title: widget.title, description: widget.description, icon: widget.icon, highlights: widget.highlights),
              const SizedBox(height: 24),
              _buildCreateFormToggle(context),
              if (_showCreateForm) ...[const SizedBox(height: 16), _buildCreateFormCard(context)],
              const SizedBox(height: 24),
              _buildTableCard(context, constraints),
            ],
          ),
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
    final columns = _buildColumns();

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
              if (_searchQuery.isNotEmpty && _tableSource.filteredRowCount == 0) ...[const SizedBox(height: 12), Text(l10n.noMatchingRecords, style: Theme.of(context).textTheme.bodyMedium)],
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
                child: sf_theme.SfDataGridTheme(
                  data: sf_theme.SfDataGridThemeData(
                    sortIcon: Builder(builder: _buildSortIcon),
                    filterIcon: Builder(builder: _buildFilterIcon),
                  ),
                  child: Container(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth >= 960 ? constraints.maxWidth - 48 : 960, minHeight: 220, maxHeight: 520),
                    color: Theme.of(context).colorScheme.surface,
                    child: sf.SfDataGrid(
                      source: _tableSource,
                      columns: columns,
                      columnWidthMode: sf.ColumnWidthMode.fill,
                      gridLinesVisibility: sf.GridLinesVisibility.horizontal,
                      headerGridLinesVisibility: sf.GridLinesVisibility.horizontal,
                      rowHeight: 72,
                      headerRowHeight: 56,
                      rowsPerPage: _rowsPerPage,
                      shrinkWrapColumns: true,
                      selectionMode: sf.SelectionMode.none,
                      allowFiltering: true,
                      allowSorting: true,
                      allowTriStateSorting: true,
                      allowColumnsResizing: true,
                      onColumnResizeUpdate: (_) => true,
                    ),
                  ),
                ),
              ),
            if (_tableSource.filteredRowCount > 0) ...[
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: sf.SfDataPager(
                  delegate: _tableSource,
                  controller: _dataPagerController,
                  pageCount: _pageCount,
                  availableRowsPerPage: const <int>[10, 25, 50, 100],
                  onRowsPerPageChanged: (rowsPerPage) {
                    if (rowsPerPage == null || rowsPerPage == _rowsPerPage) {
                      return;
                    }
                    setState(() {
                      _rowsPerPage = rowsPerPage;
                    });
                    _tableSource.moveToFirstPage();
                    _dataPagerController.selectedPageIndex = 0;
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<sf.GridColumn> _buildColumns() {
    return [
      for (final field in _visibleFields)
        sf.GridColumn(
          columnName: field.key,
          label: _GridHeaderCell(label: field.label),
        ),
      sf.GridColumn(
        columnName: '__actions__',
        allowFiltering: false,
        allowSorting: false,
        label: _GridHeaderCell(label: context.l10n.actions),
      ),
    ];
  }

  List<ModelFormFieldDefinition> get _visibleFields {
    final preferredFields = widget.formDefinition.fields.take(5).toList();
    if (preferredFields.isNotEmpty) {
      return preferredFields;
    }
    return widget.formDefinition.fields;
  }

  String get _searchQuery => _searchController.text.trim();

  String get _summaryRowCountLabel {
    if (_searchQuery.isEmpty) {
      return _tableSource.filteredRowCount.toString();
    }
    return '${_tableSource.filteredRowCount}/${_records.length}';
  }

  double get _pageCount {
    if (_tableSource.filteredRowCount == 0) {
      return 1;
    }
    return (_tableSource.filteredRowCount / _rowsPerPage).ceilToDouble();
  }

  _ModelTableSource<T> _createTableSource() {
    return _ModelTableSource<T>(
      records: _records,
      visibleFields: _visibleFields,
      toMap: widget.formDefinition.toMap,
      formatCellValue: _formatCellValue,
      entityLabel: widget.entityLabel,
      onView: _openDetailsPage,
      onEdit: _showEditSheet,
      onDelete: _confirmDelete,
      context: context,
    );
  }

  void _syncTableSource({bool resetToFirstPage = false}) {
    _tableSource.updateData(records: _records, visibleFields: _visibleFields, resetToFirstPage: resetToFirstPage);
    if (resetToFirstPage) {
      _dataPagerController.selectedPageIndex = 0;
    }
  }

  void _handleSearchChanged(String value) {
    setState(() {
      _tableSource.updateSearchQuery(value);
      _dataPagerController.selectedPageIndex = 0;
    });
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

  Widget _buildSortIcon(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final columnName = _headerColumnNameFromContext(context);
    sf.SortColumnDetails? sortedColumn;
    for (final detail in _tableSource.sortedColumns) {
      if (detail.name == columnName) {
        sortedColumn = detail;
        break;
      }
    }

    final IconData icon;
    final Color color;
    if (sortedColumn == null) {
      icon = Icons.unfold_more_rounded;
      color = colorScheme.outline;
    } else if (sortedColumn.sortDirection == sf.DataGridSortDirection.ascending) {
      icon = Icons.arrow_circle_up_rounded;
      color = colorScheme.primary;
    } else {
      icon = Icons.arrow_circle_down_rounded;
      color = colorScheme.secondary;
    }

    return Icon(icon, size: 18, color: color);
  }

  Widget _buildFilterIcon(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final columnName = _headerColumnNameFromContext(context);
    final isFiltered = _tableSource.filterConditions.containsKey(columnName);
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(color: isFiltered ? colorScheme.primaryContainer : colorScheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(999)),
      child: Icon(isFiltered ? Icons.tune_rounded : Icons.filter_alt_outlined, size: 16, color: isFiltered ? colorScheme.primary : colorScheme.onSurfaceVariant),
    );
  }

  String _headerColumnNameFromContext(BuildContext context) {
    String columnName = '';
    context.visitAncestorElements((element) {
      final dynamic candidate = element;
      if (candidate.runtimeType.toString() == 'GridHeaderCellElement') {
        columnName = candidate.column.columnName as String;
        return false;
      }
      return true;
    });
    return columnName;
  }

  void _handleCreateSubmit(Map<String, dynamic> values) {
    final model = widget.formDefinition.buildModel(values);
    setState(() {
      _records.insert(0, model);
      _draftModel = widget.formDefinition.sampleModel;
      _showCreateForm = false;
      _syncTableSource(resetToFirstPage: true);
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
      _syncTableSource();
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
      _syncTableSource(resetToFirstPage: true);
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
  const _GridHeaderCell({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
      child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleSmall),
    );
  }
}

class _ModelTableSource<T extends Object> extends sf.DataGridSource {
  _ModelTableSource({
    required this.records,
    required this.visibleFields,
    required this.toMap,
    required this.formatCellValue,
    required this.entityLabel,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
    required this.context,
  }) {
    _buildRows();
  }

  List<T> records;
  List<ModelFormFieldDefinition> visibleFields;
  final Map<String, dynamic> Function(T model) toMap;
  final String Function(Object? value) formatCellValue;
  final String entityLabel;
  final void Function(T record) onView;
  final Future<void> Function(T record) onEdit;
  final Future<void> Function(T record) onDelete;
  final BuildContext context;
  String _searchQuery = '';
  List<sf.DataGridRow> _rows = <sf.DataGridRow>[];
  int _currentPageIndex = 0;

  int get filteredRowCount => _filteredRecords.length;

  List<T> get _filteredRecords {
    if (_searchQuery.isEmpty) {
      return records;
    }

    return records
        .where((record) {
          final data = toMap(record);
          for (final field in visibleFields) {
            final formattedValue = formatCellValue(data[field.key]).toLowerCase();
            if (formattedValue.contains(_searchQuery)) {
              return true;
            }

            final rawValue = data[field.key]?.toString().toLowerCase() ?? '';
            if (rawValue.contains(_searchQuery)) {
              return true;
            }
          }
          return false;
        })
        .toList(growable: false);
  }

  void updateData({required List<T> records, required List<ModelFormFieldDefinition> visibleFields, bool resetToFirstPage = false}) {
    this.records = List<T>.from(records);
    this.visibleFields = List<ModelFormFieldDefinition>.from(visibleFields);
    _buildRows();
    if (resetToFirstPage) {
      moveToFirstPage();
      return;
    }
    handlePageChange(_currentPageIndex, _currentPageIndex);
    notifyListeners();
  }

  void updateSearchQuery(String value) {
    _searchQuery = value.trim().toLowerCase();
    _buildRows();
    moveToFirstPage();
    notifyListeners();
  }

  void moveToFirstPage() {
    handlePageChange(_currentPageIndex, 0);
  }

  void _buildRows() {
    _rows = _filteredRecords
        .map(
          (record) => sf.DataGridRow(
            cells: [
              for (final field in visibleFields) sf.DataGridCell<Object?>(columnName: field.key, value: toMap(record)[field.key]),
              sf.DataGridCell<T>(columnName: '__actions__', value: record),
            ],
          ),
        )
        .toList(growable: false);
  }

  @override
  List<sf.DataGridRow> get rows => _rows;

  @override
  Future<void> performSorting(List<sf.DataGridRow> rows) async {
    await super.performSorting(rows);
    await handlePageChange(_currentPageIndex, _currentPageIndex);
  }

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    _currentPageIndex = newPageIndex;
    return super.handlePageChange(oldPageIndex, newPageIndex);
  }

  @override
  sf.DataGridRowAdapter buildRow(sf.DataGridRow row) {
    return sf.DataGridRowAdapter(
      cells: row
          .getCells()
          .map((cell) {
            if (cell.columnName == '__actions__') {
              final record = cell.value as T;
              return Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Wrap(
                  spacing: 4,
                  children: [
                    IconButton(tooltip: context.l10n.viewEntity(entityLabel), onPressed: () => onView(record), icon: const Icon(Icons.visibility_outlined, size: 20)),
                    IconButton(tooltip: context.l10n.editEntity(entityLabel), onPressed: () => onEdit(record), icon: const Icon(Icons.edit_outlined, size: 20)),
                    IconButton(
                      tooltip: context.l10n.deleteEntityQuestion(entityLabel),
                      onPressed: () => onDelete(record),
                      icon: Icon(Icons.delete_outline_rounded, size: 20, color: Theme.of(context).colorScheme.error),
                    ),
                  ],
                ),
              );
            }

            return Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(formatCellValue(cell.value), overflow: TextOverflow.ellipsis, maxLines: 2),
            );
          })
          .toList(growable: false),
    );
  }
}
