import 'package:falconx/falconx.dart';
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

enum LifecycleState { created, initState, restore, resume, build }

enum StateEvent { pop }

abstract class StateX<T extends StatefulWidgetX> extends State<T>
    with WidgetsBindingObserver, RestorationMixin, StateXMixin<T> {
  LifecycleState _state = LifecycleState.created;
  bool _isPostedFrame = false;

  @override
  String? get restorationId => widget.key.toString();

  String get tag => '${widget.runtimeType} State';

  bool get isLog => widget.isLog;

  Key? get key => widget.key;

  bool get postedFrame => _isPostedFrame;

  bool _isInitState = true;

  bool get isInitState => _isInitState;

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
    _state = LifecycleState.initState;

    if (!kReleaseMode && isLog) {
      _log.v('$tag => Lifecycle State: INIT_STATE');
    }
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      postFrame();
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isInitState = false;
  }

  /// Call registerForRestoration(property, 'id'); for register restorable data.
  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    _state = LifecycleState.restore;

    if (!kReleaseMode && isLog) {
      _log.v('$tag => Lifecycle State: RESTORE_STATE\n'
          'Old bucket: $oldBucket\n'
          'Initial restore: $initialRestore');
    }

    if (!kReleaseMode && isLog) {
      _log.v('$tag => Lifecycle State: RESUMED');
    }
    resumed();
  }

  @override
  void resumed() {}

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void deactivate() {
    if (!kReleaseMode && isLog) {
      _log.v('$tag => Lifecycle State: INACTIVE');
    }
    inactive();

    if (!kReleaseMode && isLog) {
      _log.v('$tag => Lifecycle State: DEACTIVATE');
    }
    super.deactivate();
  }

  @override
  void postFrame() {
    _isPostedFrame = true;
  }

  /// Don't forget to call YourRestorable.dispose();
  @override
  void dispose() {
    if (!kReleaseMode && isLog) {
      _log.v('$tag => Lifecycle State: DISPOSE');
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void inactive() {}

  /// Went to Background
  @override
  void paused() {}

  @override
  void detached() {}

  @protected
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (!kReleaseMode && isLog) {
          _log.v('$tag => Lifecycle State: RESUMED');
        }
        _state = LifecycleState.restore;
        resumed();
        break;
      case AppLifecycleState.inactive:
        if (!kReleaseMode && isLog) {
          _log.v('$tag => Lifecycle State: INACTIVE');
        }
        inactive();
        break;
      case AppLifecycleState.paused:
        if (!kReleaseMode && isLog) {
          _log.v('$tag => Lifecycle State: PAUSED');
        }
        paused();
        // deactivate();
        break;
      case AppLifecycleState.detached:
        if (!kReleaseMode && isLog) {
          _log.v('$tag => Lifecycle State: DETACHED');
        }
        detached();
        // dispose();
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void setState(VoidCallback fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  void updateState() => setState(() {});

  @override
  void registerForRestoration(
      RestorableProperty<Object?> property, String restorationId) {
    super.registerForRestoration(property, restorationId);
  }

  void goToPath(
    String path, {
    Object? extra,
  }) {
    return context.go(path, extra: extra);
  }

  void goToScreenNamed(
    String screenName, {
    Map<String, String>? params,
    Map<String, dynamic>? queryParams,
    Object? extra,
  }) {
    return context.goNamed(
      screenName,
      params: params ?? const <String, String>{},
      queryParams: queryParams ?? const <String, dynamic>{},
      extra: extra,
    );
  }

  Future<Object?> pushScreenNamed(
    String screenName, {
    Map<String, String>? params,
    Map<String, dynamic>? queryParams,
  }) {
    return context.pushNamed(
      screenName,
      params: params ?? const <String, String>{},
      queryParams: queryParams ?? const <String, dynamic>{},
    );
  }

  void replaceScreen(
    String screenName, {
    Map<String, String>? params,
    Map<String, dynamic>? queryParams,
  }) {
    return context.replaceNamed(
      screenName,
      params: params ?? const <String, String>{},
      queryParams: queryParams ?? const <String, dynamic>{},
    );
  }

  void popScreen() {
    return context.pop();
  }
}
