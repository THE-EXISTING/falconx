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

  void _assertEmitter() {
    assert(
      _emitter != null,
      '''
emit was called after an event handler completed normally.
This is usually due to an unawaited future in an event handler.
Please make sure to await all asynchronous operations with event handlers
and use emit.isDone after asynchronous operations before calling emit() to
ensure the event handler has not completed.

  **❌BAD**
  on<Event>((event, emit) {
    future.whenComplete(() => emitSuccess(...));
  });

  **✅GOOD**
  on<Event>((event, emit) async {
    await future.whenComplete(() => emitSuccess(...));
  });
''',
    );
  }

  void _emit(WidgetStateEvent<DATA> state) {
    _assertEmitter();
    _emitter?.call(state);
  }

  void emitEvent<T>(Object event, [T? data]) =>
      _emit(state.addEvent(event, data));

  void emitInitial([DATA? data]) => _emit(
      WidgetStateEvent(FullWidgetState.initial, data: data ?? state.data));

  void emitLoading([DATA? data]) => _emit(
      WidgetStateEvent(FullWidgetState.loading, data: data ?? state.data));

  void emitFail([DATA? data]) =>
      _emit(WidgetStateEvent(FullWidgetState.fail, data: data ?? state.data));

  void emitWarning([DATA? data]) => _emit(
      WidgetStateEvent(FullWidgetState.warning, data: data ?? state.data));

  void emitSuccess([DATA? data]) => _emit(
      WidgetStateEvent(FullWidgetState.success, data: data ?? state.data));

  Future<void> callStream<A>({
    required Stream<WidgetStateEvent<A>> call,
    required Function(
      Emitter<WidgetStateEvent<DATA>> emitter,
      WidgetStateEvent<A> state,
    ) onData,
    Function(
      Emitter<WidgetStateEvent<DATA>> emitter,
      Failure failure,
    )? onFailure,
  }) {
    _assertEmitter();
    if (_emitter == null) return Future.value();

    return _emitter!.onEach(
      call,
      onData: (WidgetStateEvent<A> state) {
        onData(_emitter!, state);
      },
      onError: (error, stackTrace) {
        if (error is Failure) {
          onFailure?.call(_emitter!, error);
        } else {
          FlutterError.reportError(FlutterErrorDetails(
            exception: error,
            stack: stackTrace,
          ));
        }
      },
    );
  }
}

abstract class FalconWidgetStateEventBloc<EVENT, DATA>
    extends FalconBloc<EVENT, WidgetStateEvent<DATA?>> {
  FalconWidgetStateEventBloc([DATA? data])
      : super(WidgetStateEvent(FullWidgetState.initial, data: data));

  DATA? get data => state.data;

  void _assertEmitter() {
    assert(
      _emitter != null,
      '''
emit was called after an event handler completed normally.
This is usually due to an unawaited future in an event handler.
Please make sure to await all asynchronous operations with event handlers
and use emit.isDone after asynchronous operations before calling emit() to
ensure the event handler has not completed.

  **❌BAD**
  on<Event>((event, emit) {
    future.whenComplete(() => emitSuccess(...));
  });

  **✅GOOD**
  on<Event>((event, emit) async {
    await future.whenComplete(() => emitSuccess(...));
  });
''',
    );
  }

  void _emit(WidgetStateEvent<DATA?> state) {
    _assertEmitter();
    _emitter?.call(state);
  }

  void emitEvent<T>(Object event, [T? data]) =>
      _emit(state.addEvent(event, data));

  void emitInitial([DATA? data]) => _emit(
      WidgetStateEvent(FullWidgetState.initial, data: data ?? state.data));

  void emitLoading([DATA? data]) => _emit(
      WidgetStateEvent(FullWidgetState.loading, data: data ?? state.data));

  void emitFail([DATA? data]) =>
      _emit(WidgetStateEvent(FullWidgetState.fail, data: data ?? state.data));

  void emitWarning([DATA? data]) => _emit(
      WidgetStateEvent(FullWidgetState.warning, data: data ?? state.data));

  void emitSuccess([DATA? data]) => _emit(
      WidgetStateEvent(FullWidgetState.success, data: data ?? state.data));

  Future<void> callStream<A>({
    required Stream<WidgetStateEvent<A?>> call,
    required Function(
      Emitter<WidgetStateEvent<DATA?>> emitter,
      WidgetStateEvent<A?> state,
    ) onData,
    Function(
      Emitter<WidgetStateEvent<DATA?>> emitter,
      Failure failure,
    )? onFailure,
  }) {
    _assertEmitter();
    if (_emitter == null) return Future.value();

    return _emitter!.onEach(
      call,
      onData: (WidgetStateEvent<A?> state) {
        onData(_emitter!, state);
      },
      onError: (error, stackTrace) {
        if (error is Failure) {
          onFailure?.call(_emitter!, error);
        } else {
          FlutterError.reportError(FlutterErrorDetails(
            exception: error,
            stack: stackTrace,
          ));
        }
      },
    );
  }
}

abstract class FalconBloc<EVENT, STATE> extends Bloc<BlocEvent<EVENT>, STATE> {
  FalconBloc(super.initialState) : _fetcher = EitherStreamFetcherList() {
    on<BlocEvent<EVENT>>(
        (BlocEvent<EVENT> event, Emitter<STATE> emitter) async {
      _emitter = emitter;
      await onListenEvent(event, emitter);
      _emitter = null;
    });
  }

  Emitter<STATE>? _emitter;
  final EitherStreamFetcherList _fetcher;

  Future<void> onListenEvent(BlocEvent<EVENT> event, Emitter<STATE> emitter);

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

  Stream<WidgetStateEvent<T>> fetchEitherStreamSafe<T>({
    required Object key,
    required Stream<Either<Failure, T>> call,
    required T defaultData,
    bool debounceFetch = true,
  }) =>
      fetchEitherStream(
        key: key,
        call: call,
        debounceFetch: debounceFetch,
      ).map(
        (WidgetStateEvent<T?> event) => event.mapData(
          (T? a) => a ?? defaultData,
        ),
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

  Stream<WidgetStateEvent<T>> fetchEitherFutureSafe<T>({
    required Object key,
    required Future<Either<Failure, T>> call,
    required T defaultData,
    bool debounceFetch = true,
  }) =>
      fetchEitherFuture(
        key: key,
        call: call,
        debounceFetch: debounceFetch,
      ).map(
        (WidgetStateEvent<T?> event) => event.mapData(
          (T? a) => a ?? defaultData,
        ),
      );

  @override
  Future<void> close() async {
    await _fetcher.closeAsync();
    return super.close();
  }

  void addEvent<T>(EVENT event, {T? data}) {
    add(BlocEvent(event, data: data));
  }
}
