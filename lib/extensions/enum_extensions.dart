import 'package:falconx/lib.dart';

extension EnumExtension on Enum {
  String toValueString(){
    return EnumToString.convertToString(this);
  }
}
