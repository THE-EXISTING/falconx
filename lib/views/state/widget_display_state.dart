import 'package:falconx/falconx.dart';

enum WidgetDisplayState {
  normal,
  disabled,
  loading,
  empty,
  error,
}

class WidgetDisplayStateNotifier extends ValueNotifier<WidgetDisplayState> {
  WidgetDisplayStateNotifier({
    required WidgetDisplayState state,
  }) : super(state);

  @override
  void dispose() {
    super.dispose();
  }
}