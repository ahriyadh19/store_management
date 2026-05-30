import 'package:store_management/services/uuid.dart';

abstract class BaseModel {
  List<Object?> get props;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (runtimeType != other.runtimeType || other is! BaseModel) {
      return false;
    }

    return _propsEqual(props, other.props);
  }

  @override
  int get hashCode => Object.hashAll(props.map(_deepHash));

  static bool _propsEqual(List<Object?> left, List<Object?> right) {
    if (left.length != right.length) {
      return false;
    }

    for (var index = 0; index < left.length; index++) {
      if (!_valueEqual(left[index], right[index])) {
        return false;
      }
    }

    return true;
  }

  static bool _valueEqual(Object? left, Object? right) {
    if (identical(left, right)) {
      return true;
    }

    if (left is Map && right is Map) {
      if (left.length != right.length) {
        return false;
      }

      for (final entry in left.entries) {
        if (!right.containsKey(entry.key) ||
            !_valueEqual(entry.value, right[entry.key])) {
          return false;
        }
      }

      return true;
    }

    if (left is Iterable && right is Iterable) {
      final leftIterator = left.iterator;
      final rightIterator = right.iterator;

      while (true) {
        final hasLeft = leftIterator.moveNext();
        final hasRight = rightIterator.moveNext();

        if (hasLeft != hasRight) {
          return false;
        }

        if (!hasLeft) {
          return true;
        }

        if (!_valueEqual(leftIterator.current, rightIterator.current)) {
          return false;
        }
      }
    }

    return left == right;
  }

  static int _deepHash(Object? value) {
    if (value is Map) {
      final entries =
          value.entries
              .map(
                (entry) =>
                    Object.hash(_deepHash(entry.key), _deepHash(entry.value)),
              )
              .toList()
            ..sort();
      return Object.hashAll(entries);
    }

    if (value is Iterable) {
      return Object.hashAll(value.map(_deepHash));
    }

    return value.hashCode;
  }
}

abstract class IdentifiedModel extends BaseModel {
  int id;
  String uuid;

  IdentifiedModel({this.id = 0, String? uuid})
    : uuid = uuid ?? UUIDGenerator.generate();

  Map<String, dynamic> identityMap() {
    return <String, dynamic>{'id': id, 'uuid': uuid};
  }

  List<Object?> get identityProps => <Object?>[id, uuid];
}

abstract class CreatedModel extends IdentifiedModel {
  DateTime createdAt;

  CreatedModel({super.id = 0, super.uuid, required this.createdAt});

  Map<String, dynamic> createdMap() {
    return <String, dynamic>{
      ...identityMap(),
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  List<Object?> get createdProps => <Object?>[...identityProps, createdAt];
}

abstract class TimestampedModel extends CreatedModel {
  DateTime updatedAt;

  TimestampedModel({
    super.id = 0,
    super.uuid,
    required super.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> timestampedMap() {
    return <String, dynamic>{
      ...createdMap(),
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  List<Object?> get timestampedProps => <Object?>[...createdProps, updatedAt];
}

abstract class StatusedModel<T> extends TimestampedModel {
  T status;

  StatusedModel({
    super.id = 0,
    super.uuid,
    required this.status,
    required super.createdAt,
    required super.updatedAt,
  });

  Map<String, dynamic> statusedMap() {
    return <String, dynamic>{...timestampedMap(), 'status': status};
  }

  List<Object?> get statusedProps => <Object?>[...timestampedProps, status];
}

abstract class SyncModel extends IdentifiedModel {
  bool synced;
  DateTime? deletedAt;
  DateTime? syncedAt;

  SyncModel({
    super.id = 0,
    super.uuid,
    this.synced = false,
    this.deletedAt,
    this.syncedAt,
  });

  Map<String, dynamic> syncMap() {
    return <String, dynamic>{
      ...identityMap(),
      'synced': synced,
      'deletedAt': deletedAt?.millisecondsSinceEpoch,
      'syncedAt': syncedAt?.millisecondsSinceEpoch,
    };
  }

  List<Object?> get syncProps => <Object?>[
    ...identityProps,
    synced,
    deletedAt,
    syncedAt,
  ];
}

abstract class TimestampedSyncModel extends SyncModel {
  DateTime createdAt;
  DateTime updatedAt;

  TimestampedSyncModel({
    super.id = 0,
    super.uuid,
    required this.createdAt,
    required this.updatedAt,
    super.synced = false,
    super.deletedAt,
    super.syncedAt,
  });

  Map<String, dynamic> timestampedSyncMap() {
    return <String, dynamic>{
      ...syncMap(),
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  List<Object?> get timestampedSyncProps => <Object?>[
    ...syncProps,
    createdAt,
    updatedAt,
  ];
}

abstract class StatusedSyncModel<T> extends TimestampedSyncModel {
  T status;

  StatusedSyncModel({
    super.id = 0,
    super.uuid,
    required this.status,
    required super.createdAt,
    required super.updatedAt,
    super.synced = false,
    super.deletedAt,
    super.syncedAt,
  });

  Map<String, dynamic> statusedSyncMap() {
    return <String, dynamic>{...timestampedSyncMap(), 'status': status};
  }

  List<Object?> get statusedSyncProps => <Object?>[
    ...timestampedSyncProps,
    status,
  ];
}

abstract class AuditedSyncModel extends StatusedSyncModel<int> {
  AuditedSyncModel({
    super.id = 0,
    super.uuid,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    super.synced = false,
    super.deletedAt,
    super.syncedAt,
  });

  Map<String, dynamic> auditedSyncMap() {
    return statusedSyncMap();
  }

  List<Object?> get auditedSyncProps => <Object?>[...statusedSyncProps];
}
