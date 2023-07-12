import 'package:falconx/lib.dart';

class InternetConnectionBloc extends BlocBase<ConnectivityResult> {
  InternetConnectionBloc({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity(),
        _connectivityResult = ConnectivityResult.other,
        super(ConnectivityResult.other) {
    _subscription = stream.listen(onConnectivityChanged);
  }

  final Connectivity _connectivity;
  late final _stateController =
      StreamController<ConnectivityResult>.broadcast();
  ConnectivityResult _connectivityResult;
  StreamSubscription<ConnectivityResult>? _subscription;

  ConnectivityResult get connectivityResult => _connectivityResult;

  bool get isConnectedInternet =>
      _connectivityResult == ConnectivityResult.wifi ||
      _connectivityResult == ConnectivityResult.ethernet ||
      _connectivityResult == ConnectivityResult.mobile ||
      _connectivityResult == ConnectivityResult.vpn;

  bool get isNotConnectedInternet => !isConnectedInternet;

  @override
  Stream<ConnectivityResult> get stream => _connectivity.onConnectivityChanged;

  @override
  Future<void> close() async {
    _subscription?.cancel();
    return super.close();
  }

  void onConnectivityChanged(ConnectivityResult result) {
    _connectivityResult = result;
    if (isConnectedInternet) {
      Log.i('Connectivity: $result');
    } else {
      Log.w('Connectivity: $result');
    }
    if (_stateController.isClosed) return;
    emit(result);
  }
}
