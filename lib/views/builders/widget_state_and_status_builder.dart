import 'package:falconx/lib.dart';

class WidgetStateAndStatusBuilder extends StatefulWidget {
  const WidgetStateAndStatusBuilder({
    super.key,
    required this.createWidgetState,
    required this.createWidgetStatus,
    required this.builder,
    this.lazy,
  });

  final WidgetStateNotifier createWidgetState;
  final WidgetStatusNotifier createWidgetStatus;
  final Widget Function(BuildContext context, WidgetState? state,
      WidgetStatus? status, Widget? child) builder;
  final bool? lazy;

  @override
  State<WidgetStateAndStatusBuilder> createState() =>
      _WidgetStateAndStatusBuilderState();
}

class _WidgetStateAndStatusBuilderState
    extends State<WidgetStateAndStatusBuilder> {
  @override
  Widget build(BuildContext context) =>
      ChangeNotifierProvider<WidgetStateNotifier>(
        create: (context) => widget.createWidgetState,
        lazy: widget.lazy,
        child: Consumer<WidgetStateNotifier>(
          builder: (context, widgetState, child) =>
              ChangeNotifierProvider<WidgetStatusNotifier>(
            create: (context) => widget.createWidgetStatus,
            lazy: widget.lazy,
            child: Consumer<WidgetStatusNotifier>(
              builder: (context, widgetStatus, child) => widget.builder(
                  context, widgetState.value, widgetStatus.value, child),
            ),
          ),
        ),
      );
}
