import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show FlutterAuthClientOptions, Supabase;
import 'package:store_management/controllers/auth_controller.dart';
import 'package:store_management/index.dart';
import 'package:store_management/localization/app_localizations.dart';
import 'package:store_management/localization/locale_controller.dart';
import 'package:store_management/services/app_preferences_controller.dart';
import 'package:store_management/services/auth_repository.dart';
import 'package:store_management/services/local_database.dart';
import 'package:store_management/services/supabase_auth_storage.dart';
import 'package:store_management/views/auth_view.dart';

const _supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const _supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final localeController = await LocaleController.create();
  final appPreferencesController = await AppPreferencesController.create();
  final localDatabase = await LocalDatabase.create();

  Object? startupError;
  StackTrace? startupStackTrace;

  try {
    final config = await _loadSupabaseConfig();
    await Supabase.initialize(url: config.url, anonKey: config.anonKey, authOptions: _buildAuthOptions());
  } catch (error, stackTrace) {
    startupError = error;
    startupStackTrace = stackTrace;
  }

  runApp(MyApp(localeController: localeController, appPreferencesController: appPreferencesController, localDatabase: localDatabase, startupError: startupError, startupStackTrace: startupStackTrace));
}

bool get _isDesktopPlatform => !kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS);

FlutterAuthClientOptions _buildAuthOptions() {
  if (_isDesktopPlatform) {
    return FlutterAuthClientOptions(
      localStorage: FileLocalStorage(storageKey: 'supabase.auth.token', appDirectoryName: 'store_management'),
      pkceAsyncStorage: FileGotrueAsyncStorage(appDirectoryName: 'store_management'),
    );
  }

  return const FlutterAuthClientOptions();
}

Future<_SupabaseConfig> _loadSupabaseConfig() async {
  if (_supabaseUrl.isNotEmpty && _supabaseAnonKey.isNotEmpty) {
    return const _SupabaseConfig(url: _supabaseUrl, anonKey: _supabaseAnonKey);
  }

  const envUrl = String.fromEnvironment('SUPABASE_URL', defaultValue: '');
  const envAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');
  if (envUrl.isNotEmpty && envAnonKey.isNotEmpty) {
    return const _SupabaseConfig(url: envUrl, anonKey: envAnonKey);
  }

  if (_isDesktopPlatform) {
    final fileConfig = await _loadSupabaseConfigFromFile();
    if (fileConfig != null) {
      return fileConfig;
    }
  }

  throw StateError('Missing Supabase config. Use --dart-define-from-file=.env.local.json. The .env.local.json file fallback only works on desktop platforms.');
}

Future<_SupabaseConfig?> _loadSupabaseConfigFromFile() async {
  final file = File('.env.local.json');
  if (!await file.exists()) {
    return null;
  }

  return _parseSupabaseConfig(await file.readAsString());
}

_SupabaseConfig? _parseSupabaseConfig(String contents) {
  final jsonMap = json.decode(contents) as Map<String, dynamic>;
  final fileUrl = (jsonMap['SUPABASE_URL'] as String?)?.trim() ?? '';
  final fileAnonKey = (jsonMap['SUPABASE_ANON_KEY'] as String?)?.trim() ?? '';

  if (fileUrl.isEmpty || fileAnonKey.isEmpty) {
    return null;
  }

  return _SupabaseConfig(url: fileUrl, anonKey: fileAnonKey);
}

class _SupabaseConfig {
  const _SupabaseConfig({required this.url, required this.anonKey});

  final String url;
  final String anonKey;
}

class MyApp extends StatelessWidget {
  MyApp({super.key, this.authRepository, this.localDatabase, this.startupError, this.startupStackTrace, LocaleController? localeController, AppPreferencesController? appPreferencesController})
    : localeController = localeController ?? LocaleController(),
      appPreferencesController = appPreferencesController ?? AppPreferencesController();

  final AuthRepository? authRepository;
  final LocalDatabase? localDatabase;
  final Object? startupError;
  final StackTrace? startupStackTrace;
  final LocaleController localeController;
  final AppPreferencesController appPreferencesController;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<LocalDatabase?>.value(
      value: localDatabase,
      child: BlocProvider(
        create: (_) => AuthController(authRepository: authRepository ?? SupabaseAuthRepository(), appPreferencesController: appPreferencesController),
        child: AnimatedBuilder(
          animation: Listenable.merge([localeController, appPreferencesController]),
          builder: (context, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              locale: localeController.locale,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: const [AppLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
              localeResolutionCallback: (locale, supportedLocales) {
                if (locale == null) {
                  return supportedLocales.first;
                }

                for (final supportedLocale in supportedLocales) {
                  if (supportedLocale.languageCode == locale.languageCode) {
                    return supportedLocale;
                  }
                }

                return supportedLocales.first;
              },
              onGenerateTitle: (context) => context.l10n.appTitle,
              themeMode: appPreferencesController.themeMode,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1F7A8C), brightness: Brightness.light),
                scaffoldBackgroundColor: const Color(0xFFF4F7FB),
                useMaterial3: true,
              ),
              darkTheme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF39A6BC), brightness: Brightness.dark),
                scaffoldBackgroundColor: const Color(0xFF09141A),
                useMaterial3: true,
              ),
              home: startupError == null ? AuthGate(localeController: localeController, appPreferencesController: appPreferencesController) : StartupErrorView(error: startupError!, stackTrace: startupStackTrace),
            );
          },
        ),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key, required this.localeController, required this.appPreferencesController});

  final LocaleController localeController;
  final AppPreferencesController appPreferencesController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthController, AuthState>(
      builder: (context, state) {
        if (state.isAuthenticated) {
          return Index(localeController: localeController, appPreferencesController: appPreferencesController);
        }

        return AuthView(localeController: localeController, appPreferencesController: appPreferencesController);
      },
    );
  }
}

class StartupErrorView extends StatelessWidget {
  const StartupErrorView({super.key, required this.error, this.stackTrace});

  final Object error;
  final StackTrace? stackTrace;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Startup configuration error', style: theme.textTheme.headlineSmall),
                    const SizedBox(height: 12),
                    Text(error.toString(), style: theme.textTheme.bodyLarge),
                    const SizedBox(height: 16),
                    Text(_startupRecoverySteps(), style: theme.textTheme.bodyMedium),
                    if (kDebugMode && stackTrace != null) ...[
                      const SizedBox(height: 16),
                      Text('Stack trace', style: theme.textTheme.titleMedium),
                      const SizedBox(height: 8),
                      SelectableText(stackTrace.toString(), style: theme.textTheme.bodySmall?.copyWith(fontFamily: 'monospace')),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _startupRecoverySteps() {
    final buffer = StringBuffer()
      ..writeln('Provide SUPABASE_URL and SUPABASE_ANON_KEY at launch time.')
      ..writeln()
      ..writeln('Recommended:')
      ..writeln('flutter run --dart-define-from-file=.env.local.json')
      ..writeln();

    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      buffer
        ..writeln('On mobile, the app cannot read .env.local.json directly from the project root at runtime.')
        ..writeln('Use the VS Code launch profile "store_management (env)" or pass --dart-define/--dart-define-from-file manually.');
    } else if (!kIsWeb && (Platform.isLinux || Platform.isMacOS || Platform.isWindows)) {
      buffer.writeln('On desktop, keeping .env.local.json in the project root also works as a runtime fallback.');
    }

    return buffer.toString().trimRight();
  }
}
