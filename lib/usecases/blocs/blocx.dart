import 'package:falconx/falconx.dart';

extension BlocStateExtension<T> on BlocState<T> {
  void emit(BlocX bloc) {
    bloc.emitState(this);
  }
}

abstract class BlocX<State> extends Bloc<Object, State> {
  BlocX(State initialState)
      : _state = initialState,
        _fetcher = FetcherList(),
        super(initialState);

  State _state;
  final FetcherList _fetcher;
  final navigationEventCubit = NavigationEventCubit();
  final StreamController<State> controller =
      StreamController<State>.broadcast();

  @override
  State get state => _state;

  @override
  Stream<State> get stream => controller.stream;

  void fetch<T extends BlocState>({
    required Object key,
    required Stream<T> call,
    required Function(T blocState) onFetch,
    Function? onError,
    bool newFetch = true,
  }) =>
      _fetcher.fetch(
        key: key,
        call: call,
        onFetch: onFetch,
        newFetch: newFetch,
        onError: onError,
      );

  @override
  Future<void> close() {
    _fetcher.close();
    navigationEventCubit.close();
    return super.close();
  }

  void setStateWithoutEmit<T>(T newValue) {
    _state = newValue as State;
  }

  void emitCurrentState() {
    if (controller.isClosed) return;
    controller.add(_state);
  }

  void emitState(State newValue) {
    if (controller.isClosed) return;
    controller.add(newValue);
  }

  void emitLoadingState<T>([T? newValue]) {
    if (controller.isClosed) return;
    controller.add(BlocState.loading(data: newValue) as State);
  }

  void emitErrorState(Object? error, StackTrace? stacktrace) {
    if (controller.isClosed) return;
    controller.add(
        BlocState.exception(error: error, stackTrace: stacktrace) as State);
  }

  void emitSuccessState<T>(T newValue) {
    if (controller.isClosed) return;
    controller.add(BlocState.success(data: newValue) as State);
  }

  void emitPopScreen<T>([T? result]) {
    navigationEventCubit.emitPopScreen(result);
  }

  void emitEvent<T>(T event, {Object? data}) {
    navigationEventCubit.emit(BlocEvent<T>(event, data: data));
  }
}
