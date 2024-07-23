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
      printTime: false),
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
      _log.t('$tag => Lifecycle State: INIT_STATE');
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
      _log.t('$tag => Lifecycle State: RESTORE_STATE\n'
          'Old bucket: $oldBucket\n'
          'Initial restore: $initialRestore');
    }
  }

  @override
  void dispose() {
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
    switch (state) {
      case AppLifecycleState.resumed:
        if (debug && !kReleaseMode) {
          _log.t('$tag => Lifecycle State: RESUMED');
        }
        resumed();
        break;
      case AppLifecycleState.inactive:
        if (debug && !kReleaseMode) {
          _log.t('$tag => Lifecycle State: INACTIVE');
        }
        inactive();
        break;
      case AppLifecycleState.paused:
        if (debug && !kReleaseMode) {
          _log.t('$tag => Lifecycle State: PAUSED');
        }
        paused();
        break;
      case AppLifecycleState.detached:
        if (debug && !kReleaseMode) {
          _log.t('$tag => Lifecycle State: DETACHED');
        }
        detached();
        break;
      case AppLifecycleState.hidden:
        if (debug && !kReleaseMode) {
          _log.t('$tag => Lifecycle State: HIDDEN');
        }
        hidden();
        break;
    }
    super.didChangeAppLifecycleState(state);
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

  void setWidgetState(FullWidgetState state) {
    if (mounted) {
      stateNotifier.value = state;
    }
  }

  void setFullWidgetState(FullWidgetState state) {
    if (mounted) {
      stateNotifier.value = state;
    }
  }
}
