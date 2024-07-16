// Created by Nonthawit on 5/7/2023 AD Lead Flutter at NEXTZY and EXISTING
import 'package:falconx/lib.dart';

class FullWidgetStateNotifier extends ValueNotifier<FullWidgetState> {
  FullWidgetStateNotifier([FullWidgetState? state])
      : super(state ?? FullWidgetState.normal);

  bool _isDisposed = false;

  bool get isDisposed => _isDisposed;

  @override
  void dispose() {
    if (!_isDisposed) {
      _isDisposed = true;
      super.dispose();
    }
  }

  @override
  set value(FullWidgetState newValue) {
    if (!_isDisposed) {
      super.value = newValue;
    }
  }
}
