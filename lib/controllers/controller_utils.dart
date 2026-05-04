import 'package:flutter/foundation.dart';
import 'package:store_management/services/response.dart';

class ControllerUtils {
  static Response errorResponse(Object error) {
    final message = kDebugMode ? error.toString() : 'An unexpected error occurred. Please try again.';
    return Response(statusCode: 500, title: 'Internal Server Error', message: message);
  }

  static Response notFound(String entityName) {
    return Response(statusCode: 404, title: 'Not Found', message: '$entityName was not found');
  }

  static T hydrateModelFromRequest<T extends Object>({required Map<String, dynamic> data, required T Function(Map<String, dynamic> map) fromMap, T? existingModel, Map<String, dynamic> Function(T model)? toMap}) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final existingData = existingModel == null || toMap == null ? const <String, dynamic>{} : toMap(existingModel);

    return fromMap({
      ...existingData,
      ...data,
      ..._pendingUpsertFields(data: data, existingData: existingData, now: now),
      'id': data['id'] ?? existingData['id'] ?? 0,
      'uuid': data['uuid'] ?? existingData['uuid'],
      'createdAt': existingData['createdAt'] ?? data['createdAt'] ?? now,
      'updatedAt': data['updatedAt'] ?? now,
    });
  }

  static T softDeleteModel<T extends Object>({required T model, required Map<String, dynamic> Function(T model) toMap, required T Function(Map<String, dynamic> map) fromMap}) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final existingData = toMap(model);

    return fromMap({
      ...existingData,
      'updatedAt': now,
      'synced': false,
      'syncedAt': null,
      'deletedAt': now,
    });
  }

  static T markModelAsSynced<T extends Object>({required T model, required Map<String, dynamic> Function(T model) toMap, required T Function(Map<String, dynamic> map) fromMap}) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final existingData = toMap(model);

    return fromMap({
      ...existingData,
      'updatedAt': existingData['updatedAt'] ?? now,
      'synced': true,
      'syncedAt': now,
      'deletedAt': existingData['deletedAt'],
    });
  }

  static bool isSoftDeletedMap(Map<String, dynamic>? data) {
    if (data == null) {
      return false;
    }

    return data['deletedAt'] != null || data['deleted_at'] != null;
  }

  static Map<String, dynamic> _pendingUpsertFields({required Map<String, dynamic> data, required Map<String, dynamic> existingData, required int now}) {
    final explicitSynced = data['synced'];
    final explicitSyncedAt = data.containsKey('syncedAt') ? data['syncedAt'] : data['synced_at'];

    if (explicitSynced == true) {
      return <String, dynamic>{
        'synced': true,
        'syncedAt': explicitSyncedAt ?? existingData['syncedAt'] ?? now,
        'deletedAt': data['deletedAt'] ?? data['deleted_at'],
      };
    }

    return <String, dynamic>{
      'synced': false,
      'syncedAt': null,
      'deletedAt': data['deletedAt'] ?? data['deleted_at'],
    };
  }
}