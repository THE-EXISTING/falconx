import 'package:falconx/falconx.dart';

extension EnumExtension on Enum {
  String toValueString(){
    return EnumToString.convertToString(this);
  }
}
