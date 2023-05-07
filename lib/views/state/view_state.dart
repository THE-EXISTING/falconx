import 'package:falconx/falconx.dart';

enum WidgetDisplayState {
  normal,
  disabled,
  loading,
  empty,
  error,
}

class WidgetShowStateNotifier extends ValueNotifier<WidgetDisplayState> {
  WidgetShowStateNotifier({
    required WidgetDisplayState state,
  }) : super(state);

  @override
  void dispose() {
    super.dispose();
  }
}