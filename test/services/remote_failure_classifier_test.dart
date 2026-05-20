import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:store_management/services/remote_failure_classifier.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  test('treats timeout failures as connectivity failures', () {
    expect(isRemoteConnectivityFailure(TimeoutException('request timed out')), isTrue);
  });

  test('treats network-flavored Postgrest failures as connectivity failures', () {
    final error = PostgrestException(message: 'ClientException: Failed host lookup: db.supabase.co', code: '57014');

    expect(isRemoteConnectivityFailure(error), isTrue);
  });

  test('does not treat backend validation failures as connectivity failures', () {
    final error = PostgrestException(message: 'new row violates row-level security policy', code: '42501');

    expect(isRemoteConnectivityFailure(error), isFalse);
  });
}