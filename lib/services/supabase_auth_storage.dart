import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

class FileLocalStorage extends LocalStorage {
  FileLocalStorage({required this.storageKey, required this.appDirectoryName});

  final String storageKey;
  final String appDirectoryName;

  late final File _file;

  @override
  Future<void> initialize() async {
    _file = await _resolveFile('$storageKey.json');
  }

  @override
  Future<bool> hasAccessToken() async {
    if (!await _file.exists()) {
      return false;
    }

    final content = await _file.readAsString();
    return content.trim().isNotEmpty;
  }

  @override
  Future<String?> accessToken() async {
    if (!await _file.exists()) {
      return null;
    }

    final content = await _file.readAsString();
    final trimmed = content.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  @override
  Future<void> removePersistedSession() async {
    if (await _file.exists()) {
      await _file.delete();
    }
  }

  @override
  Future<void> persistSession(String persistSessionString) async {
    await _file.writeAsString(persistSessionString, flush: true);
  }

  Future<File> _resolveFile(String fileName) async {
    final directory = await _resolveAppDirectory();
    await directory.create(recursive: true);
    return File('${directory.path}/$fileName');
  }

  Future<Directory> _resolveAppDirectory() async {
    if (Platform.isLinux) {
      final xdgConfigHome = Platform.environment['XDG_CONFIG_HOME'];
      if (xdgConfigHome != null && xdgConfigHome.isNotEmpty) {
        return Directory('$xdgConfigHome/$appDirectoryName');
      }

      final home = Platform.environment['HOME'];
      if (home != null && home.isNotEmpty) {
        return Directory('$home/.config/$appDirectoryName');
      }
    }

    if (Platform.isMacOS) {
      final home = Platform.environment['HOME'];
      if (home != null && home.isNotEmpty) {
        return Directory('$home/Library/Application Support/$appDirectoryName');
      }
    }

    if (Platform.isWindows) {
      final appData = Platform.environment['APPDATA'];
      if (appData != null && appData.isNotEmpty) {
        return Directory('$appData\\$appDirectoryName');
      }
    }

    return Directory('${Directory.current.path}/.$appDirectoryName');
  }
}

class FileGotrueAsyncStorage extends GotrueAsyncStorage {
  FileGotrueAsyncStorage({required this.appDirectoryName});

  final String appDirectoryName;

  Future<File> _resolveKeyFile(String key) async {
    final safeKey = key.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
    final storage = FileLocalStorage(storageKey: safeKey, appDirectoryName: appDirectoryName);
    await storage.initialize();
    return storage._file;
  }

  @override
  Future<String?> getItem({required String key}) async {
    final file = await _resolveKeyFile(key);
    if (!await file.exists()) {
      return null;
    }

    final value = await file.readAsString();
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  @override
  Future<void> removeItem({required String key}) async {
    final file = await _resolveKeyFile(key);
    if (await file.exists()) {
      await file.delete();
    }
  }

  @override
  Future<void> setItem({required String key, required String value}) async {
    final file = await _resolveKeyFile(key);
    await file.writeAsString(value, flush: true);
  }
}