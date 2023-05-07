import 'package:falconx/falconx.dart';

abstract class BlocX<State> extends Bloc<Object, State> {
  BlocX(State initialState)
      : _fetcher = FetcherList(),
        super(initialState);

  final FetcherList _fetcher;
  final screenEventCubit = ScreenEventCubit();
  final StreamController<State> _controller =
      StreamController<State>.broadcast();

  @override
  Stream<State> get stream => _controller.stream;

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
    screenEventCubit.close();
    return super.close();
  }


  void emitState(State newValue) => _controller.add(newValue);

  void emitSuccessState<T>(T newValue) =>
      _controller.add(BlocState.success(data: newValue) as State);

  void emitPopScreen<T>([T? result]) {
    screenEventCubit.emitPopScreen(result);
  }

  void emitEvent<T>(T event, {Object? data}) {
    screenEventCubit.emit(BlocEvent<T>(event, data: data));
  }
}
