import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show Supabase;
import 'package:store_management/app/app.dart';
import 'package:store_management/app/bootstrap.dart';
import 'package:store_management/localization/locale_controller.dart';
import 'package:store_management/services/app_preferences_controller.dart';
import 'package:store_management/services/local_database.dart';
import 'package:store_management/services/local_database_management_controller.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (isDesktopPlatform) {
    await windowManager.ensureInitialized();
    await prepareDesktopWindow();
  }

  final localeController = await LocaleController.create();
  final appPreferencesController = await AppPreferencesController.create();
  final localDatabase = await LocalDatabase.create();
  final localDatabaseManagementController = await LocalDatabaseManagementController.create(appPreferencesController: appPreferencesController, localDatabase: localDatabase);
  final reconciledRecordCount = localDatabase.reconcileSyncMetadata();
  if (kDebugMode && reconciledRecordCount > 0) {
    debugPrint('Reconciled sync metadata for $reconciledRecordCount local records.');
  }

  Object? startupError;
  StackTrace? startupStackTrace;

  try {
    final config = await loadSupabaseConfig();
    await Supabase.initialize(url: config.url, anonKey: config.anonKey, authOptions: buildAuthOptions());
  } catch (error, stackTrace) {
    startupError = error;
    startupStackTrace = stackTrace;
  }

  localDatabaseManagementController.startSyncMonitoring();

  runApp(
    MyApp(
      localeController: localeController,
      appPreferencesController: appPreferencesController,
      localDatabase: localDatabase,
      localDatabaseManagementController: localDatabaseManagementController,
      startupError: startupError,
      startupStackTrace: startupStackTrace,
    ),
  );
}
