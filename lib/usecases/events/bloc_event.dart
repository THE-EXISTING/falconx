import 'package:equatable/equatable.dart';

class BlocEvent<Event> extends Equatable {
  final Event name;
  final Object? data;

  const BlocEvent(
    this.name, {
    this.data,
  });

  @override
  List<Object?> get props => [name, data];

  @override
  bool? get stringify => true;
}
