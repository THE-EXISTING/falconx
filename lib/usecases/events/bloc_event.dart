import 'package:equatable/equatable.dart';

class BlocEvent<Event> {
  final Event name;
  final Object? data;

  const BlocEvent(
    this.name, {
    this.data,
  });

  @override
  String toString() {
    return 'BlocEvent{name: $name, data: $data}';
  }
}
