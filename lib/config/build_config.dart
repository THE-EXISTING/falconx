import 'package:falconx/falconx.dart';
import 'package:flutter/foundation.dart';

enum BuildMode { debug, release }

class BuildConfig {
  static bool get debug => !kReleaseMode;

  static bool get release => kReleaseMode;

  static BuildMode get mode {
    if (BuildConfig.debug) {
      return BuildMode.debug;
    } else {
      return BuildMode.release;
    }
  }
}
