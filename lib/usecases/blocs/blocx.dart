import 'package:falconx/falconx.dart';

extension BlocStateExtension on BlocState {
  void emit<S>(BlocX<S> bloc) {
    bloc.emitState(this as S);
  }
}

abstract class BlocX<State> extends Bloc<Object, State> {
  BlocX(State initialState)
      : _state = initialState,
        _fetcher = FetcherList(),
        super(initialState);

  State _state;
  final FetcherList _fetcher;
  final widgetEventCubit = WidgetEventCubit();
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
    widgetEventCubit.close();
    return super.close();
  }

  void setStateWithoutEmit<T>(T newValue) {
    _state = newValue as State;
  }

  void emitCurrentState() {
    if (controller.isClosed) return;
    controller.add(_state);
    setStateWithoutEmit(_state);
  }

  void emitState(State newValue) {
    if (controller.isClosed) return;
    controller.add(newValue);
    setStateWithoutEmit(newValue);
  }

  void emitLoadingState<T>([T? newValue]) {
    if (controller.isClosed) return;
    final state = BlocState.loading(data: newValue) as State;
    controller.add(state);
    setStateWithoutEmit(state);
  }

  void emitErrorState(Object? error, StackTrace? stacktrace) {
    if (controller.isClosed) return;
    final state =
        BlocState.exception(error: error, stackTrace: stacktrace) as State;
    controller.add(state);
    setStateWithoutEmit(state);
  }

  void emitSuccessState<T>(T newValue) {
    if (controller.isClosed) return;
    final state = BlocState.success(data: newValue) as State;
    controller.add(state);
    setStateWithoutEmit(state);
  }

  void emitPopScreen<T>([T? result]) {
    if(widgetEventCubit.isClosed) return;

    widgetEventCubit.emitPopScreen(result);
  }

  void emitEvent<T>(T event, {Object? data}) {
    if(widgetEventCubit.isClosed) return;

    widgetEventCubit.emit(BlocEvent<T>(event, data: data));
  }
}
