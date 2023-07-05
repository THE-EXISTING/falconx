import 'package:falconx/lib.dart';

class Five<A, B, C, D, E> with EquatableMixin {
  const Five({
    required this.first,
    required this.second,
    required this.third,
    required this.fourth,
    required this.fifth,
  });

  final A first;
  final B second;
  final C third;
  final D fourth;
  final E fifth;

  @override
  List<Object?> get props => [first, second, third, fourth, fifth];

  @override
  bool? get stringify => true;
}
