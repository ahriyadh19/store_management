class EntityMapper<T extends Object> {
  const EntityMapper({
    required this.fromDataMap,
    required this.toDataMap,
    this.fromRemoteMap,
    this.toRemoteMap,
    this.fromLocalRow,
    this.toLocalRow,
  });

  final T Function(Map<String, dynamic> map) fromDataMap;
  final Map<String, dynamic> Function(T entity) toDataMap;
  final T Function(Map<String, dynamic> map)? fromRemoteMap;
  final Map<String, dynamic> Function(T entity)? toRemoteMap;
  final T Function(Map<String, dynamic> row)? fromLocalRow;
  final Map<String, dynamic> Function(T entity)? toLocalRow;

  T fromDomainMap(Map<String, dynamic> map) => fromDataMap(map);

  Map<String, dynamic> toDomainMap(T entity) => toDataMap(entity);

  T fromRemotePayload(Map<String, dynamic> map) => (fromRemoteMap ?? fromDataMap)(map);

  Map<String, dynamic> toRemotePayload(T entity) => (toRemoteMap ?? toDataMap)(entity);

  T fromLocalPayload(Map<String, dynamic> row) => (fromLocalRow ?? fromDataMap)(row);

  Map<String, dynamic> toLocalPayload(T entity) => (toLocalRow ?? toDataMap)(entity);
}