import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException;

bool isRemoteConnectivityFailure(Object error) {
  if (error is TimeoutException) {
    return true;
  }

  if (error is PostgrestException) {
    return _looksLikeConnectivityFailure(error.message);
  }

  return _looksLikeConnectivityFailure(error.toString());
}

bool _looksLikeConnectivityFailure(String message) {
  final normalized = message.toLowerCase();
  return normalized.contains('socketexception') ||
      normalized.contains('failed host lookup') ||
      normalized.contains('connection refused') ||
      normalized.contains('network') ||
      normalized.contains('timed out') ||
      normalized.contains('timeout') ||
      normalized.contains('dns') ||
      normalized.contains('clientexception') ||
      normalized.contains('xmlhttprequest error') ||
      normalized.contains('connection closed before full header was received');
}