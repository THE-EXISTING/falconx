import 'package:falconx/lib.dart';

class ObjectEvent<E> extends BlocEvent<E> {

  const ObjectEvent(E name,{
    super.data,
  }) : super(name);
}
