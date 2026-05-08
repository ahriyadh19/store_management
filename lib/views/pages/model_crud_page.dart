import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:store_management/localization/app_localizations.dart';
import 'package:store_management/services/status.dart';
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
  static const Duration _searchDebounceDuration = Duration(milliseconds: 280);
  static const int _isolateThreshold = 180;
  late final List<T> _records;
  late T _draftModel;
  late final TextEditingController _searchController;
  late final FocusNode _gridFocusNode;
  final Map<String, double> _columnWidths = <String, double>{};
  Timer? _searchDebounce;
  bool _showCreateForm = false;
  bool _isLoading = false;
  String? _selectedRecordKey;
  String? _sortColumnName;
  String _effectiveSearchQuery = '';
  bool _sortAscending = true;
  int _currentPage = 0;
  int _rowsPerPage = 10;
  int _recordsVersion = 0;
  int _queryEpoch = 0;
  int _cachedSnapshotsVersion = -1;
  List<_RecordSnapshot<T>>? _cachedRecordSnapshots;
  late _CachedCrudViewState<T> _viewState;

  @override
  void initState() {
    super.initState();
    _draftModel = widget.formDefinition.sampleModel;
    _records = _isServerBacked ? <T>[] : <T>[widget.formDefinition.sampleModel, widget.formDefinition.buildModel(widget.formDefinition.toMap(widget.formDefinition.sampleModel))];
    _viewState = _computeSynchronousViewState(records: _records, searchQuery: '');
    _searchController = TextEditingController();
    _gridFocusNode = FocusNode(debugLabel: '${widget.entityLabel}-grid-focus');
    unawaited(_refreshViewState(immediateSearch: true));
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _gridFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final showTableSection = !_showCreateForm || constraints.maxHeight >= 840;

        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _ModuleHeader(title: widget.title, description: widget.description, icon: widget.icon, highlights: widget.highlights),
            const SizedBox(height: 24),
            _buildCreateFormToggle(context),
            if (_showCreateForm) ...[const SizedBox(height: 10), _buildCreateFormCard(context)],
            if (showTableSection) ...[const SizedBox(height: 10), _buildTableCard(context, constraints)],
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
    final maxHeight = MediaQuery.of(context).size.height * 0.8;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
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
        ),
      ),
    );
  }

  Widget _buildTableCard(BuildContext context, BoxConstraints constraints) {
    final l10n = context.l10n;
    final isCompactLayout = constraints.maxWidth < 720;
    final rowHeight = isCompactLayout ? 72.0 : 60.0;
    final headerRowHeight = isCompactLayout ? 52.0 : 56.0;
    final visibleRecords = _paginatedRecords;
    final visibleRecordKeys = _viewState.paginatedRecordKeys;
    final currentPage = _effectiveCurrentPage;
    final pageCount = _pageCount;
    const listHorizontalPadding = 52.0;
    const cardHorizontalPadding = 52.0;
    final availableTableWidth = math.max(constraints.maxWidth - listHorizontalPadding - cardHorizontalPadding, 280.0);
    final columns = _buildColumns(availableTableWidth, isCompactLayout: isCompactLayout);
    final dataSource = _CrudDataGridSource<T>(
      records: visibleRecords,
      visibleFields: _visibleFields,
      toMap: widget.formDefinition.toMap,
      formatCellValue: _formatCellValueForField,
      isCompactLayout: isCompactLayout,
      selectedRecordKey: _selectedRecordKey,
      recordKeyBuilder: _recordIdentity,
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
            if (_viewState.sortedRecords.isNotEmpty || _isServerBacked) ...[
              _buildSearchField(context),
              if (_effectiveSearchQuery.isNotEmpty && _filteredRecords.isEmpty && !_isLoading) ...[const SizedBox(height: 12), Text(l10n.noMatchingRecords, style: Theme.of(context).textTheme.bodyMedium)],
              const SizedBox(height: 20),
            ],
            if (_isLoading) ...[const LinearProgressIndicator(minHeight: 2), const SizedBox(height: 12)],
            if (_viewState.sortedRecords.isEmpty && !_isLoading)
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
                  child: ScrollConfiguration(
                    behavior: const MaterialScrollBehavior().copyWith(
                      dragDevices: <PointerDeviceKind>{PointerDeviceKind.touch, PointerDeviceKind.mouse, PointerDeviceKind.trackpad, PointerDeviceKind.stylus, PointerDeviceKind.unknown},
                    ),
                    child: Shortcuts(
                      shortcuts: const <ShortcutActivator, Intent>{SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(), SingleActivator(LogicalKeyboardKey.space): ActivateIntent()},
                      child: Actions(
                        actions: <Type, Action<Intent>>{
                          ActivateIntent: CallbackAction<ActivateIntent>(
                            onInvoke: (intent) {
                              _openSelectedRecord();
                              return null;
                            },
                          ),
                        },
                        child: Focus(
                          focusNode: _gridFocusNode,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minWidth: availableTableWidth),
                            child: SfDataGrid(
                              source: dataSource,
                              columns: columns,
                              frozenRowsCount: 1,
                              selectionMode: SelectionMode.single,
                              navigationMode: GridNavigationMode.row,
                              onCellTap: (details) {
                                _gridFocusNode.requestFocus();
                                final rowIndex = details.rowColumnIndex.rowIndex;
                                if (rowIndex <= 0 || rowIndex - 1 >= visibleRecords.length) {
                                  return;
                                }

                                setState(() {
                                  _selectedRecordKey = visibleRecordKeys[rowIndex - 1];
                                });
                              },
                              onCellDoubleTap: (details) {
                                final rowIndex = details.rowColumnIndex.rowIndex;
                                if (rowIndex <= 0 || rowIndex - 1 >= visibleRecords.length) {
                                  return;
                                }

                                final record = visibleRecords[rowIndex - 1];
                                setState(() {
                                  _selectedRecordKey = visibleRecordKeys[rowIndex - 1];
                                });
                                _openDetailsPage(record);
                              },
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
                    ),
                  ),
                ),
              ),
            if ((_viewState.sortedRecords.isNotEmpty || _isServerBacked) && !_isLoading) ...[
              const SizedBox(height: 16),
              _buildTableFooter(context, isCompactLayout: isCompactLayout, currentPage: currentPage, pageCount: pageCount),
            ],
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
    final defaultActionsWidth = isCompactLayout ? 132.0 : 156.0;
    final dataColumnCount = _visibleFields.length;
    final minimumDataWidth = isCompactLayout ? 110.0 : 160.0;
    final computedDataWidth = dataColumnCount == 0 ? minimumDataWidth : ((tableWidth - defaultActionsWidth) / dataColumnCount).clamp(minimumDataWidth, isCompactLayout ? 180.0 : 260.0);
    final widths = <String, double>{for (final field in _visibleFields) field.key: _columnWidths[field.key] ?? computedDataWidth};
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
      widths[field.key] = (widths[field.key] ?? computedDataWidth) + extraPerColumn;
    }
    widths[_actionsColumnName] = defaultActionsWidth;
    return widths;
  }

  List<ModelFormFieldDefinition> get _visibleFields {
    final fields = widget.formDefinition.fields;
    if (fields.isEmpty) {
      return fields;
    }

    final preferredKeys = widget.formDefinition.tableFieldPriorityKeys;
    if (preferredKeys.isNotEmpty) {
      final byKey = <String, ModelFormFieldDefinition>{for (final field in fields) field.key: field};
      final selected = <ModelFormFieldDefinition>[];
      for (final key in preferredKeys) {
        final field = byKey[key];
        if (field != null && !selected.contains(field)) {
          selected.add(field);
        }
        if (selected.length == 5) {
          break;
        }
      }

      if (selected.length == 5) {
        return selected;
      }
      if (selected.isNotEmpty) {
        for (final field in fields) {
          if (!selected.contains(field)) {
            selected.add(field);
          }
          if (selected.length == 5) {
            break;
          }
        }
        return selected;
      }
    }

    final sampleRecord = _records.isNotEmpty ? _records.first : widget.formDefinition.sampleModel;
    final sampleData = widget.formDefinition.toMap(sampleRecord);
    return _resolveVisibleFields(fields, sampleData, maxColumns: 5);
  }

  List<ModelFormFieldDefinition> _resolveVisibleFields(List<ModelFormFieldDefinition> fields, Map<String, dynamic> sampleData, {required int maxColumns}) {
    if (fields.length <= maxColumns) {
      return fields;
    }

    final scored = <_FieldPriority>[];
    for (var index = 0; index < fields.length; index++) {
      final field = fields[index];
      scored.add(_FieldPriority(index: index, field: field, score: _fieldPriorityScore(field, sampleData)));
    }

    scored.sort((left, right) {
      final scoreCompare = right.score.compareTo(left.score);
      if (scoreCompare != 0) {
        return scoreCompare;
      }
      return left.index.compareTo(right.index);
    });

    final selected = scored.take(maxColumns).toList(growable: false)..sort((left, right) => left.index.compareTo(right.index));
    return selected.map((entry) => entry.field).toList(growable: false);
  }

  int _fieldPriorityScore(ModelFormFieldDefinition field, Map<String, dynamic> sampleData) {
    final key = field.key;
    final lowerKey = key.toLowerCase();
    var score = 0;

    const titleKeys = <String>{'name', 'username', 'invoiceNumber', 'returnNumber', 'voucherNumber', 'transactionNumber', 'poNumber', 'orderNumber', 'transferNumber', 'supplierInvoiceNumber', 'batchNumber'};

    if (titleKeys.contains(key)) {
      score += 120;
    }

    if (key == 'status') {
      score += 95;
    }

    if (lowerKey.contains('amount') || lowerKey.contains('total') || lowerKey == 'quantity' || lowerKey.endsWith('quantity')) {
      score += 80;
    }

    if (lowerKey.contains('date') || lowerKey.endsWith('at')) {
      score += 70;
    }

    if (key == 'email' || key == 'phone') {
      score += 65;
    }

    if (_isRelationLikeField(key)) {
      score += 58;
      if (_resolveLinkedValueLabel(fieldKey: key, rowData: sampleData) != null) {
        score += 18;
      }
      if (key == 'ownerUuid' || key == 'createdByUserUuid') {
        score -= 18;
      }
    }

    if (_isTechnicalAuditField(key)) {
      score -= 90;
    }

    if (field.required) {
      score += 16;
    }

    if (field.readOnly) {
      score -= 4;
    }

    return score;
  }

  bool _isRelationLikeField(String key) {
    return key.endsWith('Uuid') || key == 'uuid' || key.endsWith('Id') || key == 'id';
  }

  bool _isTechnicalAuditField(String key) {
    return key == 'id' || key == 'uuid' || key == 'ownerUuid' || key == 'createdAt' || key == 'updatedAt' || key == 'deletedAt' || key == 'syncedAt' || key == 'synced';
  }

  String get _searchQuery => _searchController.text.trim();

  bool get _isServerBacked => widget.formDefinition.queryDelegate != null;

  List<T> get _filteredRecords {
    return _viewState.filteredRecords;
  }

  int get _pageCount {
    return _viewState.pageCount;
  }

  int get _effectiveCurrentPage => _viewState.effectiveCurrentPage;

  List<T> get _paginatedRecords {
    return _viewState.paginatedRecords;
  }

  String get _summaryRowCountLabel {
    return _viewState.summaryRowCountLabel;
  }

  Future<void> _refreshViewState({bool immediateSearch = false}) async {
    final query = _searchQuery;

    if (!immediateSearch) {
      _searchDebounce?.cancel();
      _searchDebounce = Timer(_searchDebounceDuration, () {
        unawaited(_applyQueryAndRefresh(query));
      });
      return;
    }

    await _applyQueryAndRefresh(query);
  }

  Future<void> _applyQueryAndRefresh(String searchQuery) async {
    final requestEpoch = ++_queryEpoch;
    final normalizedSearchQuery = searchQuery.trim();

    if (mounted) {
      setState(() {
        _effectiveSearchQuery = normalizedSearchQuery;
        _isLoading = true;
      });
    }

    try {
      final nextViewState = _isServerBacked ? await _computeServerViewState(searchQuery: normalizedSearchQuery) : await _computeLocalViewState(searchQuery: normalizedSearchQuery);

      if (!mounted || requestEpoch != _queryEpoch) {
        return;
      }

      setState(() {
        _viewState = nextViewState;
        _currentPage = _viewState.effectiveCurrentPage;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted || requestEpoch != _queryEpoch) {
        return;
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<_CachedCrudViewState<T>> _computeServerViewState({required String searchQuery}) async {
    final queryDelegate = widget.formDefinition.queryDelegate;
    if (queryDelegate == null) {
      return _computeSynchronousViewState(records: _records, searchQuery: searchQuery);
    }

    final result = await queryDelegate(ModelQueryRequest(searchQuery: searchQuery, sortColumnName: _sortColumnName, sortAscending: _sortAscending, pageIndex: _currentPage, pageSize: _rowsPerPage));

    final records = result.records;
    final pageCount = result.totalCount == 0 ? 1 : (result.totalCount / _rowsPerPage).ceil();
    final effectiveCurrentPage = math.min(_currentPage, pageCount - 1);
    final recordByKey = <String, T>{};
    final indexByRecordKey = <String, int>{};
    final paginatedRecordKeys = <String>[];

    for (var index = 0; index < records.length; index++) {
      final data = widget.formDefinition.toMap(records[index]);
      final recordKey = _recordIdentityFromMap(data);
      recordByKey[recordKey] = records[index];
      indexByRecordKey[recordKey] = index;
      paginatedRecordKeys.add(recordKey);
    }

    final overallCount = result.overallCount;
    final summaryRowCountLabel = overallCount == null || searchQuery.isEmpty ? result.totalCount.toString() : '${result.totalCount}/$overallCount';

    return _CachedCrudViewState<T>(
      filteredRecords: List<T>.unmodifiable(records),
      sortedRecords: List<T>.unmodifiable(records),
      paginatedRecords: List<T>.unmodifiable(records),
      paginatedRecordKeys: List<String>.unmodifiable(paginatedRecordKeys),
      recordByKey: Map<String, T>.unmodifiable(recordByKey),
      indexByRecordKey: Map<String, int>.unmodifiable(indexByRecordKey),
      totalRowCount: result.totalCount,
      pageCount: pageCount,
      effectiveCurrentPage: effectiveCurrentPage,
      summaryRowCountLabel: summaryRowCountLabel,
    );
  }

  Future<_CachedCrudViewState<T>> _computeLocalViewState({required String searchQuery}) async {
    final snapshots = _recordSnapshots;
    if (snapshots.length < _isolateThreshold) {
      return _computeSynchronousViewState(records: _records, searchQuery: searchQuery);
    }

    final payload = <String, Object?>{
      'searchQuery': searchQuery.toLowerCase(),
      'sortAscending': _sortAscending,
      'sortColumnName': _sortColumnName,
      'pageIndex': _currentPage,
      'pageSize': _rowsPerPage,
      'entries': snapshots
          .map((snapshot) => <String, Object?>{'index': snapshot.index, 'recordKey': snapshot.recordKey, 'searchBlob': snapshot.searchBlob, 'sortValue': _toIsolateSortValue(snapshot.data[_sortColumnName])})
          .toList(growable: false),
    };

    final isolateResult = await compute(_runLocalQueryInIsolate, payload);
    final filteredIndexes = List<int>.from(isolateResult['filteredIndexes'] as List<Object?>);
    final sortedIndexes = List<int>.from(isolateResult['sortedIndexes'] as List<Object?>);
    final paginatedIndexes = List<int>.from(isolateResult['paginatedIndexes'] as List<Object?>);
    final pageCount = isolateResult['pageCount'] as int;
    final effectiveCurrentPage = isolateResult['effectiveCurrentPage'] as int;

    final snapshotByIndex = <int, _RecordSnapshot<T>>{for (final snapshot in snapshots) snapshot.index: snapshot};
    final filteredRecords = filteredIndexes.map((index) => snapshotByIndex[index]!.record).toList(growable: false);
    final sortedRecords = sortedIndexes.map((index) => snapshotByIndex[index]!.record).toList(growable: false);
    final paginatedRecords = paginatedIndexes.map((index) => snapshotByIndex[index]!.record).toList(growable: false);
    final paginatedRecordKeys = paginatedIndexes.map((index) => snapshotByIndex[index]!.recordKey).toList(growable: false);
    final recordByKey = <String, T>{for (final index in sortedIndexes) snapshotByIndex[index]!.recordKey: snapshotByIndex[index]!.record};
    final indexByRecordKey = <String, int>{for (final snapshot in snapshots) snapshot.recordKey: snapshot.index};
    final summaryRowCountLabel = searchQuery.isEmpty ? sortedIndexes.length.toString() : '${sortedIndexes.length}/${_records.length}';

    return _CachedCrudViewState<T>(
      filteredRecords: List<T>.unmodifiable(filteredRecords),
      sortedRecords: List<T>.unmodifiable(sortedRecords),
      paginatedRecords: List<T>.unmodifiable(paginatedRecords),
      paginatedRecordKeys: List<String>.unmodifiable(paginatedRecordKeys),
      recordByKey: Map<String, T>.unmodifiable(recordByKey),
      indexByRecordKey: Map<String, int>.unmodifiable(indexByRecordKey),
      totalRowCount: sortedIndexes.length,
      pageCount: pageCount,
      effectiveCurrentPage: effectiveCurrentPage,
      summaryRowCountLabel: summaryRowCountLabel,
    );
  }

  _CachedCrudViewState<T> _computeSynchronousViewState({required List<T> records, required String searchQuery}) {
    final normalizedSearchQuery = searchQuery.toLowerCase();
    final snapshots = _recordSnapshots;
    final filteredSnapshots = searchQuery.isEmpty ? snapshots : snapshots.where((snapshot) => snapshot.searchBlob.contains(normalizedSearchQuery)).toList(growable: false);

    final sortedSnapshots = List<_RecordSnapshot<T>>.of(filteredSnapshots);
    final sortColumnName = _sortColumnName;
    if (sortColumnName != null) {
      sortedSnapshots.sort((left, right) {
        final leftValue = left.data[sortColumnName];
        final rightValue = right.data[sortColumnName];
        final result = _compareSortValues(leftValue, rightValue);
        return _sortAscending ? result : -result;
      });
    }

    final totalRows = sortedSnapshots.length;
    final pageCount = totalRows == 0 ? 1 : (totalRows / _rowsPerPage).ceil();
    final effectiveCurrentPage = math.min(_currentPage, pageCount - 1);
    final paginatedSnapshots = totalRows == 0 ? <_RecordSnapshot<T>>[] : sortedSnapshots.sublist(effectiveCurrentPage * _rowsPerPage, math.min((effectiveCurrentPage + 1) * _rowsPerPage, totalRows));

    final filteredRecords = filteredSnapshots.map((snapshot) => snapshot.record).toList(growable: false);
    final sortedRecords = sortedSnapshots.map((snapshot) => snapshot.record).toList(growable: false);
    final paginatedRecords = paginatedSnapshots.map((snapshot) => snapshot.record).toList(growable: false);
    final paginatedRecordKeys = paginatedSnapshots.map((snapshot) => snapshot.recordKey).toList(growable: false);
    final recordByKey = <String, T>{for (final snapshot in sortedSnapshots) snapshot.recordKey: snapshot.record};
    final indexByRecordKey = <String, int>{for (final snapshot in snapshots) snapshot.recordKey: snapshot.index};
    final summaryRowCountLabel = searchQuery.isEmpty ? totalRows.toString() : '$totalRows/${records.length}';

    return _CachedCrudViewState<T>(
      filteredRecords: List<T>.unmodifiable(filteredRecords),
      sortedRecords: List<T>.unmodifiable(sortedRecords),
      paginatedRecords: List<T>.unmodifiable(paginatedRecords),
      paginatedRecordKeys: List<String>.unmodifiable(paginatedRecordKeys),
      recordByKey: Map<String, T>.unmodifiable(recordByKey),
      indexByRecordKey: Map<String, int>.unmodifiable(indexByRecordKey),
      totalRowCount: totalRows,
      pageCount: pageCount,
      effectiveCurrentPage: effectiveCurrentPage,
      summaryRowCountLabel: summaryRowCountLabel,
    );
  }

  List<_RecordSnapshot<T>> get _recordSnapshots {
    final cached = _cachedRecordSnapshots;
    if (cached != null && _cachedSnapshotsVersion == _recordsVersion) {
      return cached;
    }

    final visibleFields = _visibleFields;
    final snapshots = <_RecordSnapshot<T>>[];
    for (var index = 0; index < _records.length; index++) {
      final record = _records[index];
      final data = widget.formDefinition.toMap(record);
      final searchBuffer = StringBuffer();
      for (final field in visibleFields) {
        final value = data[field.key];
        searchBuffer
          ..write(' ')
          ..write(_formatCellValue(value).toLowerCase())
          ..write(' ')
          ..write(value?.toString().toLowerCase() ?? '');
      }

      snapshots.add(_RecordSnapshot<T>(index: index, record: record, data: data, recordKey: _recordIdentityFromMap(data), searchBlob: searchBuffer.toString()));
    }

    _cachedRecordSnapshots = snapshots;
    _cachedSnapshotsVersion = _recordsVersion;
    return snapshots;
  }

  Object? _toIsolateSortValue(Object? value) {
    if (value == null || value is num || value is bool || value is String) {
      return value;
    }

    if (value is DateTime) {
      return value.millisecondsSinceEpoch;
    }

    return value.toString();
  }

  void _handleSearchChanged(String value) {
    setState(() {
      _currentPage = 0;
    });
    unawaited(_refreshViewState());
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
    unawaited(_refreshViewState(immediateSearch: true));
  }

  void _handleRowsPerPageChanged(int? value) {
    if (value == null || value == _rowsPerPage) {
      return;
    }

    setState(() {
      _rowsPerPage = value;
      _currentPage = 0;
    });
    unawaited(_refreshViewState(immediateSearch: true));
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
    final totalRows = _viewState.totalRowCount;
    final start = totalRows == 0 ? 0 : currentPage * _rowsPerPage + 1;
    final end = totalRows == 0 ? 0 : math.min((currentPage + 1) * _rowsPerPage, totalRows);
    final rowsPerPageOptions = isCompactLayout ? const <int>[5, 10, 15] : const <int>[10, 25, 50, 100];
    final selectedRowsPerPage = rowsPerPageOptions.contains(_rowsPerPage) ? _rowsPerPage : rowsPerPageOptions.first;

    final footerChildren = <Widget>[
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('${context.l10n.rowsPerPage}:', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(width: 8),
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
                    unawaited(_refreshViewState(immediateSearch: true));
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
                    unawaited(_refreshViewState(immediateSearch: true));
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
    unawaited(_performCreate(values));
  }

  Future<void> _performCreate(Map<String, dynamic> values) async {
    final model = widget.formDefinition.buildModel(values);
    final createDelegate = widget.formDefinition.createDelegate;
    final afterCreateHook = widget.formDefinition.afterCreateHook;

    if (_isServerBacked && createDelegate != null) {
      setState(() {
        _isLoading = true;
      });
      try {
        final createdModel = await createDelegate(model);
        if (afterCreateHook != null) {
          await afterCreateHook(model: createdModel, values: values);
        }
        if (!mounted) {
          return;
        }
        setState(() {
          _draftModel = widget.formDefinition.sampleModel;
          _showCreateForm = false;
          _currentPage = 0;
        });
        await _refreshViewState(immediateSearch: true);
        if (!mounted) {
          return;
        }
        _showFeedback(context.l10n.savedEntitySuccessfully(widget.entityLabel));
      } catch (error) {
        if (!mounted) {
          return;
        }
        setState(() {
          _isLoading = false;
        });
        _showError(error);
      }
      return;
    }

    if (afterCreateHook != null) {
      await afterCreateHook(model: model, values: values);
    }

    setState(() {
      _records.insert(0, model);
      _recordsVersion++;
      _draftModel = widget.formDefinition.sampleModel;
      _showCreateForm = false;
      _currentPage = 0;
    });
    await _refreshViewState(immediateSearch: true);
    if (!mounted) {
      return;
    }
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

    final updateDelegate = widget.formDefinition.updateDelegate;
    if (_isServerBacked && updateDelegate != null) {
      setState(() {
        _isLoading = true;
      });
      try {
        await updateDelegate(updatedModel);
        if (!mounted) {
          return;
        }
        await _refreshViewState(immediateSearch: true);
        if (!mounted) {
          return;
        }
        _showFeedback(context.l10n.updatedEntitySuccessfully(widget.entityLabel));
      } catch (error) {
        if (!mounted) {
          return;
        }
        setState(() {
          _isLoading = false;
        });
        _showError(error);
      }
      return;
    }

    final index = _indexOfRecord(record);
    if (index == -1) {
      return;
    }

    setState(() {
      _records[index] = updatedModel;
      _recordsVersion++;
      _currentPage = _effectiveCurrentPage;
    });
    unawaited(_refreshViewState(immediateSearch: true));
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

    final deleteDelegate = widget.formDefinition.deleteDelegate;
    if (_isServerBacked && deleteDelegate != null) {
      setState(() {
        _isLoading = true;
      });
      try {
        await deleteDelegate(record);
        if (!mounted) {
          return;
        }
        await _refreshViewState(immediateSearch: true);
        if (!mounted) {
          return;
        }
        _showFeedback(context.l10n.deletedEntitySuccessfully(widget.entityLabel));
      } catch (error) {
        if (!mounted) {
          return;
        }
        setState(() {
          _isLoading = false;
        });
        _showError(error);
      }
      return;
    }

    final index = _indexOfRecord(record);
    if (index == -1) {
      return;
    }

    setState(() {
      _records.removeAt(index);
      _recordsVersion++;
      _currentPage = _effectiveCurrentPage;
    });
    unawaited(_refreshViewState(immediateSearch: true));
    _showFeedback(context.l10n.deletedEntitySuccessfully(widget.entityLabel));
  }

  void _showError(Object error) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(error.toString()), backgroundColor: Theme.of(context).colorScheme.error));
  }

  void _openDetailsPage(T record) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => _ModelDetailsPage(entityLabel: widget.entityLabel, title: widget.title, icon: widget.icon, fields: widget.formDefinition.fields, data: widget.formDefinition.toMap(record)),
      ),
    );
  }

  int _indexOfRecord(T record) {
    final targetKey = _recordIdentity(record);
    return _viewState.indexByRecordKey[targetKey] ?? -1;
  }

  String _recordIdentity(T record) => _recordIdentityFromMap(widget.formDefinition.toMap(record));

  String _recordIdentityFromMap(Map<String, dynamic> data) {
    final uuid = data['uuid'];
    if (uuid != null && uuid.toString().isNotEmpty) {
      return 'uuid:$uuid';
    }

    final id = data['id'];
    if (id != null && id.toString().isNotEmpty) {
      return 'id:$id';
    }

    return data.toString();
  }

  T? get _selectedRecord {
    final selectedRecordKey = _selectedRecordKey;
    if (selectedRecordKey == null) {
      return null;
    }

    return _viewState.recordByKey[selectedRecordKey];
  }

  void _openSelectedRecord() {
    final record = _selectedRecord;
    if (record == null) {
      return;
    }

    _openDetailsPage(record);
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
    return _formatCellValueForField(fieldKey: null, value: value, rowData: const <String, dynamic>{});
  }

  String _formatCellValueForField({required String? fieldKey, required Object? value, required Map<String, dynamic> rowData}) {
    if (value == null) {
      return '-';
    }

    final key = fieldKey;
    if (key != null && _isRelationLikeField(key)) {
      final raw = value.toString().trim();
      if (raw.isEmpty) {
        return '-';
      }

      final linkedLabel = _resolveLinkedValueLabel(fieldKey: key, rowData: rowData);
      final compactIdentifier = _compactIdentifier(raw);
      if (linkedLabel != null) {
        return '$linkedLabel ($compactIdentifier)';
      }
      return compactIdentifier;
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

  String? _resolveLinkedValueLabel({required String fieldKey, required Map<String, dynamic> rowData}) {
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

    return null;
  }

  String _compactIdentifier(String raw) {
    if (raw.length <= 14) {
      return raw;
    }
    return '${raw.substring(0, 8)}...${raw.substring(raw.length - 4)}';
  }
}

class _CachedCrudViewState<T extends Object> {
  const _CachedCrudViewState({
    required this.filteredRecords,
    required this.sortedRecords,
    required this.paginatedRecords,
    required this.paginatedRecordKeys,
    required this.recordByKey,
    required this.indexByRecordKey,
    required this.totalRowCount,
    required this.pageCount,
    required this.effectiveCurrentPage,
    required this.summaryRowCountLabel,
  });

  final List<T> filteredRecords;
  final List<T> sortedRecords;
  final List<T> paginatedRecords;
  final List<String> paginatedRecordKeys;
  final Map<String, T> recordByKey;
  final Map<String, int> indexByRecordKey;
  final int totalRowCount;
  final int pageCount;
  final int effectiveCurrentPage;
  final String summaryRowCountLabel;
}

class _RecordSnapshot<T extends Object> {
  const _RecordSnapshot({required this.index, required this.record, required this.data, required this.recordKey, required this.searchBlob});

  final int index;
  final T record;
  final Map<String, dynamic> data;
  final String recordKey;
  final String searchBlob;
}

Map<String, Object> _runLocalQueryInIsolate(Map<String, Object?> payload) {
  final normalizedSearchQuery = (payload['searchQuery'] as String?) ?? '';
  final sortAscending = payload['sortAscending'] as bool? ?? true;
  final sortColumnName = payload['sortColumnName'] as String?;
  final pageIndex = payload['pageIndex'] as int? ?? 0;
  final pageSize = payload['pageSize'] as int? ?? 10;
  final rawEntries = List<Map<String, Object?>>.from(payload['entries'] as List<Object?>);

  final filteredEntries = normalizedSearchQuery.isEmpty ? rawEntries : rawEntries.where((entry) => ((entry['searchBlob'] as String?) ?? '').contains(normalizedSearchQuery)).toList(growable: false);

  final sortedEntries = List<Map<String, Object?>>.of(filteredEntries);
  if (sortColumnName != null) {
    sortedEntries.sort((left, right) {
      final leftValue = left['sortValue'];
      final rightValue = right['sortValue'];
      final result = _compareIsolateSortValues(leftValue, rightValue);
      return sortAscending ? result : -result;
    });
  }

  final totalRows = sortedEntries.length;
  final pageCount = totalRows == 0 ? 1 : (totalRows / pageSize).ceil();
  final effectiveCurrentPage = math.min(pageIndex, pageCount - 1);
  final start = effectiveCurrentPage * pageSize;
  final end = math.min(start + pageSize, totalRows);
  final paginatedEntries = totalRows == 0 ? const <Map<String, Object?>>[] : sortedEntries.sublist(start, end);

  return <String, Object>{
    'filteredIndexes': filteredEntries.map((entry) => entry['index'] as int).toList(growable: false),
    'sortedIndexes': sortedEntries.map((entry) => entry['index'] as int).toList(growable: false),
    'paginatedIndexes': paginatedEntries.map((entry) => entry['index'] as int).toList(growable: false),
    'pageCount': pageCount,
    'effectiveCurrentPage': effectiveCurrentPage,
  };
}

int _compareIsolateSortValues(Object? left, Object? right) {
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
  if (left is bool && right is bool) {
    return left == right ? 0 : (left ? 1 : -1);
  }

  return left.toString().toLowerCase().compareTo(right.toString().toLowerCase());
}

class _CrudDataGridSource<T extends Object> extends DataGridSource {
  _CrudDataGridSource({
    required List<T> records,
    required List<ModelFormFieldDefinition> visibleFields,
    required Map<String, dynamic> Function(T record) toMap,
    required String Function({required String? fieldKey, required Object? value, required Map<String, dynamic> rowData}) formatCellValue,
    required bool isCompactLayout,
    required String? selectedRecordKey,
    required String Function(T record) recordKeyBuilder,
    required String entityLabel,
    required AppLocalizations l10n,
    required void Function(T record) onView,
    required Future<void> Function(T record) onEdit,
    required Future<void> Function(T record) onDelete,
    required String actionsColumnName,
    required Color errorColor,
  }) : _entries = records
           .map((record) {
             final data = toMap(record);
             final row = DataGridRow(
               cells: [
                 for (final field in visibleFields) DataGridCell<Object?>(columnName: field.key, value: data[field.key]),
                 DataGridCell<String>(columnName: actionsColumnName, value: ''),
               ],
             );
             return _GridRowEntry<T>(record: record, row: row, recordKey: recordKeyBuilder(record), data: data);
           })
           .toList(growable: false),
       _formatCellValue = formatCellValue,
       _isCompactLayout = isCompactLayout,
       _selectedRecordKey = selectedRecordKey,
       _entityLabel = entityLabel,
       _l10n = l10n,
       _onView = onView,
       _onEdit = onEdit,
       _onDelete = onDelete,
       _actionsColumnName = actionsColumnName,
       _errorColor = errorColor,
       _recordByRow = <DataGridRow, T>{},
       _entryByRow = <DataGridRow, _GridRowEntry<T>>{} {
    for (final entry in _entries) {
      _recordByRow[entry.row] = entry.record;
      _entryByRow[entry.row] = entry;
    }
  }

  final List<_GridRowEntry<T>> _entries;
  late final List<DataGridRow> _rows = _entries.map((entry) => entry.row).toList(growable: false);
  final Map<DataGridRow, T> _recordByRow;
  final Map<DataGridRow, _GridRowEntry<T>> _entryByRow;
  final String Function({required String? fieldKey, required Object? value, required Map<String, dynamic> rowData}) _formatCellValue;
  final bool _isCompactLayout;
  final String? _selectedRecordKey;
  final String _entityLabel;
  final AppLocalizations _l10n;
  final void Function(T record) _onView;
  final Future<void> Function(T record) _onEdit;
  final Future<void> Function(T record) _onDelete;
  final String _actionsColumnName;
  final Color _errorColor;

  @override
  void dispose() {
    _recordByRow.clear();
    _entryByRow.clear();
    super.dispose();
  }

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final record = _recordByRow[row];
    final entry = _entryByRow[row];
    if (record == null) {
      return DataGridRowAdapter(
        cells: row.getCells().map((cell) => Text(_formatCellValue(fieldKey: cell.columnName, value: cell.value, rowData: const <String, dynamic>{}))).toList(growable: false),
      );
    }

    return DataGridRowAdapter(
      color: _selectedRecordKey != null && entry?.recordKey == _selectedRecordKey
          ? _l10n.isArabic
                ? Colors.teal.withValues(alpha: 0.10)
                : Colors.blue.withValues(alpha: 0.08)
          : null,
      cells: row
          .getCells()
          .map((cell) {
            if (cell.columnName == _actionsColumnName) {
              return _buildActionCell(record);
            }

            if (cell.columnName == 'status') {
              return _buildStatusCell(cell.value);
            }

            return Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                _formatCellValue(fieldKey: cell.columnName, value: cell.value, rowData: entry?.data ?? const <String, dynamic>{}),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            );
          })
          .toList(growable: false),
    );
  }

  Widget _buildStatusCell(Object? value) {
    final statusCode = _statusCodeFromValue(value);
    if (statusCode == null) {
      return Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Text(
          _formatCellValue(fieldKey: 'status', value: value, rowData: const <String, dynamic>{}),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      );
    }

    final icon = statusIconFor(statusCode);
    final label = statusLabelFor(statusCode, isArabic: _l10n.isArabic);
    final textColor = statusTextColorFor(statusCode);
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: statusBackgroundColorFor(statusCode),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: statusBorderColorFor(statusCode)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: textColor, size: 15),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int? _statusCodeFromValue(Object? value) {
    if (value is int) {
      return value;
    }
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  Widget _buildActionCell(T record) {
    if (_isCompactLayout) {
      return Align(
        alignment: Alignment.centerLeft,
        child: PopupMenuButton<_RowAction>(
          tooltip: _l10n.actions,
          icon: const Icon(Icons.more_horiz_rounded),
          onSelected: (action) {
            switch (action) {
              case _RowAction.view:
                _onView(record);
              case _RowAction.edit:
                _onEdit(record);
              case _RowAction.delete:
                _onDelete(record);
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem<_RowAction>(value: _RowAction.view, child: Text(_l10n.viewEntity(_entityLabel))),
            PopupMenuItem<_RowAction>(value: _RowAction.edit, child: Text(_l10n.editEntity(_entityLabel))),
            PopupMenuItem<_RowAction>(value: _RowAction.delete, child: Text(_l10n.deleteEntityQuestion(_entityLabel))),
          ],
        ),
      );
    }

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
}

class _GridRowEntry<T extends Object> {
  const _GridRowEntry({required this.record, required this.row, required this.recordKey, required this.data});

  final T record;
  final DataGridRow row;
  final String recordKey;
  final Map<String, dynamic> data;
}

class _FieldPriority {
  const _FieldPriority({required this.index, required this.field, required this.score});

  final int index;
  final ModelFormFieldDefinition field;
  final int score;
}

enum _RowAction { view, edit, delete }

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
