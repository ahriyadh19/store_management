import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:store_management/app/bootstrap.dart';
import 'package:store_management/app_theme.dart';
import 'package:store_management/controllers/auth_controller.dart';
import 'package:store_management/index.dart';
import 'package:store_management/localization/app_localizations.dart';
import 'package:store_management/localization/locale_controller.dart';
import 'package:store_management/services/app_preferences_controller.dart';
import 'package:store_management/services/auth_repository.dart';
import 'package:store_management/services/local_database.dart';
import 'package:store_management/services/local_database_management_controller.dart';
import 'package:store_management/views/auth_view.dart';

class MyApp extends StatelessWidget {
  MyApp({
    super.key,
    this.authRepository,
    this.localDatabase,
    this.localDatabaseManagementController,
    this.startupError,
    this.startupStackTrace,
    LocaleController? localeController,
    AppPreferencesController? appPreferencesController,
  }) : localeController = localeController ?? LocaleController(),
       appPreferencesController = appPreferencesController ?? AppPreferencesController();

  final AuthRepository? authRepository;
  final LocalDatabase? localDatabase;
  final LocalDatabaseManagementController? localDatabaseManagementController;
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
            final appLocale = localeController.locale ?? appLocalizationFallbackLocale;

            return MaterialApp(
              debugShowCheckedModeBanner: false,
              locale: localeController.locale,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              builder: (context, child) {
                return LargeScreenGate(child: child ?? const SizedBox.shrink());
              },
              localeResolutionCallback: (locale, supportedLocales) {
                if (locale == null) {
                  return appLocalizationFallbackLocale;
                }

                for (final supportedLocale in supportedLocales) {
                  if (supportedLocale.languageCode == locale.languageCode) {
                    return supportedLocale;
                  }
                }

                return appLocalizationFallbackLocale;
              },
              onGenerateTitle: (context) => context.l10n.appTitle,
              themeMode: appPreferencesController.themeMode,
              theme: buildAppTheme(brightness: Brightness.light, locale: appLocale),
              darkTheme: buildAppTheme(brightness: Brightness.dark, locale: appLocale),
              home: startupError == null
                  ? AuthGate(
                      localeController: localeController,
                      appPreferencesController: appPreferencesController,
                      localDatabaseManagementController: localDatabaseManagementController,
                    )
                  : StartupErrorView(error: startupError!, stackTrace: startupStackTrace),
            );
          },
        ),
      ),
    );
  }
}

class LargeScreenGate extends StatelessWidget {
  const LargeScreenGate({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.sizeOf(context);

    if (_supportsLargeScreenViewport(mediaSize)) {
      return child;
    }

    return const UnsupportedScreenView();
  }

  bool _supportsLargeScreenViewport(Size size) {
    final shortestSide = math.min(size.width, size.height);
    return size.width >= minimumSupportedWidth && size.height >= minimumSupportedHeight && shortestSide >= minimumSupportedHeight;
  }
}

class UnsupportedScreenView extends StatelessWidget {
  const UnsupportedScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

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
                    Text(l10n.largeScreenOnlyTitle, style: theme.textTheme.headlineSmall),
                    const SizedBox(height: 12),
                    Text(l10n.largeScreenOnlyMessage, style: theme.textTheme.bodyLarge),
                    const SizedBox(height: 16),
                    Text(
                      l10n.largeScreenOnlyMinimumSize(minimumSupportedWidth.toInt(), minimumSupportedHeight.toInt()),
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key, required this.localeController, required this.appPreferencesController, this.localDatabaseManagementController});

  final LocaleController localeController;
  final AppPreferencesController appPreferencesController;
  final LocalDatabaseManagementController? localDatabaseManagementController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthController, AuthState>(
      builder: (context, state) {
        if (state.isAuthenticated) {
          return Index(
            localeController: localeController,
            appPreferencesController: appPreferencesController,
            localDatabaseManagementController: localDatabaseManagementController,
          );
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
    final l10n = context.l10n;
    final displayMessage = kDebugMode ? error.toString() : l10n.startupRecoveryProvideKeys;

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
                    Text(l10n.startupConfigurationError, style: theme.textTheme.headlineSmall),
                    const SizedBox(height: 12),
                    Text(displayMessage, style: theme.textTheme.bodyLarge),
                    const SizedBox(height: 16),
                    Text(_startupRecoverySteps(l10n), style: theme.textTheme.bodyMedium),
                    if (kDebugMode && stackTrace != null) ...[
                      const SizedBox(height: 16),
                      Text(l10n.stackTraceLabel, style: theme.textTheme.titleMedium),
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

  String _startupRecoverySteps(AppLocalizations l10n) {
    final buffer = StringBuffer()
      ..writeln(l10n.startupRecoveryProvideKeys)
      ..writeln()
      ..writeln(l10n.recommendedLabel)
      ..writeln('flutter run --dart-define-from-file=.env.local.json')
      ..writeln();

    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      buffer
        ..writeln(l10n.startupRecoveryMobile)
        ..writeln(l10n.startupRecoveryMobileHint);
    } else if (!kIsWeb && (Platform.isLinux || Platform.isMacOS || Platform.isWindows)) {
      buffer.writeln(l10n.startupRecoveryDesktop);
    }

    return buffer.toString().trimRight();
  }
}