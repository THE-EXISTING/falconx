import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// A widget to calculate it's size after being built and attached to a widget tree
/// [onChange] get changed [Size] of the Widget
/// [child] Widget to get size of it at runtime
class WidgetMeasureSize extends StatefulWidget {
  final Widget child;
  final Function(Size) onChange;

  const WidgetMeasureSize({
    Key? key,
    required this.onChange,
    required this.child,
  }) : super(key: key);

  @override
  State<WidgetMeasureSize> createState() => _WidgetMeasureSizeState();
}

class _WidgetMeasureSizeState extends State<WidgetMeasureSize> {
  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback(postFrameCallback);
    return Container(
      key: widgetKey,
      child: widget.child,
    );
  }

  var widgetKey = GlobalKey();
  Size? oldSize;

  void postFrameCallback(_) async {
    var context = widgetKey.currentContext;
    if (!mounted || context == null) return; // not yet attached to layout

    var newSize = context.size!;
    if (oldSize == newSize) return;

    oldSize = newSize;
    widget.onChange(newSize);
  }
}
