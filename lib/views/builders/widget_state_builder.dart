import 'package:falconx/lib.dart';

class FullWidgetStateBuilder extends StatefulWidget {
  const FullWidgetStateBuilder({
    super.key,
    required this.create,
    required this.builder,
    this.lazy,
  });

  final FullWidgetStateNotifier create;
  final Widget Function(BuildContext context, FullWidgetState state, Widget? child)
      builder;
  final bool? lazy;

  @override
  State<FullWidgetStateBuilder> createState() => _FullWidgetStateBuilderState();
}

class _FullWidgetStateBuilderState extends State<FullWidgetStateBuilder> {
  @override
  Widget build(BuildContext context) =>
      ChangeNotifierProvider<FullWidgetStateNotifier>(
        create: (context) => widget.create,
        lazy: widget.lazy,
        child: Consumer<FullWidgetStateNotifier>(
          builder: (context, widgetState, child) =>
              widget.builder(context, widgetState.value, child),
        ),
      );
}
