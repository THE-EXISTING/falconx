import 'package:falconx/falconx.dart';

class ObjectEvent<E> extends BlocEvent<E> {

  const ObjectEvent(E name,{
    super.data,
  }) : super(name);
}
