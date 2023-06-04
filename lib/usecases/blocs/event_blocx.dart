import 'package:falconx/falconx.dart';

abstract class EventBlocX<Event, State> extends Bloc<Event, State> {
  EventBlocX(State initialState)
      : _state = initialState,
        super(initialState) {
    on<Event>((event, emitter) async {
      await onListenEvent(event);
    });
  }

  final FetcherList _fetcher = FetcherList();
  State _state;
  final _subject = BehaviorSubject<State>();

  Future<void> onListenEvent(Event event);

  @override
  State get state => _state;

  @override
  Stream<State> get stream => _subject.stream;

  void emitState(State newValue) {
    if (_subject.isClosed) return;
    _subject.add(newValue);
    _state = newValue;
  }

  void addInitEvent(Event event) => add(event);

  void addAppEvent(Event event) => add(event);

  void addClickEvent(Event event) => add(event);

  void addTypingEvent(Event event) => add(event);

  void fetch<T>({
    required Object key,
    required Stream<BlocState<T>> call,
    required Function(BlocState<T> resource) onResource,
    Function? onLoading,
  }) =>
      _fetcher.fetch(key: key, call: call, onFetch: onResource);

  @override
  Future<void> close() {
    _subject.close();
    _fetcher.close();
    return super.close();
  }
}
