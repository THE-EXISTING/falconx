import 'package:falconx/lib.dart';

class ClickEvent<Event, T> extends BlocEvent<Event> {
  const ClickEvent(
    Event name, {
    T? data,
  }) : super(name, data: data);
}
