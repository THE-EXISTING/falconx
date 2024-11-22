// Created by Nonthawit on 22/11/2024 AD Lead Flutter at NEXTZY and EXISTING
import 'package:falconx/lib.dart';

class ContentState<T> extends Cubit<WidgetStateEvent<T?>> {
  ContentState.initial([T? data])
      : super(WidgetStateEvent(FullWidgetState.initial, data: data));

  void initial([T? data]) {
    emit(WidgetStateEvent(FullWidgetState.initial, data: data ?? state.data));
  }

  void empty() {
    emit(WidgetStateEvent(FullWidgetState.empty, data: null));
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

class ContentBuilder<T>
    extends BlocBuilder<ContentState<T>, WidgetStateEvent<T?>> {
  const ContentBuilder({
    super.key,
    ContentState<T>? content,
    super.buildWhen,
    required super.builder,
  }) : super(bloc: content);
}
