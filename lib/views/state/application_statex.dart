import 'package:falconx/falconx.dart';
import 'package:flutter/foundation.dart';

abstract class ApplicationStateX<T extends StatefulWidgetX> extends StateX<T> {
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
