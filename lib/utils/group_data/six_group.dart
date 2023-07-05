import 'package:falconx/lib.dart';

class Six<A, B, C, D, E, F> with EquatableMixin {
  const Six({
    required this.first,
    required this.second,
    required this.third,
    required this.fourth,
    required this.fifth,
    required this.sixth,
  });

  final A first;
  final B second;
  final C third;
  final D fourth;
  final E fifth;
  final F sixth;

  @override
  List<Object?> get props => [first, second, third, fourth, fifth, sixth];

  @override
  bool? get stringify => true;
}
