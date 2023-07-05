import 'package:falconx/lib.dart';
import 'package:flutter/foundation.dart';

abstract class FalconApplicationState<T extends StatefulWidget> extends FalconState<T> {
  final Deeplink deeplink = Deeplink();

  @override
  void initState() {
    super.initState();
    deeplink.init(this, onDeeplinkUri: onDeeplinkUri);
  }

  @override
  void dispose() {
    deeplink.close();
    super.dispose();
  }

  void onDeeplinkUri(Uri uri){}
}
