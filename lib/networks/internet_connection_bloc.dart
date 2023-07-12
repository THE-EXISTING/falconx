import 'package:falconx/lib.dart';

class InternetConnectionBloc extends BlocBase<ConnectivityResult> {
  InternetConnectionBloc({
    required ConnectivityResult initialResult,
    Connectivity? connectivity,
  })  : _connectivity = connectivity ?? Connectivity(),
        super(initialResult) {
    _subscription = stream.listen(onConnectivityChanged);
  }

  final Connectivity _connectivity;
  late final _stateController =
      StreamController<ConnectivityResult>.broadcast();
  StreamSubscription<ConnectivityResult>? _subscription;

  ConnectivityResult get result => state;

  bool get isConnectedInternet =>
      state == ConnectivityResult.wifi ||
      state == ConnectivityResult.ethernet ||
      state == ConnectivityResult.mobile ||
      state == ConnectivityResult.vpn;

  bool get isNotConnectedInternet => !isConnectedInternet;

  @override
  Stream<ConnectivityResult> get stream => _connectivity.onConnectivityChanged;

  @override
  Future<void> close() async {
    _subscription?.cancel();
    return super.close();
  }

  void onConnectivityChanged(ConnectivityResult result) {
    if (isConnectedInternet) {
      Log.i('Connectivity: $result');
    } else {
      Log.w('Connectivity: $result');
    }
    if (_stateController.isClosed) return;
    emit(result);
  }
}
