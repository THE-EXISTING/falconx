// Created by Nonthawit on 22/11/2024 AD Lead Flutter at NEXTZY and EXISTING
import 'package:falconx/lib.dart';

class ContentSafeState<T> extends Cubit<WidgetStateEvent<T>> {
  ContentSafeState.initial(T data)
      : super(WidgetStateEvent(FullWidgetState.initial, data: data));

  void initial([T? data]) {
    emit(WidgetStateEvent(FullWidgetState.initial, data: data ?? state.data));
  }

  void success([T? data]) {
    emit(WidgetStateEvent(FullWidgetState.success, data: data ?? state.data));
  }

  void loading([T? data]) {
    emit(WidgetStateEvent(FullWidgetState.loading, data: data ?? state.data));
  }

  void warning([T? data]) {
    emit(WidgetStateEvent(FullWidgetState.warning, data: data ?? state.data));
  }

  void fail([T? data]) {
    emit(WidgetStateEvent(FullWidgetState.fail, data: data ?? state.data));
  }
}

class ContentSafeBuilder<T>
    extends BlocBuilder<ContentSafeState<T>, WidgetStateEvent<T>> {
  const ContentSafeBuilder({
    super.key,
    ContentSafeState<T>? content,
    super.buildWhen,
    required super.builder,
  }) : super(bloc: content);
}
