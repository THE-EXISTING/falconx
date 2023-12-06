import 'package:falconx/lib.dart';

extension EmitterExtensions<T> on Emitter<WidgetState<T>> {
  Future<void> fetch<A>({
    required Stream<WidgetState<A?>> call,
    required Function(
      Emitter<WidgetState<T>> emitter,
      WidgetState<A?> data,
    ) onFetch,
    Function(
      Emitter<WidgetState<T>> emitter,
      Failure failure,
    )? onFail,
  }) =>
      onEach(
        call,
        onData: (WidgetState<A?> data) {
          onFetch(this, data);

          // Avoid onEach stuck
          if (data.isSuccess) {
            return;
          }
        },
        onError: (error, stackTrace) {
          if (error is Failure) {
            onFail?.call(this, error);
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
  FalconBloc(STATE initialState)
      : _fetcher = FetcherList(),
        super(initialState) {
    on<BlocEvent<EVENT>>(
        (BlocEvent<EVENT> event, Emitter<STATE> emitter) async {
      await onListenEvent(event, emitter);
    });
  }

  final FetcherList _fetcher;

  FutureOr<void> onListenEvent(BlocEvent<EVENT> event, Emitter<STATE> emitter);

  Stream<WidgetState<T?>> fetch<T>({
    required Object key,
    required Stream<Either<Failure, T>> call,
    bool debounceFetch = false,
  }) =>
      _fetcher.fetchStream(
        key: key,
        call: call,
        debounceFetch: debounceFetch,
      );

  Stream<WidgetState<T?>> fetchFuture<T>({
    required Object key,
    required Future<Either<Failure, T>> call,
    required Function(WidgetState<T?> data) onFetch,
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
