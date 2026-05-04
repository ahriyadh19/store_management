import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_management/controllers/auth_controller.dart';
import 'package:store_management/localization/app_localizations.dart';
import 'package:store_management/localization/locale_controller.dart';
import 'package:store_management/services/app_preferences_controller.dart';
import 'package:store_management/services/connection_status_controller.dart';
import 'package:store_management/services/local_database.dart';
import 'package:store_management/views/index/index_page.dart';
import 'package:store_management/views/index/index_page_registry.dart';

Widget _buildIndexDrawer(
  BuildContext context, {
  required IndexPage activePage,
  required ValueChanged<IndexPage> onOpenPage,
  required Set<_DrawerSectionKey> expandedSections,
  required VoidCallback onExpandAll,
  required VoidCallback onCollapseAll,
  required void Function(_DrawerSectionKey key, bool expanded) onSectionExpansionChanged,
}) {
  final l10n = context.l10n;
  final authState = context.watch<AuthController>().state;
  final user = authState.user;
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  final drawerSections = _buildDrawerSections(l10n);

  return Drawer(
    width: 330,
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [colorScheme.surface, colorScheme.surfaceContainerLow]),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(colors: [colorScheme.primary, colorScheme.primary.withValues(alpha: 0.78)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white.withValues(alpha: 0.18),
                    child: Text(
                      _initialsForUser(user?.name, authState.userEmail),
                      style: theme.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w800),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.menu,
                          style: theme.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.name.isNotEmpty == true ? user!.name : (authState.userEmail ?? l10n.signedInFallback),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.92)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(onPressed: onExpandAll, icon: const Icon(Icons.unfold_more_rounded, size: 18), label: Text(l10n.expandAll)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(onPressed: onCollapseAll, icon: const Icon(Icons.unfold_less_rounded, size: 18), label: Text(l10n.collapseAll)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...drawerSections.map(
              (section) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _DrawerSectionCard(
                  section: section,
                  activePage: activePage,
                  expanded: expandedSections.contains(section.key),
                  onOpenPage: onOpenPage,
                  onExpansionChanged: (expanded) => onSectionExpansionChanged(section.key, expanded),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

List<_DrawerSection> _buildDrawerSections(AppLocalizations l10n) {
  return [
    _DrawerSection(
      key: _DrawerSectionKey.overview,
      title: l10n.overview,
      icon: Icons.space_dashboard_rounded,
      items: [
        _DrawerItem(page: IndexPage.dashboard, label: l10n.dashboard, icon: Icons.dashboard_rounded, countsAsModule: false),
        _DrawerItem(page: IndexPage.reports, label: l10n.reports, icon: Icons.bar_chart_rounded, countsAsModule: false),
        _DrawerItem(page: IndexPage.stores, label: l10n.stores, icon: Icons.store_mall_directory_rounded),
        _DrawerItem(page: IndexPage.branches, label: l10n.branches, icon: Icons.storefront_rounded),
      ],
    ),
    _DrawerSection(
      key: _DrawerSectionKey.catalog,
      title: l10n.catalog,
      icon: Icons.inventory_2_rounded,
      items: [
        _DrawerItem(page: IndexPage.products, label: l10n.products, icon: Icons.inventory_2_rounded),
        _DrawerItem(page: IndexPage.categories, label: l10n.categories, icon: Icons.category_rounded),
        _DrawerItem(page: IndexPage.tags, label: l10n.tags, icon: Icons.sell_rounded),
      ],
    ),
    _DrawerSection(
      key: _DrawerSectionKey.sales,
      title: l10n.sales,
      icon: Icons.point_of_sale_rounded,
      items: [
        _DrawerItem(page: IndexPage.invoices, label: l10n.invoices, icon: Icons.receipt_long_rounded),
        _DrawerItem(page: IndexPage.returns, label: l10n.returns, icon: Icons.assignment_return_rounded),
        _DrawerItem(page: IndexPage.paymentVouchers, label: l10n.paymentVouchers, icon: Icons.account_balance_wallet_rounded),
      ],
    ),
    _DrawerSection(
      key: _DrawerSectionKey.people,
      title: l10n.people,
      icon: Icons.groups_rounded,
      items: [
        _DrawerItem(page: IndexPage.clients, label: l10n.clients, icon: Icons.support_agent_rounded),
        _DrawerItem(page: IndexPage.suppliers, label: l10n.suppliers, icon: Icons.apartment_rounded),
        _DrawerItem(page: IndexPage.users, label: l10n.users, icon: Icons.person_outline_rounded),
        _DrawerItem(page: IndexPage.roles, label: l10n.roles, icon: Icons.admin_panel_settings_rounded),
      ],
    ),
    _DrawerSection(
      key: _DrawerSectionKey.operations,
      title: l10n.operations,
      icon: Icons.settings_suggest_rounded,
      items: [
        _DrawerItem(page: IndexPage.inventory, label: l10n.inventory, icon: Icons.warehouse_rounded),
        _DrawerItem(page: IndexPage.transactions, label: l10n.transactions, icon: Icons.sync_alt_rounded),
      ],
    ),
  ];
}

String _initialsForUser(String? name, String? email) {
  final source = (name?.trim().isNotEmpty == true ? name!.trim() : email?.trim()) ?? '';
  if (source.isEmpty) {
    return 'SM';
  }

  final segments = source.split(RegExp(r'\s+|@|\.|_')).where((segment) => segment.isNotEmpty).toList();
  if (segments.isEmpty) {
    final end = source.length >= 2 ? 2 : source.length;
    return source.substring(0, end).toUpperCase();
  }

  return segments.take(2).map((segment) => segment[0].toUpperCase()).join();
}

class Index extends StatefulWidget {
  const Index({super.key, required this.localeController, required this.appPreferencesController});

  final LocaleController localeController;
  final AppPreferencesController appPreferencesController;

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> with WidgetsBindingObserver {
  final List<_WorkspaceTab> _tabs = <_WorkspaceTab>[];
  final ScrollController _tabScrollController = ScrollController();
  final Set<_DrawerSectionKey> _expandedDrawerSections = <_DrawerSectionKey>{};
  String? _activeTabId;
  int _nextTabSeed = 1;
  late final ConnectionStatusController _connectionStatusController;
  bool _isAppBarVisible = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _expandedDrawerSections.add(_drawerSectionForPage(IndexPageStorage.fromStorageKey(widget.appPreferencesController.lastIndexPageKey)));
    final restored = _restoreWorkspaceTabsFromPreferences();
    if (!restored) {
      final initialPage = IndexPageStorage.fromStorageKey(widget.appPreferencesController.lastIndexPageKey);
      _openPageInTab(initialPage, pinned: initialPage == IndexPage.dashboard, savePreference: false);
    }
    _connectionStatusController = ConnectionStatusController(localDatabase: context.read<LocalDatabase?>());
    _connectionStatusController.start();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _connectionStatusController.refresh();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tabScrollController.dispose();
    _connectionStatusController.dispose();
    super.dispose();
  }

  _WorkspaceTab? get _activeTab {
    for (final tab in _tabs) {
      if (tab.id == _activeTabId) {
        return tab;
      }
    }
    return null;
  }

  void _openPageInTab(IndexPage page, {bool pinned = false, bool savePreference = true}) {
    final tabId = 'tab_${_nextTabSeed++}';
    setState(() {
      _tabs.add(_WorkspaceTab(id: tabId, page: page, pinned: pinned, group: _groupForPage(page)));
      _activeTabId = tabId;
      _isAppBarVisible = true;
    });

    if (savePreference) {
      widget.appPreferencesController.saveLastIndexPageKey(page.storageKey);
    }
    _persistWorkspaceTabsState();
    _scrollTabsToEndSoon();
  }

  void _activateTab(String tabId, {bool savePreference = true}) {
    _WorkspaceTab? tab;
    for (final element in _tabs) {
      if (element.id == tabId) {
        tab = element;
        break;
      }
    }
    if (tab == null || tabId == _activeTabId) {
      return;
    }

    setState(() {
      _activeTabId = tabId;
      _isAppBarVisible = true;
    });

    if (savePreference) {
      widget.appPreferencesController.saveLastIndexPageKey(tab.page.storageKey);
    }
    _persistWorkspaceTabsState();
  }

  void _handleDrawerPageOpened(IndexPage page) {
    _expandedDrawerSections.add(_drawerSectionForPage(page));
    _openPageInTab(page);
    Navigator.of(context).maybePop();
  }

  void _setDrawerSectionExpanded(_DrawerSectionKey key, bool expanded) {
    setState(() {
      if (expanded) {
        _expandedDrawerSections.add(key);
      } else {
        _expandedDrawerSections.remove(key);
      }
    });
  }

  void _expandAllDrawerSections() {
    setState(() {
      _expandedDrawerSections
        ..clear()
        ..addAll(_DrawerSectionKey.values);
    });
  }

  void _collapseAllDrawerSections() {
    setState(() {
      _expandedDrawerSections.clear();
    });
  }

  void _closeTab(String tabId) {
    final index = _tabs.indexWhere((tab) => tab.id == tabId);
    if (index == -1) {
      return;
    }

    final tab = _tabs[index];
    if (tab.pinned) {
      return;
    }

    setState(() {
      _tabs.removeAt(index);
      if (_tabs.isEmpty) {
        final fallbackId = 'tab_${_nextTabSeed++}';
        _tabs.add(_WorkspaceTab(id: fallbackId, page: IndexPage.dashboard, pinned: true, group: _groupForPage(IndexPage.dashboard)));
        _activeTabId = fallbackId;
        return;
      }

      if (_activeTabId == tabId) {
        final nextIndex = math.min(index, _tabs.length - 1);
        _activeTabId = _tabs[nextIndex].id;
      }
    });

    final activeTab = _activeTab;
    if (activeTab != null) {
      widget.appPreferencesController.saveLastIndexPageKey(activeTab.page.storageKey);
    }
    _persistWorkspaceTabsState();
  }

  void _requestCloseTab(String tabId) async {
    _WorkspaceTab? tab;
    for (final candidate in _tabs) {
      if (candidate.id == tabId) {
        tab = candidate;
        break;
      }
    }

    if (tab == null || tab.pinned || !mounted) {
      return;
    }

    final authState = context.read<AuthController>().state;
    final pageDefinitions = buildIndexPageDefinitions(context, authState, localeController: widget.localeController, appPreferencesController: widget.appPreferencesController);
    final l10n = context.l10n;
    final tabTitle = pageDefinitions[tab.page]?.title ?? tab.page.name;
    final colorScheme = Theme.of(context).colorScheme;

    final shouldClose = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.closeTabQuestion),
          content: Text(l10n.closeTabWarning(tabTitle)),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.cancel)),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: colorScheme.error, foregroundColor: colorScheme.onError),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.closeTabAction),
            ),
          ],
        );
      },
    );

    if (shouldClose == true && mounted) {
      _closeTab(tabId);
    }
  }

  void _toggleTabPin(String tabId) {
    final index = _tabs.indexWhere((tab) => tab.id == tabId);
    if (index == -1) {
      return;
    }

    setState(() {
      final tab = _tabs[index];
      _tabs[index] = tab.copyWith(pinned: !tab.pinned);
    });
    _persistWorkspaceTabsState();
  }

  void _reorderTabs(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    if (oldIndex == newIndex || oldIndex < 0 || oldIndex >= _tabs.length || newIndex < 0 || newIndex > _tabs.length) {
      return;
    }

    setState(() {
      final tab = _tabs.removeAt(oldIndex);
      _tabs.insert(newIndex, tab);
    });
    _persistWorkspaceTabsState();
  }

  void _moveTabById(String tabId, int delta) {
    final index = _tabs.indexWhere((tab) => tab.id == tabId);
    if (index == -1) {
      return;
    }

    final targetIndex = (index + delta).clamp(0, _tabs.length - 1);
    if (targetIndex == index) {
      return;
    }

    setState(() {
      final tab = _tabs.removeAt(index);
      _tabs.insert(targetIndex, tab);
    });
    _persistWorkspaceTabsState();
  }

  void _closeAllUnpinnedTabs() {
    IndexPage? persistedPage;

    setState(() {
      _tabs.removeWhere((tab) => !tab.pinned);
      if (_tabs.isEmpty) {
        final fallbackId = 'tab_${_nextTabSeed++}';
        _tabs.add(_WorkspaceTab(id: fallbackId, page: IndexPage.dashboard, pinned: false, group: _groupForPage(IndexPage.dashboard)));
        _activeTabId = fallbackId;
        persistedPage = IndexPage.dashboard;
      } else {
        final hasCurrentActive = _activeTabId != null && _tabs.any((tab) => tab.id == _activeTabId);
        if (!hasCurrentActive) {
          _activeTabId = _tabs.first.id;
        }

        final activeTab = _tabs.firstWhere((tab) => tab.id == _activeTabId, orElse: () => _tabs.first);
        persistedPage = activeTab.page;
      }
    });

    if (persistedPage != null) {
      widget.appPreferencesController.saveLastIndexPageKey(persistedPage!.storageKey);
    }
    _persistWorkspaceTabsState();
  }

  Future<void> _confirmCloseAllUnpinnedTabs(Map<IndexPage, IndexPageDefinition> pageDefinitions) async {
    final unpinnedTabs = _tabs.where((tab) => !tab.pinned).toList(growable: false);
    if (unpinnedTabs.isEmpty || !mounted) {
      return;
    }

    final tabNames = unpinnedTabs.map((tab) => pageDefinitions[tab.page]?.title ?? tab.page.name).toList(growable: false);
    final listHeight = math.min(220.0, math.max(72.0, tabNames.length * 30.0));
    final shouldClose = await showDialog<bool>(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        final l10n = context.l10n;

        return AlertDialog(
          title: Text(l10n.dangerCloseAllUnpinnedTabsQuestion),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 280, minWidth: 320),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.dangerCloseAllUnpinnedTabsWarning, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 10),
                SizedBox(
                  height: listHeight,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (final tabName in tabNames)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              children: [
                                Icon(Icons.close_rounded, size: 15, color: colorScheme.error),
                                const SizedBox(width: 6),
                                Expanded(child: Text(tabName, overflow: TextOverflow.ellipsis)),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.cancel)),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: colorScheme.error, foregroundColor: colorScheme.onError),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.closeAll),
            ),
          ],
        );
      },
    );

    if (shouldClose == true && mounted) {
      _closeAllUnpinnedTabs();
    }
  }

  void _closeTabsToRight(String tabId) {
    final index = _tabs.indexWhere((tab) => tab.id == tabId);
    if (index == -1) {
      return;
    }

    final protectedIds = <String>{tabId};
    if (_activeTabId != null) {
      protectedIds.add(_activeTabId!);
    }

    setState(() {
      _tabs.removeWhere((tab) {
        final tabIndex = _tabs.indexOf(tab);
        if (tabIndex <= index) {
          return false;
        }
        if (tab.pinned || protectedIds.contains(tab.id)) {
          return false;
        }
        return true;
      });

      if (_activeTabId == null || !_tabs.any((tab) => tab.id == _activeTabId)) {
        _activeTabId = _tabs[index.clamp(0, _tabs.length - 1)].id;
      }
    });

    final activeTab = _activeTab;
    if (activeTab != null) {
      widget.appPreferencesController.saveLastIndexPageKey(activeTab.page.storageKey);
    }
    _persistWorkspaceTabsState();
  }

  bool _restoreWorkspaceTabsFromPreferences() {
    final rawState = widget.appPreferencesController.workspaceTabsState;
    if (rawState.isEmpty) {
      return false;
    }

    try {
      final decoded = json.decode(rawState);
      if (decoded is! Map<String, dynamic>) {
        return false;
      }

      final decodedTabs = decoded['tabs'];
      if (decodedTabs is! List) {
        return false;
      }

      final restoredTabs = <_WorkspaceTab>[];
      _nextTabSeed = 1;
      for (final item in decodedTabs) {
        if (item is! Map<String, dynamic>) {
          continue;
        }

        final page = IndexPageStorage.fromStorageKey(item['page'] as String?);
        final pinned = item['pinned'] == true;
        restoredTabs.add(_WorkspaceTab(id: 'tab_${_nextTabSeed++}', page: page, pinned: pinned, group: _groupForPage(page)));
      }

      if (restoredTabs.isEmpty) {
        return false;
      }

      var activeIndex = 0;
      final rawActiveIndex = decoded['activeIndex'];
      if (rawActiveIndex is int) {
        activeIndex = rawActiveIndex;
      }
      activeIndex = activeIndex.clamp(0, restoredTabs.length - 1);

      _tabs
        ..clear()
        ..addAll(restoredTabs);
      _activeTabId = _tabs[activeIndex].id;
      _isAppBarVisible = true;
      widget.appPreferencesController.saveLastIndexPageKey(_tabs[activeIndex].page.storageKey);
      return true;
    } catch (_) {
      return false;
    }
  }

  void _persistWorkspaceTabsState() {
    if (_tabs.isEmpty) {
      widget.appPreferencesController.saveWorkspaceTabsState('');
      return;
    }

    var activeIndex = _tabs.indexWhere((tab) => tab.id == _activeTabId);
    if (activeIndex == -1) {
      activeIndex = 0;
    }

    final payload = <String, dynamic>{
      'activeIndex': activeIndex,
      'tabs': [
        for (final tab in _tabs) <String, dynamic>{'page': tab.page.storageKey, 'pinned': tab.pinned},
      ],
    };

    widget.appPreferencesController.saveWorkspaceTabsState(json.encode(payload));
  }

  void _scrollTabsToEndSoon() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_tabScrollController.hasClients) {
        return;
      }

      _tabScrollController.animateTo(_tabScrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 180), curve: Curves.easeOut);
    });
  }

  void _recoverWorkspaceWithDashboard() {
    if (_tabs.isEmpty) {
      _openPageInTab(IndexPage.dashboard, pinned: true);
      return;
    }

    final dashboardTab = _tabs.where((tab) => tab.page == IndexPage.dashboard).toList(growable: false);
    if (dashboardTab.isNotEmpty) {
      _activateTab(dashboardTab.first.id);
      return;
    }

    _openPageInTab(IndexPage.dashboard, pinned: true);
  }

  Future<void> _confirmSignOut() async {
    final l10n = context.l10n;
    final didConfirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.logoutQuestion),
          content: Text(l10n.logoutWarning),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.cancel)),
            FilledButton(onPressed: () => Navigator.of(context).pop(true), child: Text(l10n.logout)),
          ],
        );
      },
    );

    if (didConfirm == true && mounted) {
      context.read<AuthController>().add(const AuthSignedOut());
    }
  }

  bool _handleBodyScrollNotification(ScrollNotification notification, bool stickyAppBar) {
    if (stickyAppBar || notification.metrics.axis != Axis.vertical || notification.depth != 0) {
      return false;
    }

    if (notification.metrics.pixels <= 0 && !_isAppBarVisible) {
      setState(() {
        _isAppBarVisible = true;
      });
      return false;
    }

    if (notification is ScrollUpdateNotification) {
      final scrollDelta = notification.scrollDelta ?? 0;
      if (scrollDelta > 0 && _isAppBarVisible) {
        setState(() {
          _isAppBarVisible = false;
        });
      } else if (scrollDelta < 0 && !_isAppBarVisible) {
        setState(() {
          _isAppBarVisible = true;
        });
      }
      return false;
    }

    if (notification is UserScrollNotification) {
      if (notification.direction == ScrollDirection.reverse && _isAppBarVisible) {
        setState(() {
          _isAppBarVisible = false;
        });
      } else if (notification.direction == ScrollDirection.forward && !_isAppBarVisible) {
        setState(() {
          _isAppBarVisible = true;
        });
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthController>().state;
    final pageDefinitions = buildIndexPageDefinitions(context, authState, localeController: widget.localeController, appPreferencesController: widget.appPreferencesController);
    final activeTab = _activeTab;
    if (activeTab == null) {
      return const SizedBox.shrink();
    }
    final selectedDefinition = pageDefinitions[activeTab.page]!;

    return AnimatedBuilder(
      animation: widget.appPreferencesController,
      builder: (context, child) {
        final stickyAppBar = widget.appPreferencesController.stickyAppBar;
        final effectiveToolbarHeight = stickyAppBar || _isAppBarVisible ? kToolbarHeight : 0.0;

        return Scaffold(
          drawer: _buildIndexDrawer(
            context,
            activePage: activeTab.page,
            onOpenPage: _handleDrawerPageOpened,
            expandedSections: _expandedDrawerSections,
            onExpandAll: _expandAllDrawerSections,
            onCollapseAll: _collapseAllDrawerSections,
            onSectionExpansionChanged: _setDrawerSectionExpanded,
          ),
          appBar: AppBar(
            toolbarHeight: effectiveToolbarHeight,
            title: effectiveToolbarHeight == 0 ? null : Text(selectedDefinition.title),
            centerTitle: true,
            elevation: 4,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.black.withValues(alpha: 0.12),
            actions: effectiveToolbarHeight == 0
                ? const <Widget>[]
                : [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: _ConnectionIndicators(controller: _connectionStatusController),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: VerticalDivider(width: 2, thickness: 3, indent: 12, endIndent: 12, color: Theme.of(context).dividerColor),
                    ),
                    IconButton(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      tooltip: context.l10n.settings,
                      icon: const Icon(Icons.settings_rounded),
                      onPressed: () {
                        _openPageInTab(IndexPage.settings, pinned: true);
                      },
                    ),
                    IconButton(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      color: Theme.of(context).colorScheme.error,
                      tooltip: context.l10n.logout,
                      icon: const Icon(Icons.logout_rounded),
                      onPressed: () {
                        _confirmSignOut();
                      },
                    ),
                  ],
          ),
          body: Column(
            children: [
              _WorkspaceTabBar(
                tabs: _tabs,
                activeTabId: _activeTabId,
                pageDefinitions: pageDefinitions,
                scrollController: _tabScrollController,
                onActivateTab: _activateTab,
                onCloseTab: _requestCloseTab,
                onTogglePin: _toggleTabPin,
                onReorderTabs: _reorderTabs,
                onMoveTab: _moveTabById,
                onCloseTabsToRight: _closeTabsToRight,
                onCloseAllUnpinned: () => _confirmCloseAllUnpinnedTabs(pageDefinitions),
                onRecoverDashboard: _recoverWorkspaceWithDashboard,
              ),
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) => _handleBodyScrollNotification(notification, stickyAppBar),
                  child: IndexedStack(
                    index: _tabs.indexWhere((tab) => tab.id == _activeTabId).clamp(0, _tabs.length - 1),
                    children: [for (final tab in _tabs) KeyedSubtree(key: ValueKey<String>('body_${tab.id}'), child: pageDefinitions[tab.page]!.bodyBuilder(context))],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/*

IconData _themeIconFor(ThemeMode mode) {
  switch (mode) {
    case ThemeMode.system:
      return Icons.brightness_auto_rounded;
    case ThemeMode.light:
      return Icons.light_mode_rounded;
    case ThemeMode.dark:
      return Icons.dark_mode_rounded;
  }
}
*/
enum _DrawerSectionKey { overview, catalog, sales, people, operations }

class _DrawerSection {
  const _DrawerSection({required this.key, required this.title, required this.icon, required this.items});

  final _DrawerSectionKey key;
  final String title;
  final IconData icon;
  final List<_DrawerItem> items;
}

class _DrawerItem {
  const _DrawerItem({required this.page, required this.label, required this.icon, this.countsAsModule = true});

  final IndexPage page;
  final String label;
  final IconData icon;
  final bool countsAsModule;
}

class _DrawerSectionCard extends StatelessWidget {
  const _DrawerSectionCard({required this.section, required this.activePage, required this.expanded, required this.onOpenPage, required this.onExpansionChanged});

  final _DrawerSection section;
  final IndexPage activePage;
  final bool expanded;
  final ValueChanged<IndexPage> onOpenPage;
  final ValueChanged<bool> onExpansionChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasActiveItem = section.items.any((item) => item.page == activePage);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          key: ValueKey<String>('drawer-section-${section.key.name}-$expanded'),
          initiallyExpanded: expanded || hasActiveItem,
          onExpansionChanged: onExpansionChanged,
          dense: true,
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          childrenPadding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          leading: Icon(section.icon, size: 20),
          title: Text(section.title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
          children: section.items.map((item) {
            final isActive = item.page == activePage;

            return ListTile(
              dense: true,
              selected: isActive,
              selectedTileColor: colorScheme.primaryContainer.withValues(alpha: 0.65),
              visualDensity: const VisualDensity(horizontal: -2, vertical: -3),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              leading: Icon(item.icon, size: 19, color: isActive ? colorScheme.primary : null),
              title: Text(
                item.label,
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: isActive ? FontWeight.w700 : FontWeight.w500, color: isActive ? colorScheme.primary : null),
              ),
              trailing: isActive ? Icon(Icons.arrow_outward_rounded, size: 18, color: colorScheme.primary) : null,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              onTap: () => onOpenPage(item.page),
            );
          }).toList(),
        ),
      ),
    );
  }
}

_DrawerSectionKey _drawerSectionForPage(IndexPage page) {
  switch (page) {
    case IndexPage.dashboard:
    case IndexPage.reports:
    case IndexPage.stores:
    case IndexPage.branches:
      return _DrawerSectionKey.overview;
    case IndexPage.products:
    case IndexPage.categories:
    case IndexPage.tags:
      return _DrawerSectionKey.catalog;
    case IndexPage.invoices:
    case IndexPage.returns:
    case IndexPage.paymentVouchers:
      return _DrawerSectionKey.sales;
    case IndexPage.clients:
    case IndexPage.suppliers:
    case IndexPage.users:
    case IndexPage.roles:
      return _DrawerSectionKey.people;
    case IndexPage.inventory:
    case IndexPage.transactions:
    case IndexPage.settings:
      return _DrawerSectionKey.operations;
  }
}

_TabGroup _groupForPage(IndexPage page) {
  switch (page) {
    case IndexPage.dashboard:
    case IndexPage.reports:
    case IndexPage.stores:
    case IndexPage.branches:
      return _TabGroup.overview;
    case IndexPage.products:
    case IndexPage.categories:
    case IndexPage.tags:
      return _TabGroup.catalog;
    case IndexPage.invoices:
    case IndexPage.returns:
    case IndexPage.paymentVouchers:
      return _TabGroup.sales;
    case IndexPage.clients:
    case IndexPage.suppliers:
    case IndexPage.users:
    case IndexPage.roles:
      return _TabGroup.people;
    case IndexPage.inventory:
    case IndexPage.transactions:
      return _TabGroup.operations;
    case IndexPage.settings:
      return _TabGroup.system;
  }
}

class _WorkspaceTab {
  const _WorkspaceTab({required this.id, required this.page, required this.pinned, required this.group});

  final String id;
  final IndexPage page;
  final bool pinned;
  final _TabGroup group;

  _WorkspaceTab copyWith({bool? pinned}) {
    return _WorkspaceTab(id: id, page: page, pinned: pinned ?? this.pinned, group: group);
  }
}

enum _TabGroup { overview, catalog, sales, people, operations, system }

class _WorkspaceTabBar extends StatelessWidget {
  const _WorkspaceTabBar({
    required this.tabs,
    required this.activeTabId,
    required this.pageDefinitions,
    required this.scrollController,
    required this.onActivateTab,
    required this.onCloseTab,
    required this.onTogglePin,
    required this.onReorderTabs,
    required this.onMoveTab,
    required this.onCloseTabsToRight,
    required this.onCloseAllUnpinned,
    required this.onRecoverDashboard,
  });

  final List<_WorkspaceTab> tabs;
  final String? activeTabId;
  final Map<IndexPage, IndexPageDefinition> pageDefinitions;
  final ScrollController scrollController;
  final ValueChanged<String> onActivateTab;
  final ValueChanged<String> onCloseTab;
  final ValueChanged<String> onTogglePin;
  final void Function(int oldIndex, int newIndex) onReorderTabs;
  final void Function(String tabId, int delta) onMoveTab;
  final ValueChanged<String> onCloseTabsToRight;
  final Future<void> Function() onCloseAllUnpinned;
  final VoidCallback onRecoverDashboard;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        border: Border(bottom: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left_rounded),
            tooltip: 'Scroll left',
            onPressed: () {
              if (scrollController.hasClients) {
                final newOffset = (scrollController.offset - 180).clamp(0.0, scrollController.position.maxScrollExtent);
                scrollController.animateTo(newOffset, duration: const Duration(milliseconds: 180), curve: Curves.easeOut);
              }
            },
          ),
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                ReorderableListView.builder(
                  key: const PageStorageKey<String>('workspace-tabs-strip'),
                  scrollController: scrollController,
                  scrollDirection: Axis.horizontal,
                  buildDefaultDragHandles: false,
                  itemCount: tabs.length,
                  onReorder: onReorderTabs,
                  proxyDecorator: (child, index, animation) {
                    return Material(color: Colors.transparent, elevation: 8, child: child);
                  },
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                  itemBuilder: (context, index) {
                    final tab = tabs[index];
                    final isActive = tab.id == activeTabId;
                    final definition = pageDefinitions[tab.page]!;

                    return _WorkspaceTabTile(
                      key: ValueKey<String>(tab.id),
                      tab: tab,
                      title: definition.title,
                      active: isActive,
                      onActivate: () => onActivateTab(tab.id),
                      onClose: tab.pinned ? null : () => onCloseTab(tab.id),
                      onTogglePin: () => onTogglePin(tab.id),
                      onCloseTabsToRight: () => onCloseTabsToRight(tab.id),
                      reorderHandle: ReorderableDragStartListener(
                        index: index,
                        child: Icon(Icons.drag_indicator_rounded, size: 17, color: colorScheme.onSurfaceVariant),
                      ),
                    );
                  },
                ),
                IgnorePointer(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 14,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [colorScheme.surfaceContainerLow, colorScheme.surfaceContainerLow.withValues(alpha: 0)]),
                      ),
                    ),
                  ),
                ),
                IgnorePointer(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 14,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(begin: Alignment.centerRight, end: Alignment.centerLeft, colors: [colorScheme.surfaceContainerLow, colorScheme.surfaceContainerLow.withValues(alpha: 0)]),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right_rounded),
            tooltip: 'Scroll right',
            onPressed: () {
              if (scrollController.hasClients) {
                final newOffset = (scrollController.offset + 180).clamp(0.0, scrollController.position.maxScrollExtent);
                scrollController.animateTo(newOffset, duration: const Duration(milliseconds: 180), curve: Curves.easeOut);
              }
            },
          ),
          _TabsOverflowMenu(
            tabs: tabs,
            activeTabId: activeTabId,
            pageDefinitions: pageDefinitions,
            onActivateTab: onActivateTab,
            onCloseTab: onCloseTab,
            onTogglePin: onTogglePin,
            onMoveTab: onMoveTab,
            onCloseAllUnpinned: onCloseAllUnpinned,
            onRecoverDashboard: onRecoverDashboard,
          ),
        ],
      ),
    );
  }
}

