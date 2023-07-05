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

enum LifecycleState { created, initState, restore, resume, build }

abstract class FalconState<T extends StatefulWidget> extends State<T>
    with WidgetsBindingObserver, RestorationMixin {
  bool _isPostedFrame = false;

  @override
  String? get restorationId => widget.key.toString();

  String get tag => '${widget.runtimeType} State';

  Key? get key => widget.key;

  bool get postedFrame => _isPostedFrame;

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
    if (!kReleaseMode) {
      _log.v('$tag => Lifecycle State: INIT_STATE');
    }
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      postFrame(context);
    });
    super.initState();
  }

  /// Call registerForRestoration(property, 'id'); for register restorable data.
  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    if (!kReleaseMode) {
      _log.v('$tag => Lifecycle State: RESTORE_STATE\n'
          'Old bucket: $oldBucket\n'
          'Initial restore: $initialRestore');
    }
  }

  void postFrame(BuildContext context) {
    _isPostedFrame = true;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void resumed() {}

  void inactive() {}

  void paused() {}

  void detached() {}

  @protected
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (!kReleaseMode) {
          _log.v('$tag => Lifecycle State: RESUMED');
        }
        resumed();
        break;
      case AppLifecycleState.inactive:
        if (!kReleaseMode) {
          _log.v('$tag => Lifecycle State: INACTIVE');
        }
        inactive();
        break;
      case AppLifecycleState.paused:
        if (!kReleaseMode) {
          _log.v('$tag => Lifecycle State: PAUSED');
        }
        paused();
        // deactivate();
        break;
      case AppLifecycleState.detached:
        if (!kReleaseMode) {
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
    if (mounted) {
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
    if (context.mounted) {
      return context.go(path, extra: extra);
    }
  }

  void goToScreenNamed(
    String screenName, {
    Map<String, String>? pathParameters,
    Map<String, dynamic>? queryParameters,
    Object? extra,
  }) {
    if (context.mounted) {
      return context.goNamed(
        screenName,
        pathParameters: pathParameters ?? const <String, String>{},
        queryParameters: queryParameters ?? const <String, dynamic>{},
        extra: extra,
      );
    }
  }

  Future<Object?> pushScreenNamed(
    String screenName, {
    Map<String, String>? pathParameters,
    Map<String, dynamic>? queryParameters,
  }) {
    return context.pushNamed(
      screenName,
      pathParameters: pathParameters ?? const <String, String>{},
      queryParameters: queryParameters ?? const <String, dynamic>{},
    );
  }

  void replaceScreen(
    String screenName, {
    Map<String, String>? pathParameters,
    Map<String, dynamic>? queryParameters,
  }) {
    if (context.mounted) {
      return context.replaceNamed(
        screenName,
        pathParameters: pathParameters ?? const <String, String>{},
        queryParameters: queryParameters ?? const <String, dynamic>{},
      );
    }
  }

  void popScreen() {
    if (context.mounted) {
      if (context.canPop()) {
        return context.pop();
      } else {
        SystemNavigator.pop();
      }
    }
  }
}
