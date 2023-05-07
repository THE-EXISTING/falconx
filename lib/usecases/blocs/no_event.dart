import 'package:falconx/falconx.dart';

class NoEvent{}

class NoEventBloc extends BlocEvent<NoEvent>{
  NoEventBloc() : super(NoEvent(), data: null);
}
