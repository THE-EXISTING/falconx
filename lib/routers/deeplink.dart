import 'dart:collection';
import 'package:falconx/lib.dart';
import 'package:flutter/foundation.dart';

class Deeplink {
  Deeplink();

  StreamSubscription? _deepLinkSubscription;
  Function(Uri uri)? _onDeeplinkUri;
  final Queue<Uri> _uriList = Queue<Uri>.from([]);
  bool _finished = false;

  Future<void> init(
    State state, {
    required void Function(Uri uri) onDeeplinkUri,
  }) async {
    _onDeeplinkUri = onDeeplinkUri;
    await _handleInitialUri();
    _handleIncomingLinks();
    WidgetsBinding.instance.addPostFrameCallback(_onFinishBuildWidget);
  }

  void _onFinishBuildWidget(Duration timestamp) {
    _finished = true;
    while (_uriList.isNotEmpty) {
      _onDeeplinkUri?.call(_uriList.removeFirst());
    }
  }

  void close() {
    _finished = false;
    _uriList.clear();
    _deepLinkSubscription?.cancel();
  }

  void _handleIncomingLinks() {
    if (!kIsWeb) {
      _deepLinkSubscription = uriLinkStream.listen((Uri? uri) {
        if (uri != null) {
          _uriList.add(uri);

          if (_finished) {
            _onDeeplinkUri?.call(_uriList.removeFirst());
          }
        } else {
          Log.w('Null URI');
        }
      }, onError: (err, stacktrace) {
        Log.error(err, stacktrace);
      });
    }
  }

  Future<void> _handleInitialUri() async {
    try {
      final uri = await getInitialUri();
      if (uri == null) {
        Log.i('no initial uri');
      } else {
        _uriList.add(uri);
        if (_finished) {
          _onDeeplinkUri?.call(_uriList.removeFirst());
        }
      }
    } on PlatformException {
      // Platform messages may fail but we ignore the exception
    } on FormatException catch (err, stacktrace) {
      Log.error(err, stacktrace);
    }
  }
}
