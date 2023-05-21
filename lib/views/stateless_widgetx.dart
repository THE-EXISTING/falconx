import 'package:falconx/falconx.dart';

abstract class StatelessWidgetX extends StatelessWidget {
  String get tag => runtimeType.toString();

  final WidgetState state;

  const StatelessWidgetX({
    Key? key,
    WidgetState? state,
  })  : state = state ?? WidgetState.normal,
        super(key: key);

  bool get isNormal => state == WidgetState.normal;

  bool get isNotNormal => !isNormal;

  bool get isLoading => state == WidgetState.loading;

  bool get isNotLoading => !isLoading;

  bool get isEmpty => state == WidgetState.empty;

  bool get isNotEmpty => !isEmpty;

  bool get isError => state == WidgetState.error;

  bool get isNotError => !isError;

  @protected
  @override
  @Deprecated('Please use [buildDefault] instead')
  Widget build(BuildContext context) {
    switch (state) {
      case WidgetState.normal:
        return buildDefault(context);
      case WidgetState.loading:
        return buildLoading(context);
      case WidgetState.empty:
        return buildEmpty(context);
      case WidgetState.disabled:
        return buildDisabled(context);
      case WidgetState.error:
        return buildError(context);
      case WidgetState.hovered:
        return buildHovered(context);
      case WidgetState.focused:
        return buildFocused(context);
      case WidgetState.pressed:
        return buildPressed(context);
    }
  }

  Widget buildDefault(BuildContext context);

  Widget buildLoading(BuildContext context) {
    return buildDefault(context);
  }

  Widget buildEmpty(BuildContext context) {
    return buildDefault(context);
  }

  Widget buildDisabled(BuildContext context) {
    return buildDefault(context);
  }

  Widget buildError(BuildContext context) {
    return buildDefault(context);
  }

  Widget buildHovered(BuildContext context) {
    return buildDefault(context);
  }

  Widget buildFocused(BuildContext context) {
    return buildDefault(context);
  }

  Widget buildPressed(BuildContext context) {
    return buildDefault(context);
  }

  void goToPath(
    BuildContext context,
    String path, {
    Object? extra,
  }) {
    if (context.mounted) {
      return context.go(path, extra: extra);
    }
  }

  void goToScreenNamed(
    BuildContext context,
    String screenName, {
    Map<String, String>? params,
    Map<String, dynamic>? queryParams,
  }) {
    if (context.mounted) {
      return context.goNamed(
        screenName,
        params: params ?? const <String, String>{},
        queryParams: queryParams ?? const <String, dynamic>{},
      );
    }
  }

  void popScreen(BuildContext context) {
    if (context.mounted) {
      if (context.canPop()) {
        return context.pop();
      } else {
        SystemNavigator.pop();
      }
    }
  }
}
