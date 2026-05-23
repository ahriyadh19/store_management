import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show FlutterAuthClientOptions;
import 'package:store_management/services/supabase_auth_storage.dart';
import 'package:window_manager/window_manager.dart';

const _supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const _supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
const Size desktopWindowSize = Size(1280, 800);
const double minimumSupportedWidth = 720;
const double minimumSupportedHeight = 600;
const Size desktopMinimumWindowSize = Size(minimumSupportedWidth, minimumSupportedHeight);

bool get isDesktopPlatform => !kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS);

Future<void> prepareDesktopWindow() async {
  const options = WindowOptions(
    size: desktopWindowSize,
    minimumSize: desktopMinimumWindowSize,
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
  );

  await windowManager.waitUntilReadyToShow(options, () async {
    await windowManager.show();
    await windowManager.focus();
  });
}

FlutterAuthClientOptions buildAuthOptions() {
  if (isDesktopPlatform) {
    return FlutterAuthClientOptions(
      localStorage: FileLocalStorage(storageKey: 'supabase.auth.token', appDirectoryName: 'store_management'),
      pkceAsyncStorage: FileGotrueAsyncStorage(appDirectoryName: 'store_management'),
    );
  }

  return const FlutterAuthClientOptions();
}

Future<SupabaseConfig> loadSupabaseConfig() async {
  if (_supabaseUrl.isNotEmpty && _supabaseAnonKey.isNotEmpty) {
    return const SupabaseConfig(url: _supabaseUrl, anonKey: _supabaseAnonKey);
  }

  const envUrl = String.fromEnvironment('SUPABASE_URL', defaultValue: '');
  const envAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');
  if (envUrl.isNotEmpty && envAnonKey.isNotEmpty) {
    return const SupabaseConfig(url: envUrl, anonKey: envAnonKey);
  }

  if (isDesktopPlatform) {
    final fileConfig = await _loadSupabaseConfigFromFile();
    if (fileConfig != null) {
      return fileConfig;
    }
  }

  throw StateError('Missing Supabase config. Use --dart-define-from-file=.env.local.json. The .env.local.json file fallback only works on desktop platforms.');
}

Future<SupabaseConfig?> _loadSupabaseConfigFromFile() async {
  final file = File('.env.local.json');
  if (!await file.exists()) {
    return null;
  }

  return _parseSupabaseConfig(await file.readAsString());
}

SupabaseConfig? _parseSupabaseConfig(String contents) {
  final jsonMap = json.decode(contents) as Map<String, dynamic>;
  final fileUrl = (jsonMap['SUPABASE_URL'] as String?)?.trim() ?? '';
  final fileAnonKey = (jsonMap['SUPABASE_ANON_KEY'] as String?)?.trim() ?? '';

  if (fileUrl.isEmpty || fileAnonKey.isEmpty) {
    return null;
  }

  return SupabaseConfig(url: fileUrl, anonKey: fileAnonKey);
}

class SupabaseConfig {
  const SupabaseConfig({required this.url, required this.anonKey});

  final String url;
  final String anonKey;
}