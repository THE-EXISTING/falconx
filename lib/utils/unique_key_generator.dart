import 'package:uuid/uuid.dart';

class UniqueKeyX{
  static const Uuid _uuid = Uuid();

  static String generateUuid() => _uuid.v4();
}