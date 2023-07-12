import 'package:falconx/lib.dart';

class InternetConnectionBloc extends BlocBase<ConnectivityResult> {
  InternetConnectionBloc({Connectivity? connectivity})
      : super(ConnectivityResult.other) {
    _subscription = stream.listen(onConnectivityChanged);
    _connectivityResult = ConnectivityResult.other;
  }

  late final _stateController =
      StreamController<ConnectivityResult>.broadcast();
  late ConnectivityResult _connectivityResult;
  StreamSubscription<ConnectivityResult>? _subscription;

  ConnectivityResult get connectivityResult => _connectivityResult;

  bool get isConnectedInternet =>
      _connectivityResult == ConnectivityResult.wifi ||
      _connectivityResult == ConnectivityResult.ethernet ||
      _connectivityResult == ConnectivityResult.mobile ||
      _connectivityResult == ConnectivityResult.vpn;

  bool get isNotConnectedInternet => !isConnectedInternet;

  @override
  Stream<ConnectivityResult> get stream => _stateController.stream;

  @override
  Future<void> close() async {
    _subscription?.cancel();
    return super.close();
  }

  void onConnectivityChanged(ConnectivityResult result) {
    Log.i('Connectivity: $result');
    _connectivityResult = result;
    if (_stateController.isClosed) return;
    emit(result);
  }
}
