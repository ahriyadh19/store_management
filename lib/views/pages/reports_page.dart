import 'package:flutter/material.dart';
import 'package:store_management/localization/app_localizations.dart';
import 'package:store_management/services/local_database.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  static const List<_ReportMetricDefinition> _metricDefinitions = <_ReportMetricDefinition>[
    _ReportMetricDefinition(tableName: 'store', icon: Icons.store_mall_directory_rounded),
    _ReportMetricDefinition(tableName: 'branch', icon: Icons.storefront_rounded),
    _ReportMetricDefinition(tableName: 'products', icon: Icons.inventory_2_rounded),
    _ReportMetricDefinition(tableName: 'client', icon: Icons.support_agent_rounded),
    _ReportMetricDefinition(tableName: 'store_invoice', icon: Icons.receipt_long_rounded),
    _ReportMetricDefinition(tableName: 'store_return', icon: Icons.assignment_return_rounded),
    _ReportMetricDefinition(tableName: 'store_financial_transaction', icon: Icons.sync_alt_rounded),
    _ReportMetricDefinition(tableName: 'staff_activity_log', icon: Icons.history_rounded),
  ];

  static const List<String> _syncTables = <String>[
    'store',
    'branch',
    'products',
    'client',
    'supplier',
    'store_invoice',
    'store_return',
    'store_payment_voucher',
    'store_financial_transaction',
    'inventory_transaction',
    'staff_activity_log',
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final database = LocalDatabase.current;
    final hasLocalData = database != null && database.isAvailable;
    final metrics = _metricDefinitions
        .map((definition) => _ReportMetric(definition: definition, label: _metricLabel(l10n, definition.tableName), value: _rowCount(database, definition.tableName)))
        .toList(growable: false);
    final syncHealth = _buildSyncHealth(database);
    final activities = _recentActivities(database, l10n);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[colorScheme.surface, colorScheme.surfaceContainerLow],
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _ReportsHero(hasLocalData: hasLocalData),
          const SizedBox(height: 24),
          Text(l10n.pick('Operational Snapshot', 'ملخص العمليات'), style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 14),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: metrics.map((metric) => _MetricCard(metric: metric)).toList(growable: false),
          ),
          const SizedBox(height: 28),
          Text(l10n.pick('Sync Health', 'صحة المزامنة'), style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 14),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _StatusCard(
                title: l10n.pick('Pending writes', 'عمليات كتابة معلقة'),
                value: syncHealth.pendingWrites.toString(),
                caption: l10n.pick('Records waiting for upload or retry across the tracked modules.', 'سجلات تنتظر الرفع أو إعادة المحاولة عبر الوحدات المتتبعة.'),
                icon: Icons.cloud_upload_rounded,
              ),
              _StatusCard(
                title: l10n.pick('Pending deletes', 'عمليات حذف معلقة'),
                value: syncHealth.pendingDeletes.toString(),
                caption: l10n.pick('Records marked for deletion that still need remote confirmation.', 'سجلات تم تمييزها للحذف وما زالت تحتاج إلى تأكيد من الخادم.'),
                icon: Icons.delete_sweep_rounded,
              ),
              _StatusCard(
                title: l10n.pick('Conflicts', 'التعارضات'),
                value: syncHealth.conflicts.toString(),
                caption: l10n.pick('Local rows that need review because remote data diverged from pending changes.', 'صفوف محلية تحتاج إلى مراجعة لأن البيانات البعيدة اختلفت عن التغييرات المعلقة.'),
                icon: Icons.warning_amber_rounded,
              ),
              _StatusCard(
                title: l10n.pick('Cache availability', 'توفر التخزين المؤقت'),
                value: hasLocalData ? l10n.pick('Ready', 'جاهز') : l10n.pick('Offline', 'غير متصل'),
                caption: hasLocalData
                    ? l10n.pick('Analytics are reading from the cached data layer.', 'تقرأ التحليلات من طبقة البيانات المخزنة محليًا.')
                    : l10n.pick('Open a synced module to populate local analytics and history blocks.', 'افتح وحدة متزامنة لملء التحليلات المحلية وسجل النشاط.'),
                icon: Icons.storage_rounded,
              ),
            ],
          ),
          const SizedBox(height: 28),
          Text(l10n.pick('Recent Activity', 'النشاط الأخير'), style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 14),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: activities.isEmpty
                  ? Text(
                      hasLocalData ? l10n.pick('No cached history is available yet for the reporting timeline.', 'لا يتوفر سجل مخزن محليًا حتى الآن لخط التقارير الزمني.') : l10n.noDataAvailable,
                      style: theme.textTheme.bodyLarge,
                    )
                  : Column(
                      children: [
                        for (final activity in activities) ...[
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundColor: colorScheme.primaryContainer,
                              child: Icon(activity.icon, color: colorScheme.onPrimaryContainer),
                            ),
                            title: Text(activity.title),
                            subtitle: Text(activity.subtitle),
                            trailing: Text(activity.timestampLabel, style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                          ),
                          if (activity != activities.last) const Divider(height: 1),
                        ],
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  static int _rowCount(LocalDatabase? database, String tableName) {
    if (database == null || !database.isAvailable) {
      return 0;
    }

    return database.getRowsForType(tableName).where((row) => row['deletedAt'] == null && row['deleted_at'] == null).length;
  }

  static _SyncHealth _buildSyncHealth(LocalDatabase? database) {
    if (database == null || !database.isAvailable) {
      return const _SyncHealth(pendingWrites: 0, pendingDeletes: 0, conflicts: 0);
    }

    var pendingWrites = 0;
    var pendingDeletes = 0;
    for (final tableName in _syncTables) {
      for (final record in database.getRecordsForType(tableName)) {
        if (record.syncState == 1) {
          pendingWrites++;
        }
        if (record.syncState == 2 || record.isDeleted) {
          pendingDeletes++;
        }
      }
    }

    return _SyncHealth(pendingWrites: pendingWrites, pendingDeletes: pendingDeletes, conflicts: database.getConflictedRecords().length);
  }

  static List<_RecentActivity> _recentActivities(LocalDatabase? database, AppLocalizations l10n) {
    if (database == null || !database.isAvailable) {
      return const <_RecentActivity>[];
    }

    final items = <_RecentActivity>[];
    void collect({required String tableName, required IconData icon, required String Function(Map<String, dynamic> row) titleBuilder, required String Function(Map<String, dynamic> row) subtitleBuilder}) {
      for (final row in database.getRowsForType(tableName)) {
        if (row['deletedAt'] != null || row['deleted_at'] != null) {
          continue;
        }

        items.add(
          _RecentActivity(
            title: titleBuilder(row),
            subtitle: subtitleBuilder(row),
            icon: icon,
            timestampMillis: _timestampFromRow(row),
          ),
        );
      }
    }

    collect(
      tableName: 'staff_activity_log',
      icon: Icons.history_rounded,
      titleBuilder: (row) => row['action']?.toString() ?? l10n.pick('Staff activity', 'نشاط الموظف'),
      subtitleBuilder: (row) => '${row['entityType'] ?? 'entity'} • ${row['entityUuid'] ?? row['uuid'] ?? '-'}',
    );
    collect(
      tableName: 'inventory_transaction',
      icon: Icons.inventory_rounded,
      titleBuilder: (row) => row['transactionType']?.toString() ?? l10n.pick('Inventory transaction', 'حركة مخزون'),
      subtitleBuilder: (row) => '${row['holderType'] ?? 'holder'} • ${row['holderUuid'] ?? row['uuid'] ?? '-'}',
    );
    collect(
      tableName: 'store_financial_transaction',
      icon: Icons.account_balance_wallet_rounded,
      titleBuilder: (row) => row['transactionType']?.toString() ?? l10n.pick('Financial transaction', 'معاملة مالية'),
      subtitleBuilder: (row) => '${row['sourceType'] ?? 'source'} • ${row['sourceUuid'] ?? row['uuid'] ?? '-'}',
    );
    collect(
      tableName: 'store_invoice',
      icon: Icons.receipt_long_rounded,
      titleBuilder: (row) => row['invoiceNumber']?.toString() ?? l10n.pick('Invoice', 'فاتورة'),
      subtitleBuilder: (row) => '${l10n.pick('Total', 'الإجمالي')} ${row['totalAmount'] ?? row['total_amount'] ?? '-'}',
    );

    items.sort((left, right) => right.timestampMillis.compareTo(left.timestampMillis));
    return items.take(6).toList(growable: false);
  }

  static int _timestampFromRow(Map<String, dynamic> row) {
    const keys = <String>['updatedAt', 'updated_at', 'createdAt', 'created_at', 'transactionDate', 'issuedAt'];
    for (final key in keys) {
      final value = row[key];
      if (value is int) {
        return value;
      }
      if (value is num) {
        return value.toInt();
      }
      if (value is String) {
        final asInt = int.tryParse(value);
        if (asInt != null) {
          return asInt;
        }
        final asDate = DateTime.tryParse(value);
        if (asDate != null) {
          return asDate.millisecondsSinceEpoch;
        }
      }
      if (value is DateTime) {
        return value.millisecondsSinceEpoch;
      }
    }

    return 0;
  }
}

