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
import 'package:store_management/services/auth_repository.dart';
import 'package:store_management/services/local_database.dart';
import 'package:store_management/services/supabase_auth_storage.dart';
import 'package:store_management/views/auth_view.dart';

const _supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const _supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final config = await _loadSupabaseConfig();
  final localeController = await LocaleController.create();
  final localDatabase = await LocalDatabase.create();

  await Supabase.initialize(url: config.url, anonKey: config.anonKey, authOptions: _buildAuthOptions());

  runApp(MyApp(localeController: localeController, localDatabase: localDatabase));
}

FlutterAuthClientOptions _buildAuthOptions() {
  if (!kIsWeb && Platform.isLinux) {
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

  if (!kIsWeb) {
    final file = File('.env.local.json');
    if (await file.exists()) {
      final jsonMap = json.decode(await file.readAsString()) as Map<String, dynamic>;
      final fileUrl = (jsonMap['SUPABASE_URL'] as String?)?.trim() ?? '';
      final fileAnonKey = (jsonMap['SUPABASE_ANON_KEY'] as String?)?.trim() ?? '';

      if (fileUrl.isNotEmpty && fileAnonKey.isNotEmpty) {
        return _SupabaseConfig(url: fileUrl, anonKey: fileAnonKey);
      }
    }
  }

  throw StateError('Missing Supabase config. Use --dart-define-from-file=.env.local.json or create .env.local.json in the project root.');
}

class _SupabaseConfig {
  const _SupabaseConfig({required this.url, required this.anonKey});

  final String url;
  final String anonKey;
}

class MyApp extends StatelessWidget {
  MyApp({super.key, this.authRepository, this.localDatabase, LocaleController? localeController}) : localeController = localeController ?? LocaleController();

  final AuthRepository? authRepository;
  final LocalDatabase? localDatabase;
  final LocaleController localeController;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<LocalDatabase?>.value(
      value: localDatabase,
      child: BlocProvider(
        create: (_) => AuthController(authRepository: authRepository ?? SupabaseAuthRepository()),
        child: AnimatedBuilder(
          animation: localeController,
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
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1F7A8C)),
                scaffoldBackgroundColor: const Color(0xFFF4F7FB),
                useMaterial3: true,
              ),
              home: AuthGate(localeController: localeController),
            );
          },
        ),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key, required this.localeController});

  final LocaleController localeController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthController, AuthState>(
      builder: (context, state) {
        if (state.isAuthenticated) {
          return Index(localeController: localeController);
        }

        return AuthView(localeController: localeController);
      },
    );
  }
}
