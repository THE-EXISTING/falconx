import 'package:falconx/falconx.dart';

enum NavigationEvent { pop }

class WidgetEventCubit extends Cubit<BlocEvent?> {
  WidgetEventCubit() : super(null);

  BlocEvent? get data => state;

  void emitPopScreen<T>([T? result]) {
    emit(BlocEvent(NavigationEvent.pop, data: result));
  }

}
