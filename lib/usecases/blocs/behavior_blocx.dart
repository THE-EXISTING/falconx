import 'package:falconx/falconx.dart';


abstract class BehaviorBlocX<E, Event extends BlocEvent<E>, State>
    extends BlocX<State> {
  BehaviorBlocX(State initialState) : super(initialState) {
    on<Event>((event, emitter) async {
      await onListenEvent(event);
    });
  }

  @override
  StreamController<State> controller = BehaviorSubject<State>();


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

}