class _WorkspaceTabTile extends StatelessWidget {
  const _WorkspaceTabTile({
    super.key,
    required this.tab,
    required this.title,
    required this.active,
    required this.onActivate,
    required this.onTogglePin,
    required this.onCloseTabsToRight,
    required this.reorderHandle,
    this.onClose,
  });

  final _WorkspaceTab tab;
  final String title;
  final bool active;
  final VoidCallback onActivate;
  final VoidCallback onTogglePin;
  final VoidCallback onCloseTabsToRight;
  final Widget reorderHandle;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final groupColor = _groupColor(colorScheme, tab.group);
    final backgroundColor = active ? colorScheme.primaryContainer.withValues(alpha: 0.72) : colorScheme.surface;
    final borderColor = active ? colorScheme.primary : colorScheme.outlineVariant;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: PopupMenuButton<String>(
        tooltip: '',
        onSelected: (value) {
          if (value == 'pin') {
            onTogglePin();
          } else if (value == 'close-right') {
            onCloseTabsToRight();
          } else if (value == 'close' && onClose != null) {
            onClose!();
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem<String>(value: 'pin', child: Text(tab.pinned ? l10n.unpinTab : l10n.pinTab)),
          PopupMenuItem<String>(value: 'close-right', child: Text(l10n.closeTabsToRight)),
          if (onClose != null) PopupMenuItem<String>(value: 'close', child: Text(l10n.closeTabAction)),
        ],
        child: InkWell(
          onTap: onActivate,
          borderRadius: BorderRadius.circular(14),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 130),
            curve: Curves.easeOut,
            width: 236,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor),
              boxShadow: active ? [BoxShadow(color: colorScheme.primary.withValues(alpha: 0.18), blurRadius: 12, offset: const Offset(0, 4))] : null,
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(color: groupColor, shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelLarge?.copyWith(fontWeight: active ? FontWeight.w800 : FontWeight.w600),
                  ),
                ),
                InkWell(
                  onTap: onTogglePin,
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Icon(tab.pinned ? Icons.push_pin_rounded : Icons.push_pin_outlined, size: 16, color: tab.pinned ? colorScheme.primary : colorScheme.onSurfaceVariant),
                  ),
                ),
                const SizedBox(width: 6),
                if (onClose != null)
                  InkWell(
                    onTap: onClose,
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Icon(Icons.close_rounded, size: 16, color: colorScheme.error),
                    ),
                  )
                else
                  const SizedBox(width: 4),
                const SizedBox(width: 4),
                reorderHandle,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TabsOverflowMenu extends StatelessWidget {
  const _TabsOverflowMenu({
    required this.tabs,
    required this.activeTabId,
    required this.pageDefinitions,
    required this.onActivateTab,
    required this.onCloseTab,
    required this.onTogglePin,
    required this.onMoveTab,
    required this.onCloseAllUnpinned,
    required this.onRecoverDashboard,
  });

  final List<_WorkspaceTab> tabs;
  final String? activeTabId;
  final Map<IndexPage, IndexPageDefinition> pageDefinitions;
  final ValueChanged<String> onActivateTab;
  final ValueChanged<String> onCloseTab;
  final ValueChanged<String> onTogglePin;
  final void Function(String tabId, int delta) onMoveTab;
  final Future<void> Function() onCloseAllUnpinned;
  final VoidCallback onRecoverDashboard;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final hasUnpinnedTabs = tabs.any((tab) => !tab.pinned);

    return PopupMenuButton<String>(
      tooltip: l10n.openTabsTooltip('${tabs.length}'),
      constraints: const BoxConstraints(minWidth: 320, maxWidth: 420, maxHeight: 440),
      onSelected: (value) {
        if (value == 'close-unpinned') {
          Future<void>.microtask(onCloseAllUnpinned);
          return;
        }

        if (value == 'recover-dashboard') {
          onRecoverDashboard();
          return;
        }

        if (value.startsWith('open:')) {
          onActivateTab(value.substring(5));
          return;
        }

        if (value.startsWith('pin:')) {
          onTogglePin(value.substring(4));
          return;
        }

        if (value.startsWith('close:')) {
          onCloseTab(value.substring(6));
        }
      },
      itemBuilder: (context) {
        final entries = <PopupMenuEntry<String>>[];

        if (hasUnpinnedTabs) {
          entries.add(
            PopupMenuItem<String>(
              value: 'close-unpinned',
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded, size: 16, color: colorScheme.error),
                  const SizedBox(width: 8),
                  Text(
                    l10n.closeAllUnpinnedTabs,
                    style: TextStyle(color: colorScheme.error, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          );
          entries.add(const PopupMenuDivider());
        }

        if (tabs.isEmpty) {
          entries.add(
            PopupMenuItem<String>(
              value: 'recover-dashboard',
              child: Row(children: [const Icon(Icons.dashboard_rounded, size: 16), const SizedBox(width: 10), Text(l10n.openDashboard)]),
            ),
          );
          return entries;
        }

        for (final tab in tabs) {
          final tabIndex = tabs.indexOf(tab);
          final isActive = tab.id == activeTabId;
          final title = pageDefinitions[tab.page]?.title ?? tab.page.name;
          entries.add(
            PopupMenuItem<String>(
              enabled: false,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        Navigator.of(context).pop();
                        Future<void>.microtask(() => onActivateTab(tab.id));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                        child: Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: isActive ? FontWeight.w700 : FontWeight.w500, color: isActive ? colorScheme.primary : null),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: l10n.moveTabLeft,
                    visualDensity: VisualDensity.compact,
                    onPressed: tabIndex == 0 ? null : () => onMoveTab(tab.id, -1),
                    icon: Icon(Icons.chevron_left_rounded, size: 20, color: tabIndex == 0 ? colorScheme.onSurface.withValues(alpha: 0.32) : colorScheme.onSurface),
                  ),
                  IconButton(
                    tooltip: l10n.moveTabRight,
                    visualDensity: VisualDensity.compact,
                    onPressed: tabIndex == tabs.length - 1 ? null : () => onMoveTab(tab.id, 1),
                    icon: Icon(Icons.chevron_right_rounded, size: 20, color: tabIndex == tabs.length - 1 ? colorScheme.onSurface.withValues(alpha: 0.32) : colorScheme.onSurface),
                  ),
                  IconButton(
                    tooltip: tab.pinned ? l10n.unpinTab : l10n.pinTab,
                    visualDensity: VisualDensity.compact,
                    onPressed: () {
                      Navigator.of(context).pop();
                      Future<void>.microtask(() => onTogglePin(tab.id));
                    },
                    style: IconButton.styleFrom(backgroundColor: colorScheme.primaryContainer.withValues(alpha: 0.45), padding: const EdgeInsets.all(6)),
                    icon: Icon(tab.pinned ? Icons.push_pin_rounded : Icons.push_pin_outlined, size: 20, color: tab.pinned ? colorScheme.primary : colorScheme.onSurfaceVariant),
                  ),
                  IconButton(
                    tooltip: l10n.closeTabAction,
                    visualDensity: VisualDensity.compact,
                    onPressed: tab.pinned
                        ? null
                        : () {
                            Navigator.of(context).pop();
                            Future<void>.microtask(() => onCloseTab(tab.id));
                          },
                    style: IconButton.styleFrom(
                      backgroundColor: colorScheme.errorContainer.withValues(alpha: tab.pinned ? 0.12 : 0.45),
                      padding: const EdgeInsets.all(6),
                    ),
                    icon: Icon(Icons.close_rounded, size: 20, color: tab.pinned ? colorScheme.onSurface.withValues(alpha: 0.32) : colorScheme.error),
                  ),
                ],
              ),
            ),
          );
        }

        return entries;
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 6),
        child: Tooltip(
          message: l10n.openTabsTooltip('${tabs.length}'),
          child: Chip(avatar: const Icon(Icons.tab_rounded, size: 16), label: Text('${tabs.length}'), visualDensity: VisualDensity.compact),
        ),
      ),
    );
  }
}

