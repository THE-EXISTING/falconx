import 'package:falconx/lib.dart';

class ShapeStyle with EquatableMixin {
  const ShapeStyle({
    this.cornerRadius,
    this.strokeThickness,
    this.strokeColor,
    this.strokeGradient,
    this.shadows,
    this.backgroundBlur,
    this.backgroundColor,
    this.backgroundGradient,
  });

  final double? cornerRadius;
  final double? strokeThickness;
  final Color? strokeColor;
  final Gradient? strokeGradient;
  final List<BoxShadow>? shadows;
  final ImageFiltered? backgroundBlur;
  final Color? backgroundColor;
  final Gradient? backgroundGradient;

  ShapeStyle copy({
    double? cornerRadius,
    double? strokeThickness,
    Color? strokeColor,
    Gradient? strokeGradient,
    List<BoxShadow>? shadows,
    ImageFiltered? backgroundBlur,
    Color? backgroundColor,
    Gradient? backgroundGradient,
  }) =>
      ShapeStyle(
        cornerRadius: cornerRadius ?? this.cornerRadius,
        strokeThickness: strokeThickness ?? this.strokeThickness,
        strokeColor: strokeColor ?? this.strokeColor,
        strokeGradient: strokeGradient ?? this.strokeGradient,
        shadows: shadows ?? this.shadows,
        backgroundBlur: backgroundBlur ?? this.backgroundBlur,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        backgroundGradient: backgroundGradient ?? this.backgroundGradient,
      );

  @override
  List<Object?> get props => [
        cornerRadius,
        strokeThickness,
        strokeColor,
        strokeGradient,
        shadows,
        backgroundBlur,
        backgroundColor,
        backgroundGradient,
      ];

  @override
  bool? get stringify => true;
}

class GestureShapeStyle with EquatableMixin {
  const GestureShapeStyle({
    this.focusStyle,
    this.pressStyle,
    this.disableStyle,
  });

  final ShapeStyle? focusStyle;
  final ShapeStyle? pressStyle;
  final ShapeStyle? disableStyle;

  GestureShapeStyle copy({
    ShapeStyle? focusStyle,
    ShapeStyle? pressStyle,
    ShapeStyle? disableStyle,
  }) =>
      GestureShapeStyle(
        focusStyle: focusStyle ?? this.focusStyle,
        pressStyle: pressStyle ?? this.pressStyle,
        disableStyle: disableStyle ?? this.disableStyle,
      );

  @override
  List<Object?> get props => [
        focusStyle,
        pressStyle,
        disableStyle,
      ];

  @override
  bool? get stringify => true;
}
