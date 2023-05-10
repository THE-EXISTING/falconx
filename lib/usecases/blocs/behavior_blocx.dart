import 'package:falconx/falconx.dart';

abstract class BehaviorBlocX<E, Event extends BlocEvent<E>, State>
    extends BlocX<State> {
  BehaviorBlocX(State initialState)
      : _state = initialState,
        super(initialState) {
    on<Event>((event, emitter) async {
      await onListenEvent(event);
    });
  }

  State _state;
  final _subject = BehaviorSubject<State>();

  @override
  Stream<State> get stream => _subject.stream;

  @override
  State get state => _state;

  Future<void> onListenEvent(BlocEvent<E> event);

  void addInitEvent<T>(E event, {T? data}) {
    add(InitEvent(event, data: data) as Event);
  }

  void addAppEvent<T>(E event, {T? data}) {
    add(ObjectEvent(event, data: data) as Event);
  }

  void addClickEvent<T>(E event, {T? data}) {
    add(ClickEvent(event, data: data) as Event);
  }

  void addTypingEvent<T>(E event, {required T data}) {
    add(TypingEvent(event, data: data) as Event);
  }

  void setStateWithoutEmit<T>(T newValue) {
    _state = newValue as State;
  }

  void emitCurrentState() {
    if (_subject.isClosed) return;
    _subject.add(_state);
  }

  @override
  void emitState(State newState) {
    if (_subject.isClosed) return;
    _subject.add(newState);
    setStateWithoutEmit(newState);
  }

  @override
  void emitSuccessState<T>(T newValue) {
    if (_subject.isClosed) return;
    final newState = BlocState.success(data: newValue) as State;
    _subject.add(newState);
    setStateWithoutEmit(newState);
  }
}
