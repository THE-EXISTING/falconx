import 'package:falconx/lib.dart';

class WidgetStatusBuilder extends StatefulWidget {
  const WidgetStatusBuilder({
    super.key,
    required this.create,
    required this.builder,
    this.lazy,
  });

  final WidgetStatusNotifier create;
  final Widget Function(BuildContext context, WidgetState? state, Widget? child)
      builder;
  final bool? lazy;

  @override
  State<WidgetStatusBuilder> createState() => _WidgetStatusBuilderState();
}

class _WidgetStatusBuilderState extends State<WidgetStatusBuilder> {
  @override
  Widget build(BuildContext context) =>
      ChangeNotifierProvider<WidgetStatusNotifier>(
        create: (context) => widget.create,
        lazy: widget.lazy,
        child: Consumer<WidgetStateNotifier>(
          builder: (context, widgetState, child) =>
              widget.builder(context, widgetState.value, child),
        ),
      );
}
