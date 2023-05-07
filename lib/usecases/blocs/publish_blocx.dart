import 'package:falconx/falconx.dart';

abstract class PublishBlocX<T, Event extends BlocEvent<T>, State extends BlocState>
    extends Bloc<Event, State> {
  PublishBlocX(State initialState) : super(initialState) {
    on<Event>((event, emitter) async {
      await onListenEvent(event);
    });
  }

  final _subject = PublishSubject<State>();

  @override
  Stream<State> get stream => _subject.stream;

  Future<void> onListenEvent(BlocEvent<T> event);

  void emitState(State newValue) => _subject.add(newValue);
}
