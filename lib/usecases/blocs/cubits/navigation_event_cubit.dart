import 'package:falconx/falconx.dart';

enum NavigationEvent { pop }

class NavigationEventCubit extends Cubit<BlocEvent?> {
  NavigationEventCubit() : super(null);

  BlocEvent? get data => state;

  void emitPopScreen<T>([T? result]) {
    emit(BlocEvent(NavigationEvent.pop, data: result));
  }

}
