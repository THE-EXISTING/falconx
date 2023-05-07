import 'package:falconx/falconx.dart';

class ClickEvent<Event, T> extends BlocEvent<Event> {
  const ClickEvent(
    Event name, {
    T? data,
  }) : super(name, data: data);
}
