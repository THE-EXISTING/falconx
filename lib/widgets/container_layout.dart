import 'package:falconx/falconx.dart';

class ContainerLayout extends StatelessWidget {
  const ContainerLayout({
    Key? key,
    this.direction = Axis.vertical,
    this.backgroundColor,
    this.spacing = 0.0,
    this.width,
    this.height,
    this.boxShadow,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.crossAxisIntrinsic = false,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.mainAxisExpanded = false,
    this.margin,
    this.padding,
    this.radius,
    this.borderRadius,
    this.strokeThickness,
    this.borderStroke,
    this.strokeColor,
    this.decoration,
    this.child,
    this.children,
    this.onPress,
    this.onLongPress,
    this.builder,
  }) : super(key: key);

  final Axis direction;
  final double spacing;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final List<BoxShadow>? boxShadow;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final bool mainAxisExpanded;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final double? radius;
  final BorderRadius? borderRadius;
  final BoxBorder? borderStroke;
  final double? strokeThickness;
  final Color? strokeColor;
  final Decoration? decoration;
  final Widget? child;
  final List<Widget>? children;
  final bool crossAxisIntrinsic;
  final GestureTapCallback? onPress;
  final GestureLongPressCallback? onLongPress;
  final Function(BuildContext context, Widget child)? builder;

  @override
  Widget build(BuildContext context) {
    Widget layout;
    if (children != null) {
      List<Widget> modifyWidgetList = _addSpaceWidgetList(children!);
      switch (direction) {
        case Axis.horizontal:
          layout = _buildIntrinsic(
            direction: direction,
            intrinsic: crossAxisIntrinsic,
            child: Row(
              key: key,
              crossAxisAlignment: crossAxisAlignment,
              mainAxisAlignment: mainAxisAlignment,
              mainAxisSize: mainAxisSize,
              children: modifyWidgetList,
            ),
          );
          break;
        case Axis.vertical:
          layout = _buildIntrinsic(
            direction: direction,
            intrinsic: crossAxisIntrinsic,
            child: Column(
              key: key,
              crossAxisAlignment: crossAxisAlignment,
              mainAxisAlignment: mainAxisAlignment,
              mainAxisSize: mainAxisSize,
              children: modifyWidgetList,
            ),
          );
          break;
      }
    } else {
      layout = child ?? Container();
    }

    return _buildSizeBox(
      width: width,
      height: height,
      child: _buildExpanded(
        expanded: mainAxisExpanded,
        child: _buildPadding(
          padding: margin,
          child: _buildInkWell(
            context,
            radius: radius,
            borderRadius: borderRadius,
            onPress: onPress,
            onLongPress: onLongPress,
            child: _buildBoxDecorator(
              backgroundColor: backgroundColor,
              strokeThickness: strokeThickness,
              strokeColor: strokeColor,
              radius: radius,
              borderRadius: borderRadius,
              borderStroke: borderStroke,
              decoration: decoration,
              shadow: boxShadow,
              child: _buildClipRect(
                radius: radius,
                borderRadius: borderRadius,
                child: _buildPadding(
                  padding: padding,
                  child: _customBuilder(
                    context,
                    layout,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///========================= PRIVATE METHOD =========================///
  Widget _customBuilder(BuildContext context, Widget child) {
    return builder?.call(context, child) ?? child;
  }

  Widget _buildInkWell(
    BuildContext context, {
    required double? radius,
    required GestureTapCallback? onPress,
    required GestureLongPressCallback? onLongPress,
    required BorderRadius? borderRadius,
    required Widget child,
  }) {
    if (onPress == null && onLongPress == null) return child;

    Brightness currentBrightness = Theme.of(context).brightness;
    final baseColor =
        currentBrightness == Brightness.dark ? Colors.white : Colors.black;
    final focusColor = baseColor.withOpacity(0.01);
    final splashColor = baseColor.withOpacity(0.01);
    final highlightColor = baseColor.withOpacity(0.04);
    return InkWell(
      radius: radius,
      borderRadius: borderRadius,
      focusColor: focusColor,
      splashColor: splashColor,
      highlightColor: highlightColor,
      onTap: onPress,
      onLongPress: onLongPress,
    );
  }

  Widget _buildSizeBox({
    double? width,
    double? height,
    required Widget child,
  }) =>
      (width == null && height == null)
          ? child
          : SizedBox(
              height: height,
              width: width,
              child: child,
            );

  Widget _buildClipRect({
    required double? radius,
    required BorderRadius? borderRadius,
    required Widget child,
  }) =>
      radius != null
          ? ClipRRect(
              clipBehavior: Clip.hardEdge,
              borderRadius: borderRadius ?? BorderRadius.circular(radius),
              child: child,
            )
          : child;

  Widget _buildBoxDecorator({
    required Color? backgroundColor,
    required double? radius,
    required BorderRadius? borderRadius,
    required BoxBorder? borderStroke,
    required double? strokeThickness,
    required Color? strokeColor,
    required List<BoxShadow>? shadow,
    required Decoration? decoration,
    required Widget child,
  }) =>
      decoration != null ||
              (backgroundColor != null ||
                  radius != null ||
                  borderRadius != null ||
                  borderStroke != null ||
                  strokeThickness != null ||
                  strokeColor != null ||
                  shadow != null)
          ? DecoratedBox(
              decoration: decoration ??
                  BoxDecoration(
                    color: backgroundColor,
                    border: borderStroke ??
                        Border.all(
                          strokeAlign: BorderSide.strokeAlignInside,
                          color: strokeColor ?? Colors.transparent,
                          width: strokeThickness ?? 0.0,
                        ),
                    borderRadius: borderRadius ??
                        (radius != null ? BorderRadius.circular(radius) : null),
                    boxShadow:
                        radius == null && borderRadius == null ? shadow : null,
                  ),
              child: child,
            )
          : child;

  Widget _buildIntrinsic({
    required Axis direction,
    required bool intrinsic,
    required Flex child,
  }) {
    if (intrinsic == false) return child;

    switch (direction) {
      case Axis.horizontal:
        return IntrinsicHeight(
          child: child,
        );
      case Axis.vertical:
        return IntrinsicWidth(
          child: child,
        );
    }
  }

  Widget _buildExpanded({required bool expanded, required Widget child}) =>
      (expanded == true) ? Expanded(child: child) : child;

  Widget _buildPadding({required EdgeInsets? padding, required child}) =>
      (padding != null)
          ? Padding(
              padding: padding,
              child: child,
            )
          : child;

  List<Widget> _addSpaceWidgetList(List<Widget> list) {
    if (spacing == 0.0) return list;
    return list.fold([], (list, element) {
      if (list.isNotEmpty) {
        list.add(_getSpace(spacing)); // Add separator
      }
      list.add(element);
      return list;
    });
  }

  Widget _getSpace(double space) {
    switch (direction) {
      case Axis.horizontal:
        return SizedBox(
          height: 0,
          width: space,
        );
      case Axis.vertical:
        return SizedBox(
          height: space,
          width: 0,
        );
    }
  }
}
