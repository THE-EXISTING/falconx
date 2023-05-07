import 'package:falconx/falconx.dart';

class TypingEvent<Event, T> extends BlocEvent<Event> {
  const TypingEvent(
    Event name, {
    required super.data,
  }) : super(name);
}
