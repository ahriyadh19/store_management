import 'package:flutter/material.dart';
import 'package:store_management/localization/app_localizations.dart';
import 'package:store_management/services/local_database.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  static const List<_ReportMetricDefinition> _metricDefinitions = <_ReportMetricDefinition>[
    _ReportMetricDefinition(label: 'Stores', tableName: 'store', icon: Icons.store_mall_directory_rounded),
    _ReportMetricDefinition(label: 'Branches', tableName: 'branch', icon: Icons.storefront_rounded),
    _ReportMetricDefinition(label: 'Products', tableName: 'products', icon: Icons.inventory_2_rounded),
    _ReportMetricDefinition(label: 'Clients', tableName: 'client', icon: Icons.support_agent_rounded),
    _ReportMetricDefinition(label: 'Invoices', tableName: 'store_invoice', icon: Icons.receipt_long_rounded),
    _ReportMetricDefinition(label: 'Returns', tableName: 'store_return', icon: Icons.assignment_return_rounded),
    _ReportMetricDefinition(label: 'Transactions', tableName: 'store_financial_transaction', icon: Icons.sync_alt_rounded),
    _ReportMetricDefinition(label: 'Activity Logs', tableName: 'staff_activity_log', icon: Icons.history_rounded),
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
    final metrics = _metricDefinitions.map((definition) => _ReportMetric(definition: definition, value: _rowCount(database, definition.tableName))).toList(growable: false);
    final syncHealth = _buildSyncHealth(database);
    final activities = _recentActivities(database);

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
          Text('Operational Snapshot', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 14),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: metrics.map((metric) => _MetricCard(metric: metric)).toList(growable: false),
          ),
          const SizedBox(height: 28),
          Text('Sync Health', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 14),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _StatusCard(title: 'Pending writes', value: syncHealth.pendingWrites.toString(), caption: 'Records waiting for upload or retry across the tracked modules.', icon: Icons.cloud_upload_rounded),
              _StatusCard(title: 'Pending deletes', value: syncHealth.pendingDeletes.toString(), caption: 'Records marked for deletion that still need remote confirmation.', icon: Icons.delete_sweep_rounded),
              _StatusCard(title: 'Conflicts', value: syncHealth.conflicts.toString(), caption: 'Local rows that need review because remote data diverged from pending changes.', icon: Icons.warning_amber_rounded),
              _StatusCard(title: 'Cache availability', value: hasLocalData ? 'Ready' : 'Offline', caption: hasLocalData ? 'Analytics are reading from the cached data layer.' : 'Open a synced module to populate local analytics and history blocks.', icon: Icons.storage_rounded),
            ],
          ),
          const SizedBox(height: 28),
          Text('Recent Activity', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 14),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: activities.isEmpty
                  ? Text(
                      hasLocalData ? 'No cached history is available yet for the reporting timeline.' : l10n.noDataAvailable,
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

  static List<_RecentActivity> _recentActivities(LocalDatabase? database) {
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
      titleBuilder: (row) => row['action']?.toString() ?? 'Staff activity',
      subtitleBuilder: (row) => '${row['entityType'] ?? 'entity'} • ${row['entityUuid'] ?? row['uuid'] ?? '-'}',
    );
    collect(
      tableName: 'inventory_transaction',
      icon: Icons.inventory_rounded,
      titleBuilder: (row) => row['transactionType']?.toString() ?? 'Inventory transaction',
      subtitleBuilder: (row) => '${row['holderType'] ?? 'holder'} • ${row['holderUuid'] ?? row['uuid'] ?? '-'}',
    );
    collect(
      tableName: 'store_financial_transaction',
      icon: Icons.account_balance_wallet_rounded,
      titleBuilder: (row) => row['transactionType']?.toString() ?? 'Financial transaction',
      subtitleBuilder: (row) => '${row['sourceType'] ?? 'source'} • ${row['sourceUuid'] ?? row['uuid'] ?? '-'}',
    );
    collect(
      tableName: 'store_invoice',
      icon: Icons.receipt_long_rounded,
      titleBuilder: (row) => row['invoiceNumber']?.toString() ?? 'Invoice',
      subtitleBuilder: (row) => 'Total ${row['totalAmount'] ?? row['total_amount'] ?? '-'}',
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
                Text('Reports', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900, height: 1.05)),
                const SizedBox(height: 12),
                Text(
                  hasLocalData
                      ? 'Monitor module coverage, sync backlog, and recent workflow activity from the shared cached dataset.'
                      : 'This module is ready. Open synced management screens to populate analytics, timeline history, and cache-backed health indicators.',
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
          Text(metric.definition.label, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
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

class _ReportMetricDefinition {
  const _ReportMetricDefinition({required this.label, required this.tableName, required this.icon});

  final String label;
  final String tableName;
  final IconData icon;
}

class _ReportMetric {
  const _ReportMetric({required this.definition, required this.value});

  final _ReportMetricDefinition definition;
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