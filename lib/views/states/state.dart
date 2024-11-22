import 'package:falconx/lib.dart';
import 'package:flutter/foundation.dart';

/// [Android State]
/// - onCreate
/// - onStart
/// - onResume
/// ----------
/// - onPause
/// - onStop
/// - onDestroy
///
/// [iOS State]
/// - viewDidLoad
/// - viewWillAppear
/// - viewDidAppear
/// ----------
/// - viewWillDisappear
/// - viewDidDisappear
/// - viewDidUnload
///
/// [Flutter State with FalconX]
/// - initState
/// - didChangeDependencies
/// - restoreState
/// - resume (Came to foreground)
/// - build
/// - (didUpdateWidget)
/// ----------
/// - inactive
/// - deactivate
/// - dispose
///
/// - paused (Went to background)
/// - detached
///
/// Read more
/// - https://medium.com/flutter-community/flutter-lifecycle-for-android-and-ios-developers-8f532307e0c7
/// - https://stackoverflow.com/questions/41479255/life-cycle-in-flutter
///
Logger _log = Logger(
  printer: PrettyPrinter(
    methodCount: 1,
    errorMethodCount: 8,
    lineLength: 120,
    colors: true,
    printEmojis: true,
    dateTimeFormat: DateTimeFormat.none,
  ),
);

abstract class FalconState<T extends StatefulWidget> extends State<T>
    with WidgetsBindingObserver, RestorationMixin {
  FalconState({FullWidgetState? state}) : _initState = state;

  final FullWidgetState? _initState;
  late final FullWidgetStateNotifier stateNotifier;

  bool get debug => false;

  FullWidgetState get state => stateNotifier.value;

  String get tag => '${widget.runtimeType} State';

  Key? get key => widget.key;

  @override
  String? get restorationId => widget.key.toString();

  Future<Version> get currentVersion async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final versionStr = packageInfo.version;
    final buildNumber = packageInfo.buildNumber;
    final fullVersion = '$versionStr+$buildNumber';
    Log.i(fullVersion);
    return Version.parse(fullVersion);
  }

  @override
  void initState() {
    super.initState(); // Should call first
    if (debug && !kReleaseMode) {
      _log.t('$tag => Lifecycle State: initState');
    }
    stateNotifier = FullWidgetStateNotifier(_initState);
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        postFrame(context);
      }
    });
  }

  /// Call registerForRestoration(property, 'id'); for register restorable data.
  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    if (debug && !kReleaseMode) {
      _log.t('$tag => Lifecycle State: restoreState\n'
          'Old bucket: $oldBucket\n'
          'Initial restore: $initialRestore');
    }
  }

  @override
  void dispose() {
    if (debug && !kReleaseMode) {
      _log.t('$tag => Lifecycle State: dispose');
    }
    WidgetsBinding.instance.removeObserver(this);
    stateNotifier.dispose();
    super.dispose(); // Should call last
  }

  void postFrame(BuildContext context) {}

  void resumed() {}

  void inactive() {}

  void paused() {}

  void detached() {}

  void hidden() {}

  @protected
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        if (debug && !kReleaseMode) {
          _log.t('$tag => Lifecycle State: resumed');
        }
        resumed();
        break;
      case AppLifecycleState.inactive:
        if (debug && !kReleaseMode) {
          _log.t('$tag => Lifecycle State: inactive');
        }
        inactive();
        break;
      case AppLifecycleState.hidden:
        if (debug && !kReleaseMode) {
          _log.t('$tag => Lifecycle State: hidden');
        }
        hidden();
        break;
      case AppLifecycleState.paused:
        if (debug && !kReleaseMode) {
          _log.t('$tag => Lifecycle State: paused');
        }
        paused();
        break;
      case AppLifecycleState.detached:
        if (debug && !kReleaseMode) {
          _log.t('$tag => Lifecycle State: detached');
        }
        detached();
        break;
    }
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void updateState() => setState(() {});

  void clearFocus() => FocusScope.of(context).unfocus();

  @override
  void registerForRestoration(
      RestorableProperty<Object?> property, String restorationId) {
    super.registerForRestoration(property, restorationId);
    if (debug && !kReleaseMode) {
      _log.t('$tag => Lifecycle State: registerForRestoration');
    }
  }

  void go(
    String path, {
    Object? extra,
  }) {
    if (mounted) {
      context.go(path, extra: extra);
    }
  }

  void goNamed(
    String name, {
    Map<String, String>? pathParameters,
    Map<String, dynamic>? queryParameters,
    Object? extra,
  }) {
    if (mounted) {
      context.goNamed(
        name,
        pathParameters: pathParameters ?? const <String, String>{},
        queryParameters: queryParameters ?? const <String, dynamic>{},
        extra: extra,
      );
    }
  }

  Future<R?> push<R extends Object?>(String location, {Object? extra}) {
    if (mounted) {
      return context.push<R>(location, extra: extra);
    }
    return Future.value(null);
  }

  Future<PopResult<D>?> pushWithPopResult<D extends Object?>(
    String location, {
    Object? extra,
  }) =>
      push(
        location,
        extra: extra,
      );

  Future<R?> pushNamed<R extends Object?>(
    String name, {
    Map<String, String>? pathParameters,
    Map<String, dynamic>? queryParameters,
    Object? extra,
  }) {
    if (mounted) {
      return context.pushNamed<R>(
        name,
        pathParameters: pathParameters ?? const <String, String>{},
        queryParameters: queryParameters ?? const <String, dynamic>{},
        extra: extra,
      );
    }
    return Future.value(null);
  }

  Future<PopResult<D>?> pushNamedWithPopResult<D extends Object?>(
    String name, {
    Map<String, String>? pathParameters,
    Map<String, dynamic>? queryParameters,
    Object? extra,
  }) =>
      pushNamed(
        name,
        pathParameters: pathParameters,
        queryParameters: queryParameters,
        extra: extra,
      );

  void replace(String location, {Object? extra}) {
    if (mounted) {
      context.replace(location, extra: extra);
    }
  }

  void replaceNamed(
    String name, {
    Map<String, String>? pathParameters,
    Map<String, dynamic>? queryParameters,
  }) {
    if (mounted) {
      context.replaceNamed(
        name,
        pathParameters: pathParameters ?? const <String, String>{},
        queryParameters: queryParameters ?? const <String, dynamic>{},
      );
    }
  }

  void pushReplacementNamed(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    if (mounted) {
      context.pushReplacementNamed(
        name,
        extra: extra,
        pathParameters: pathParameters,
        queryParameters: queryParameters,
      );
    }
  }

  void pop<R extends Object?>([R? result]) {
    if (mounted) {
      if (context.canPop()) {
        context.pop<R>(result);
      } else {
        SystemNavigator.pop();
      }
    }
  }

  void popWithResult<D extends Object?>(PopResult<D> result) => pop(result);

  void setFullWidgetState(FullWidgetState state) {
    if (mounted) {
      stateNotifier.value = state;
    }
  }
}
