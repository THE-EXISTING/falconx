import 'package:falconx/lib.dart';

abstract class FalconBloc<EVENT, STATE> extends Bloc<BlocEvent<EVENT>, STATE> {
  FalconBloc(STATE initialState)
      : _futureFetcher = FutureFetcherList(),
        _fetcher = FetcherList(),
        super(initialState) {
    on<BlocEvent<EVENT>>(
        (BlocEvent<EVENT> event, Emitter<STATE> emitter) async {
      await onListenEvent(event, emitter);
    });
  }

  final FetcherList _fetcher;
  final FutureFetcherList _futureFetcher;

  FutureOr<void> onListenEvent(BlocEvent<EVENT> event, Emitter<STATE> emitter);

  void fetch<T>({
    required Object key,
    required Stream<BlocState<T>> call,
    required Function(BlocState<T> blocState) onFetch,
    bool debounceFetch = false,
  }) =>
      _fetcher.fetch(
        key: key,
        call: call,
        onFetch: onFetch,
        debounceFetch: debounceFetch,
      );

  Future<void> fetchFuture<T>({
    required Object key,
    required Future<Either<Object, T>> call,
    required Function(WidgetDataState<T?> data) onFetch,
    Function(Object fail)? onFail,
    bool debounceFetch = true,
  }) =>
      _futureFetcher.fetch(
        key: key,
        call: call,
        onFetch: onFetch,
        onFail: onFail,
        debounceFetch: debounceFetch,
      );

  @override
  Future<void> close() {
    _fetcher.close();
    _futureFetcher.close();
    return super.close();
  }

  void addInitEvent<T>(EVENT event, {T? data}) {
    add(InitEvent(event, data: data));
  }

  void addAppEvent<T>(EVENT event, {T? data}) {
    add(ObjectEvent(event, data: data));
  }

  void addClickEvent<T>(EVENT event, {T? data}) {
    add(ClickEvent(event, data: data));
  }

  void addTypingEvent<T>(EVENT event, {required T data}) {
    add(TypingEvent(event, data: data));
  }
}
