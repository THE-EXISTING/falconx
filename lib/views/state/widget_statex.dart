import 'package:falconx/falconx.dart';

abstract class WidgetStateX<T extends StatefulWidgetX> extends StateX<T> {
  WidgetStateX({WidgetState? viewState})
      : _stateNotifier =
            WidgetStateNotifier(state: viewState ?? WidgetState.normal);

  final WidgetStateNotifier _stateNotifier;

  WidgetState get viewState => _stateNotifier.value;

  @protected
  @override
  @Deprecated('Please use [buildDefault] instead')
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WidgetStateNotifier>(
        create: (context) => _stateNotifier,
        child: Consumer<WidgetStateNotifier>(//
            builder: (context, viewState, child) {
          switch (viewState.value) {
            case WidgetState.normal:
              if (viewState.value == WidgetState.loading) {
                return buildLoading(context, viewState.value);
              }
              if (viewState.value == WidgetState.empty) {
                return buildEmpty(context, viewState.value);
              }
              if (viewState.value == WidgetState.disabled) {
                return buildDisabled(context, viewState.value);
              }
              if (viewState.value == WidgetState.error) {
                return buildError(context, viewState.value);
              }
              if (viewState.value == WidgetState.hovered) {
                return buildHovered(context, viewState.value);
              }
              if (viewState.value == WidgetState.focused) {
                return buildFocused(context, viewState.value);
              }
              if (viewState.value == WidgetState.pressed) {
                return buildPressed(context, viewState.value);
              }
              return buildDefault(context, viewState.value);
            case WidgetState.loading:
              return buildLoading(context, viewState.value);
            case WidgetState.empty:
              return buildEmpty(context, viewState.value);
            case WidgetState.disabled:
              return buildDisabled(context, viewState.value);
            case WidgetState.error:
              return buildError(context, viewState.value);
            case WidgetState.hovered:
              return buildHovered(context, viewState.value);
            case WidgetState.focused:
              return buildFocused(context, viewState.value);
            case WidgetState.pressed:
              return buildPressed(context, viewState.value);
          }
        }));
  }

  Widget buildDefault(BuildContext context, WidgetState state);

  Widget buildLoading(BuildContext context, WidgetState state) {
    return buildDefault(context, state);
  }

  Widget buildEmpty(BuildContext context, WidgetState state) {
    return buildDefault(context, state);
  }

  Widget buildDisabled(BuildContext context, WidgetState state) {
    return buildDefault(context, state);
  }

  Widget buildError(BuildContext context, WidgetState state) {
    return buildDefault(context, state);
  }

  Widget buildHovered(BuildContext context, WidgetState state) {
    return buildDefault(context, state);
  }

  Widget buildFocused(BuildContext context, WidgetState state) {
    return buildDefault(context, state);
  }

  Widget buildPressed(BuildContext context, WidgetState state) {
    return buildDefault(context, state);
  }

  void changeState(WidgetState state) {
    _stateNotifier.value = state;
  }
}