class _ReportsHero extends StatelessWidget {
  const _ReportsHero({required this.hasLocalData});

  final bool hasLocalData;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(colors: <Color>[colorScheme.primaryContainer, colorScheme.tertiaryContainer], begin: Alignment.topLeft, end: Alignment.bottomRight),
      ),
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          CircleAvatar(radius: 34, backgroundColor: colorScheme.surface, child: Icon(Icons.bar_chart_rounded, color: colorScheme.primary, size: 34)),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.reports, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900, height: 1.05)),
                const SizedBox(height: 12),
                Text(
                  hasLocalData
                      ? context.l10n.pick('Monitor module coverage, sync backlog, and recent workflow activity from the shared cached dataset.', 'راقب تغطية الوحدات وتراكم المزامنة والنشاط التشغيلي الأخير من مجموعة البيانات المخزنة المشتركة.')
                      : context.l10n.pick('This module is ready. Open synced management screens to populate analytics, timeline history, and cache-backed health indicators.', 'هذه الوحدة جاهزة. افتح شاشات الإدارة المتزامنة لملء التحليلات وسجل النشاط ومؤشرات صحة التخزين المؤقت.'),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.metric});

  final _ReportMetric metric;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: 220,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(metric.definition.icon, color: colorScheme.primary),
          const SizedBox(height: 12),
          Text(metric.label, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(metric.value.toString(), style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.title, required this.value, required this.caption, required this.icon});

  final String title;
  final String value;
  final String caption;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: 260,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colorScheme.primary),
          const SizedBox(height: 12),
          Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Text(caption, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant, height: 1.45)),
        ],
      ),
    );
  }
}

