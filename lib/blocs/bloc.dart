import 'package:falconx/lib.dart';

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

  Future<void> fetch<T>({
    required Object key,
    required Stream<Either<Failure, T>> call,
    required Function(WidgetState<T?> data) onFetch,
    Function(Failure failure)? onFail,
    bool debounceFetch = false,
  }) =>
      _fetcher.fetchStream(
        key: key,
        call: call,
        onFetch: onFetch,
        onFail: onFail,
        debounceFetch: debounceFetch,
      );

  Future<void> fetchFuture<T>({
    required Object key,
    required Future<Either<Failure, T>> call,
    required Function(WidgetState<T?> data) onFetch,
    Function(Failure failure)? onFail,
    bool debounceFetch = true,
  }) =>
      _fetcher.fetchFuture(
        key: key,
        call: call,
        onFetch: onFetch,
        onFail: onFail,
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
