import 'package:falconx/lib.dart';
import 'package:flutter/foundation.dart';

class BuildConfig {
  static bool get debug => !kReleaseMode;

  static bool get release => kReleaseMode;
}