Color _groupColor(ColorScheme scheme, _TabGroup group) {
  switch (group) {
    case _TabGroup.overview:
      return scheme.primary;
    case _TabGroup.catalog:
      return scheme.tertiary;
    case _TabGroup.sales:
      return scheme.secondary;
    case _TabGroup.people:
      return scheme.error;
    case _TabGroup.operations:
      return Colors.teal;
    case _TabGroup.system:
      return scheme.outline;
  }
}

class _ConnectionIndicators extends StatelessWidget {
  const _ConnectionIndicators({required this.controller});

  final ConnectionStatusController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ConnectionIndicatorDot(label: context.l10n.connectionSupabase, status: controller.supabaseState, icon: Icons.cloud_rounded),
            const SizedBox(width: 8),
            _ConnectionIndicatorDot(label: context.l10n.connectionObjectBox, status: controller.objectBoxState, icon: Icons.storage_rounded),
          ],
        );
      },
    );
  }
}

class _ConnectionIndicatorDot extends StatelessWidget {
  const _ConnectionIndicatorDot({required this.label, required this.status, required this.icon});

  final String label;
  final ConnectionIndicatorState status;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final color = switch (status) {
      ConnectionIndicatorState.active => Colors.green,
      ConnectionIndicatorState.processing => Colors.amber,
      ConnectionIndicatorState.failed => Colors.red,
    };

    final description = switch (status) {
      ConnectionIndicatorState.active => l10n.connectionStatusConnected,
      ConnectionIndicatorState.processing => l10n.connectionStatusChecking,
      ConnectionIndicatorState.failed => l10n.connectionStatusDisconnected,
    };

    return Tooltip(
      message: l10n.connectionStatusTooltip(label, description),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(width: 4),
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black.withValues(alpha: 0.25), width: 0.75),
            ),
          ),
        ],
      ),
    );
  }
}
