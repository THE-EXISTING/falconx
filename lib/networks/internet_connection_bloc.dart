import 'package:falconx/falconx.dart';
enum InternetResult {
  connected,
  noInternet,
}

class InternetConnectionBloc extends BlocX<InternetResult> {
  InternetConnectionBloc({Connectivity? connectivity})
      : super(InternetResult.connected) {
    _connectivity = connectivity ?? Connectivity();
    subscription = _connectivity.onConnectivityChanged
        .listen((ConnectivityResult connectivity) {
      final result = _getResult(connectivity);
      emitState(result);
    });
  }

  late final Connectivity _connectivity;
  StreamSubscription<ConnectivityResult>? subscription;

  @override
  Future<void> close() async {
    subscription?.cancel();
    return super.close();
  }

  Future<InternetResult> checkConnectivity() async {
    final ConnectivityResult connectivity =
        await _connectivity.checkConnectivity();
    return _getResult(connectivity);
  }

  InternetResult _getResult(ConnectivityResult connectivity) {
    if (connectivity == ConnectivityResult.wifi ||
        connectivity == ConnectivityResult.ethernet ||
        connectivity == ConnectivityResult.mobile) {
      return InternetResult.connected;
    } else {
      return InternetResult.noInternet;
    }
  }
}