String _metricLabel(AppLocalizations l10n, String tableName) {
  return switch (tableName) {
    'store' => l10n.stores,
    'branch' => l10n.branches,
    'products' => l10n.products,
    'client' => l10n.clients,
    'store_invoice' => l10n.invoices,
    'store_return' => l10n.returns,
    'store_financial_transaction' => l10n.transactions,
    'staff_activity_log' => l10n.pick('Activity Logs', 'سجلات النشاط'),
    _ => tableName,
  };
}

class _ReportMetricDefinition {
  const _ReportMetricDefinition({required this.tableName, required this.icon});

  final String tableName;
  final IconData icon;
}

class _ReportMetric {
  const _ReportMetric({required this.definition, required this.label, required this.value});

  final _ReportMetricDefinition definition;
  final String label;
  final int value;
}

class _SyncHealth {
  const _SyncHealth({required this.pendingWrites, required this.pendingDeletes, required this.conflicts});

  final int pendingWrites;
  final int pendingDeletes;
  final int conflicts;
}

class _RecentActivity {
  const _RecentActivity({required this.title, required this.subtitle, required this.icon, required this.timestampMillis});

  final String title;
  final String subtitle;
  final IconData icon;
  final int timestampMillis;

  String get timestampLabel {
    if (timestampMillis <= 0) {
      return '-';
    }
    final date = DateTime.fromMillisecondsSinceEpoch(timestampMillis);
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '${date.year}-$month-$day $hour:$minute';
  }
}