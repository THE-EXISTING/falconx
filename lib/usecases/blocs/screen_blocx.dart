import 'package:falconx/falconx.dart';

abstract class ScreenBlocX<E, Event extends BlocEvent<E>, State>
    extends BehaviorBlocX<E, Event, State> {
  ScreenBlocX(State initialState) : super(initialState);
}
