class LocalDatabase {
  LocalDatabase._();

  static Future<LocalDatabase> create() async {
    return LocalDatabase._();
  }

  bool get isAvailable => false;

  Future<void> close() async {}
}