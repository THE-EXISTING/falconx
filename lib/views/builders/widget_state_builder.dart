import 'package:falconx/lib.dart';

class WidgetStateBuilder extends StatefulWidget {
  const WidgetStateBuilder({
    super.key,
    required this.create,
    required this.builder,
    this.lazy,
  });

  final WidgetStateNotifier create;
  final Widget Function(BuildContext context, WidgetState? state, Widget? child)
      builder;
  final bool? lazy;

  @override
  State<WidgetStateBuilder> createState() => _WidgetStateBuilderState();
}

class _WidgetStateBuilderState extends State<WidgetStateBuilder> {
  @override
  Widget build(BuildContext context) =>
      ChangeNotifierProvider<WidgetStateNotifier>(
        create: (context) => widget.create,
        lazy: widget.lazy,
        child: Consumer<WidgetStateNotifier>(
          builder: (context, widgetState, child) =>
              widget.builder(context, widgetState.value, child),
        ),
      );
}
