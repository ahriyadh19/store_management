import 'package:uuid/uuid.dart';

class UUIDGenerator {
  static String generate() => Uuid().v4();
}
