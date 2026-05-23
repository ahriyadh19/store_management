import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:store_management/data/entity_mapper.dart';
import 'package:store_management/localization/app_localizations.dart';
import 'package:store_management/services/owner_scope_service.dart';
import 'package:store_management/views/components/model_form.dart';
import 'package:store_management/views/index/index_page.dart';
import 'package:store_management/views/pages/main_module_pages.dart';
import 'package:store_management/views/pages/model_crud_page.dart';
import 'package:store_management/views/pages/model_module_pages.dart';

void main() {
  test('branch table is not treated as owner-scoped for sync queries', () {
    expect(tableUsesOwnerScopeForTesting('branch'), isFalse);
    expect(tableUsesOwnerScopeForTesting('store'), isTrue);
  });

  test('invoice-related client fields use dropdown selections', () {
    final english = appLocalizationsFor(const Locale('en'));

    expect(fieldUsesSelectionForTesting(invoiceFormDefinition(english), 'clientUuid'), isTrue);
    expect(fieldUsesSelectionForTesting(returnFormDefinition(english), 'clientUuid'), isTrue);
    expect(fieldUsesSelectionForTesting(paymentVoucherFormDefinition(english), 'clientUuid'), isTrue);
    expect(fieldUsesSelectionForTesting(salesOrderFormDefinition(english), 'customerUuid'), isTrue);
    expect(fieldUsesSelectionForTesting(salesInvoiceFormDefinition(english), 'customerUuid'), isTrue);
    expect(fieldUsesSearchableSelectionForTesting(invoiceFormDefinition(english), 'clientUuid'), isTrue);
    expect(fieldUsesSearchableSelectionForTesting(returnFormDefinition(english), 'clientUuid'), isTrue);
    expect(fieldUsesSearchableSelectionForTesting(paymentVoucherFormDefinition(english), 'clientUuid'), isTrue);
    expect(fieldUsesSearchableSelectionForTesting(salesOrderFormDefinition(english), 'customerUuid'), isTrue);
    expect(fieldUsesSearchableSelectionForTesting(salesInvoiceFormDefinition(english), 'customerUuid'), isTrue);
  });

  test('access and relation management fields use searchable selections', () {
    final english = appLocalizationsFor(const Locale('en'));

    expect(fieldUsesSelectionForTesting(storeFormDefinition(english), 'ownerUserUuid'), isTrue);
    expect(fieldUsesSelectionForTesting(branchFormDefinition(english), 'storeUuid'), isTrue);
    expect(fieldUsesSelectionForTesting(userRolesFormDefinition(english), 'userUuid'), isTrue);
    expect(fieldUsesSelectionForTesting(userRolesFormDefinition(english), 'roleUuid'), isTrue);
    expect(fieldUsesSelectionForTesting(accessPermissionFormDefinition(english), 'pageUuid'), isTrue);
    expect(fieldUsesSelectionForTesting(rolePermissionFormDefinition(english), 'roleUuid'), isTrue);
    expect(fieldUsesSelectionForTesting(rolePermissionFormDefinition(english), 'permissionUuid'), isTrue);
    expect(fieldUsesSelectionForTesting(userPermissionFormDefinition(english), 'userUuid'), isTrue);
    expect(fieldUsesSelectionForTesting(userPermissionFormDefinition(english), 'permissionUuid'), isTrue);
    expect(fieldUsesSelectionForTesting(storeUserFormDefinition(english), 'storeUuid'), isTrue);
    expect(fieldUsesSelectionForTesting(storeUserFormDefinition(english), 'branchUuid'), isTrue);
    expect(fieldUsesSelectionForTesting(storeUserFormDefinition(english), 'userUuid'), isTrue);
    expect(fieldUsesSelectionForTesting(storeUserFormDefinition(english), 'userRoleUuid'), isTrue);

    expect(fieldUsesSearchableSelectionForTesting(storeFormDefinition(english), 'ownerUserUuid'), isTrue);
    expect(fieldUsesSearchableSelectionForTesting(branchFormDefinition(english), 'storeUuid'), isTrue);
    expect(fieldUsesSearchableSelectionForTesting(userRolesFormDefinition(english), 'userUuid'), isTrue);
    expect(fieldUsesSearchableSelectionForTesting(rolePermissionFormDefinition(english), 'permissionUuid'), isTrue);
    expect(fieldUsesSearchableSelectionForTesting(storeUserFormDefinition(english), 'userUuid'), isTrue);
  });

  test('branch definition keeps a create hook for the store link', () {
    final english = appLocalizationsFor(const Locale('en'));

    expect(branchFormDefinition(english).afterCreateHook, isNotNull);
  });

  test('branch store selection is required before save', () {
    final english = appLocalizationsFor(const Locale('en'));
    final definition = branchFormDefinition(english);
    final storeField = definition.fields.firstWhere((field) => field.key == 'storeUuid');

    expect(storeField.required, isTrue);
  });

  test('access page and permission samples follow the shared users page catalog', () {
    final english = appLocalizationsFor(const Locale('en'));
    final pageDefinition = accessPageFormDefinition(english);
    final permissionDefinition = accessPermissionFormDefinition(english);
    final pageSample = pageDefinition.sampleModel;
    final permissionSample = permissionDefinition.sampleModel;
    final usersMetadata = indexPageMetadata(IndexPage.users);

    expect(pageSample.key, usersMetadata.routeKey);
    expect(pageSample.routeKey, usersMetadata.routeKey);
    expect(pageSample.title, localizedIndexPageTitle(english, IndexPage.users));
    expect(pageSample.module, usersMetadata.menuSection.name);
    expect(pageSample.icon, usersMetadata.iconName);
    expect(permissionSample.key, usersMetadata.permissionKey);
  });

  test('operational relation fields use selections for stable foreign keys', () {
    final english = appLocalizationsFor(const Locale('en'));

    expect(fieldUsesSelectionForTesting(paymentAllocationFormDefinition(english), 'paymentVoucherUuid'), isTrue);
    expect(fieldUsesSelectionForTesting(paymentAllocationFormDefinition(english), 'invoiceUuid'), isTrue);
    expect(fieldUsesSelectionForTesting(purchaseOrderFormDefinition(english), 'storeUuid'), isTrue);
    expect(fieldUsesSelectionForTesting(purchaseOrderFormDefinition(english), 'supplierUuid'), isTrue);
    expect(fieldUsesSelectionForTesting(purchaseOrderItemFormDefinition(english), 'purchaseOrderUuid'), isTrue);
    expect(fieldUsesSelectionForTesting(transferOrderFormDefinition(english), 'sourceBranchUuid'), isTrue);
    expect(fieldUsesSelectionForTesting(transferOrderFormDefinition(english), 'destinationBranchUuid'), isTrue);
    expect(fieldUsesSelectionForTesting(inventoryTransactionFormDefinition(english), 'linkedTransactionUuid'), isTrue);
    expect(fieldUsesSelectionForTesting(salesReturnFormDefinition(english), 'salesInvoiceUuid'), isTrue);
    expect(fieldUsesSelectionForTesting(branchPriceFormDefinition(english), 'branchUuid'), isTrue);
    expect(fieldUsesSelectionForTesting(branchPriceFormDefinition(english), 'productUuid'), isTrue);
    expect(fieldUsesSelectionForTesting(staffShiftFormDefinition(english), 'userUuid'), isTrue);
    expect(fieldUsesSelectionForTesting(staffAttendanceFormDefinition(english), 'staffShiftUuid'), isTrue);

    expect(fieldUsesSearchableSelectionForTesting(purchaseOrderItemFormDefinition(english), 'purchaseOrderUuid'), isTrue);
    expect(fieldUsesSearchableSelectionForTesting(transferOrderFormDefinition(english), 'sourceBranchUuid'), isTrue);
    expect(fieldUsesSearchableSelectionForTesting(inventoryTransactionFormDefinition(english), 'linkedTransactionUuid'), isTrue);
    expect(fieldUsesSearchableSelectionForTesting(staffAttendanceFormDefinition(english), 'staffShiftUuid'), isTrue);
  });

  test('scope defaults auto-fill owner, store, and branch UUIDs', () {
    const scope = OwnerScope(userUuid: 'user-1', ownerUuid: 'owner-1', storeUuids: <String>{'store-1'}, branchUuids: <String>{'branch-1'});

    final values = applyScopeDefaultsForTesting(tableName: 'sales_invoice', values: <String, dynamic>{'ownerUuid': null, 'storeUuid': '', 'branchUuid': '   ', 'createdByUserUuid': null}, scope: scope);

    expect(values['ownerUuid'], 'owner-1');
    expect(values['storeUuid'], 'store-1');
    expect(values['branchUuid'], 'branch-1');
    expect(values['createdByUserUuid'], 'user-1');
  });

  test('server query results search and sort by selection labels', () {
    final definition = ModelFormDefinition<_TableTestRecord>(
      fields: const [
        ModelFormFieldDefinition(
          key: 'clientUuid',
          label: 'Client',
          type: ModelFormFieldType.selection,
          options: [
            ModelFormSelectOption(label: 'Zulu Market', value: 'client-z'),
            ModelFormSelectOption(label: 'Blue Market', value: 'client-b'),
          ],
        ),
        ModelFormFieldDefinition(
          key: 'status',
          label: 'Status',
          type: ModelFormFieldType.selection,
          options: [
            ModelFormSelectOption(label: 'Pending', value: 'pending'),
            ModelFormSelectOption(label: 'Approved', value: 'approved'),
          ],
        ),
      ],
      mapper: EntityMapper<_TableTestRecord>(fromDataMap: _TableTestRecord.fromMap, toDataMap: (record) => record.toMap()),
      sampleModel: const _TableTestRecord(uuid: 'sample', clientUuid: 'client-b', status: 'pending', name: 'Sample'),
    );
    final records = <_TableTestRecord>[
      const _TableTestRecord(uuid: '2', clientUuid: 'client-z', status: 'pending', name: 'Second'),
      const _TableTestRecord(uuid: '1', clientUuid: 'client-b', status: 'approved', name: 'First'),
    ];

    final searched = buildQueryResultForTesting(
      records: records,
      request: const ModelQueryRequest(searchQuery: 'blue market', sortColumnName: null, sortAscending: true, pageIndex: 0, pageSize: 10),
      definition: definition,
    );

    expect(searched.records, hasLength(1));
    expect(searched.records.single.uuid, '1');

    final sorted = buildQueryResultForTesting(
      records: records,
      request: const ModelQueryRequest(searchQuery: '', sortColumnName: 'clientUuid', sortAscending: true, pageIndex: 0, pageSize: 10),
      definition: definition,
    );

    expect(sorted.records.map((record) => record.uuid).toList(), <String>['1', '2']);
  });

  testWidgets('server-backed table refetches when filtering invalidates the current page', (tester) async {
    tester.view.physicalSize = const Size(1600, 1800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final records = List<_TableTestRecord>.generate(
      11,
      (index) => _TableTestRecord(uuid: '${index + 1}', name: 'Item ${index + 1}', clientUuid: index.isEven ? 'client-b' : 'client-z', status: index.isEven ? 'approved' : 'pending'),
    );
    late final ModelFormDefinition<_TableTestRecord> definition;
    definition = ModelFormDefinition<_TableTestRecord>(
      tableName: 'table_test_records',
      fields: const [
        ModelFormFieldDefinition(key: 'name', label: 'Name', type: ModelFormFieldType.text),
        ModelFormFieldDefinition(
          key: 'clientUuid',
          label: 'Client',
          type: ModelFormFieldType.selection,
          options: [
            ModelFormSelectOption(label: 'Blue Market', value: 'client-b'),
            ModelFormSelectOption(label: 'Zulu Market', value: 'client-z'),
          ],
        ),
      ],
      mapper: EntityMapper<_TableTestRecord>(fromDataMap: _TableTestRecord.fromMap, toDataMap: (record) => record.toMap()),
      sampleModel: const _TableTestRecord(uuid: 'sample', clientUuid: 'client-b', status: 'pending', name: 'Sample'),
      queryDelegate: (request) async => buildQueryResultForTesting(records: records, request: request, definition: definition),
    );

    await tester.pumpWidget(
      MaterialApp(
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [AppLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
        home: Scaffold(
          body: ModelCrudPage<_TableTestRecord>(
            title: 'Table Test Records',
            entityLabel: 'Record',
            description: 'Verify server-backed datatable pagination and filtering.',
            icon: Icons.table_rows_rounded,
            formDefinition: definition,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byTooltip('Next page'));
    await tester.tap(find.byTooltip('Next page'));
    await tester.pumpAndSettle();
    expect(find.text('Item 11'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextField, 'Search table'), 'Item 1');
    await tester.pump(const Duration(milliseconds: 320));
    await tester.pumpAndSettle();

    expect(find.text('No data available'), findsNothing);
    expect(find.text('Item 10'), findsOneWidget);
  });

  testWidgets('product module page shows datatable, create toggle, and row actions', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [AppLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
        home: Scaffold(
          body: buildMainModulePage(
            page: IndexPage.products,
            title: 'Products',
            description: 'Prepare the product catalog with stock-ready items, pricing, and identifiers.',
            icon: Icons.inventory_2_rounded,
            highlights: const ['Product table', 'Pricing'],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Create Product'), findsOneWidget);
    expect(find.byType(Switch), findsOneWidget);
    expect(find.text('Show create'), findsOneWidget);
    expect(find.text('Products Datatable'), findsOneWidget);
    expect(find.text('View, edit, and delete are in the last column.'), findsOneWidget);
    expect(find.text('Rows per page:'), findsOneWidget);
    expect(find.text('10'), findsWidgets);

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    expect(find.text('Hide create'), findsOneWidget);
  });

  testWidgets('inventory module shows dedicated purchase receiving panel', (tester) async {
    tester.view.physicalSize = const Size(1600, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [AppLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
        home: Scaffold(
          body: buildMainModulePage(
            page: IndexPage.inventory,
            title: 'Inventory',
            description: 'Track stock movements and receiving operations.',
            icon: Icons.warehouse_rounded,
            highlights: const ['Stock movement', 'Transfers'],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Purchase receiving'), findsOneWidget);
    expect(find.text('Post purchase receipt'), findsOneWidget);
    expect(find.text('Batches'), findsOneWidget);
    expect(find.text('Transactions'), findsOneWidget);
    expect(find.byKey(const Key('purchase-receipt-storeUuid')), findsOneWidget);
    expect(find.byKey(const Key('purchase-receipt-branchUuid')), findsOneWidget);
    expect(find.byKey(const Key('purchase-receipt-supplierInvoiceUuid')), findsOneWidget);
    expect(find.byKey(const Key('purchase-receipt-productUuid')), findsOneWidget);
    expect(find.byKey(const Key('purchase-receipt-staffUserUuid')), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Quantity'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Unit cost'), findsOneWidget);
  });
}

class _TableTestRecord {
  const _TableTestRecord({required this.uuid, required this.clientUuid, required this.status, required this.name});

  final String uuid;
  final String clientUuid;
  final String status;
  final String name;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'uuid': uuid, 'clientUuid': clientUuid, 'status': status, 'name': name};
  }

  static _TableTestRecord fromMap(Map<String, dynamic> map) {
    return _TableTestRecord(uuid: map['uuid']?.toString() ?? '', clientUuid: map['clientUuid']?.toString() ?? '', status: map['status']?.toString() ?? '', name: map['name']?.toString() ?? '');
  }
}
