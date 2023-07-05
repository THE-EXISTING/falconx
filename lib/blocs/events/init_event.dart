import 'package:falconx/lib.dart';

class InitEvent<E> extends BlocEvent<E> {

  const InitEvent(
    E name, {
    super.data,
  }) : super(name);
}
