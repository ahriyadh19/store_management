import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:store_management/services/local_database.dart';

enum ConnectionIndicatorState { processing, active, failed }

class ConnectionStatusController extends ChangeNotifier {
  ConnectionStatusController({required LocalDatabase? localDatabase, SupabaseClient? supabaseClient, Duration pollInterval = const Duration(seconds: 8)})
    : _localDatabase = localDatabase,
      _supabaseClient = supabaseClient ?? Supabase.instance.client,
      _pollInterval = pollInterval;

  final LocalDatabase? _localDatabase;
  final SupabaseClient _supabaseClient;
  final Duration _pollInterval;

  Timer? _timer;
  bool _started = false;
  bool _isChecking = false;

  ConnectionIndicatorState _supabaseState = ConnectionIndicatorState.processing;
  ConnectionIndicatorState _objectBoxState = ConnectionIndicatorState.processing;

  ConnectionIndicatorState get supabaseState => _supabaseState;
  ConnectionIndicatorState get objectBoxState => _objectBoxState;

  void start() {
    if (_started) {
      return;
    }

    _started = true;
    _setStates(supabase: ConnectionIndicatorState.processing, objectBox: ConnectionIndicatorState.processing);
    unawaited(_runChecks());
    _timer = Timer.periodic(_pollInterval, (_) {
      unawaited(_runChecks());
    });
  }

  Future<void> refresh() => _runChecks(showProcessing: true);

  Future<void> _runChecks({bool showProcessing = false}) async {
    if (_isChecking) {
      return;
    }

    _isChecking = true;

    if (showProcessing) {
      _setStates(supabase: ConnectionIndicatorState.processing, objectBox: ConnectionIndicatorState.processing);
    }

    final results = await Future.wait<ConnectionIndicatorState>([
      _checkSupabaseConnection(),
      _checkObjectBoxConnection(),
    ]);

    _setStates(supabase: results[0], objectBox: results[1]);
    _isChecking = false;
  }

  Future<ConnectionIndicatorState> _checkSupabaseConnection() async {
    try {
      await _supabaseClient.from('users').select('id').limit(1).maybeSingle();
      return ConnectionIndicatorState.active;
    } on PostgrestException catch (error) {
      if (_looksLikeConnectivityFailure(error.message)) {
        return ConnectionIndicatorState.failed;
      }

      return ConnectionIndicatorState.active;
    } on TimeoutException {
      return ConnectionIndicatorState.failed;
    } catch (error) {
      if (_looksLikeConnectivityFailure(error.toString())) {
        return ConnectionIndicatorState.failed;
      }

      return ConnectionIndicatorState.failed;
    }
  }

  Future<ConnectionIndicatorState> _checkObjectBoxConnection() async {
    final database = _localDatabase;
    if (database == null || !database.isAvailable) {
      return ConnectionIndicatorState.failed;
    }

    try {
      database.getRecordsForType(LocalDatabase.branchModelType);
      return ConnectionIndicatorState.active;
    } catch (_) {
      return ConnectionIndicatorState.failed;
    }
  }

  bool _looksLikeConnectivityFailure(String message) {
    final normalized = message.toLowerCase();
    return normalized.contains('socketexception') ||
        normalized.contains('failed host lookup') ||
        normalized.contains('connection refused') ||
        normalized.contains('network') ||
        normalized.contains('timed out') ||
        normalized.contains('timeout') ||
        normalized.contains('dns');
  }

  void _setStates({required ConnectionIndicatorState supabase, required ConnectionIndicatorState objectBox}) {
    final didChange = _supabaseState != supabase || _objectBoxState != objectBox;
    _supabaseState = supabase;
    _objectBoxState = objectBox;

    if (didChange) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}