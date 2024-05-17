import 'package:falconx/lib.dart';

extension EmitterEvent<STATE extends WidgetEventState<DATA>, DATA> on  Emitter<STATE> {
}

extension EmitterExtensions<T> on Emitter<WidgetEventState<T>> {

  void emit(WidgetEventState<T> state) => call(state);

  void emitEvent(
    WidgetEventState<T> currentState,
    Object event, [
    Object? data,
  ]) =>
      call(currentState.addEvent(event, data));

  Future<void> callStream<A>({
    required Stream<WidgetEventState<A?>> call,
    required Function(
      Emitter<WidgetEventState<T>> emitter,
      WidgetEventState<A?> data,
    ) onData,
    Function(
      Emitter<WidgetEventState<T>> emitter,
      Failure failure,
    )? onFailure,
  }) =>
      onEach(
        call,
        onData: (WidgetEventState<A?> data) {
          onData(this, data);
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

abstract class FalconBloc<EVENT, STATE> extends Bloc<BlocEvent<EVENT>, STATE> {
  FalconBloc(super.initialState) : _fetcher = EitherStreamFetcherList() {
    on<BlocEvent<EVENT>>(
        (BlocEvent<EVENT> event, Emitter<STATE> emitter) async {
      await onListenEvent(event, emitter);
    });
  }

  final EitherStreamFetcherList _fetcher;

  FutureOr<void> onListenEvent(BlocEvent<EVENT> event, Emitter<STATE> emitter);

  Stream<WidgetEventState<T?>> fetchStream<T>({
    required Object key,
    required Stream<Either<Failure, T>> call,
    bool debounceFetch = false,
  }) =>
      _fetcher.fetchStream(
        key: key,
        call: call,
        debounceFetch: debounceFetch,
      );

  Stream<WidgetEventState<T?>> fetchFuture<T>({
    required Object key,
    required Future<Either<Failure, T>> call,
    required Function(WidgetEventState<T?> data) onFetch,
    Function(Failure failure)? onFail,
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
