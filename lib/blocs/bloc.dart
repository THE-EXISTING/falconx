import 'package:falconx/lib.dart';

extension EmitterEvent<STATE extends WidgetStateEvent<DATA>, DATA>
    on Emitter<STATE> {}

extension EmitterExtensions<T> on Emitter<WidgetStateEvent<T>> {
  void emit(WidgetStateEvent<T> state) => call(state);

  void emitInitial(T data) =>
      call(WidgetStateEvent(FullWidgetState.initial, data: data));

  void emitLoading(T data) =>
      call(WidgetStateEvent(FullWidgetState.loading, data: data));

  void emitFail(T data) =>
      call(WidgetStateEvent(FullWidgetState.fail, data: data));

  void emitWarning(T data) =>
      call(WidgetStateEvent(FullWidgetState.warning, data: data));

  void emitSuccess(T data) =>
      call(WidgetStateEvent(FullWidgetState.success, data: data));

  @Deprecated('Please use emitter.emit(state.addEvent(...)')
  void emitEvent(
    WidgetStateEvent<T> currentState,
    Object event, [
    Object? data,
  ]) =>
      call(currentState.addEvent(event, data));

  Future<void> callStream<A>({
    required Stream<WidgetStateEvent<A?>> call,
    required Function(
      Emitter<WidgetStateEvent<T>> emitter,
      WidgetStateEvent<A?> state,
    ) onData,
    Function(
      Emitter<WidgetStateEvent<T>> emitter,
      Failure failure,
    )? onFailure,
  }) =>
      onEach(
        call,
        onData: (WidgetStateEvent<A?> state) {
          onData(this, state);
        },
        onError: (error, stackTrace) {
          if (error is Failure) {
            onFailure?.call(this, error);
          } else {
            Log.error(error, stackTrace);
            FlutterError.reportError(FlutterErrorDetails(
              exception: error,
              stack: stackTrace,
            ));
          }
        },
      );
}

abstract class FalconWidgetStateEventSafeBloc<EVENT, DATA>
    extends FalconBloc<EVENT, WidgetStateEvent<DATA>> {
  FalconWidgetStateEventSafeBloc(DATA data)
      : super(WidgetStateEvent(FullWidgetState.initial, data: data));

  DATA get data => state.data;
}

abstract class FalconWidgetStateEventBloc<EVENT, DATA>
    extends FalconBloc<EVENT, WidgetStateEvent<DATA?>> {
  FalconWidgetStateEventBloc([DATA? data])
      : super(WidgetStateEvent(FullWidgetState.initial, data: data));

  DATA? get data => state.data;
}

abstract class FalconBloc<EVENT, STATE> extends Bloc<BlocEvent<EVENT>, STATE> {
  FalconBloc(super.initialState) : _fetcher = EitherStreamFetcherList() {
    on<BlocEvent<EVENT>>(
        (BlocEvent<EVENT> event, Emitter<STATE> emitter) async {
      await onListenEvent(event, emitter);
    });
  }

  final EitherStreamFetcherList _fetcher;

  FutureOr<void> onListenEvent(BlocEvent<EVENT> event, Emitter<STATE> emitter);

  Stream<WidgetStateEvent<T?>> fetchEitherStream<T>({
    required Object key,
    required Stream<Either<Failure, T>> call,
    bool debounceFetch = true,
  }) =>
      _fetcher.fetchStream(
        key: key,
        call: call,
        debounceFetch: debounceFetch,
      );

  Stream<WidgetStateEvent<T?>> fetchEitherFuture<T>({
    required Object key,
    required Future<Either<Failure, T>> call,
    bool debounceFetch = true,
  }) =>
      _fetcher.fetchFuture(
        key: key,
        call: call,
        debounceFetch: debounceFetch,
      );

  @override
  Future<void> close() {
    _fetcher.close();
    return super.close();
  }

  void addEvent<T>(EVENT event, {T? data}) {
    add(BlocEvent(event, data: data));
  }
}
