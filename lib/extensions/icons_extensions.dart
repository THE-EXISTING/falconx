import 'package:falconx/falconx.dart';

extension SvgIcons on String? {
  SvgPicture toSvg({
    Key? key,
    double? height,
    double? width,
    Color? color,
    String? label,
  }) =>
      SvgPicture.asset(
        key: key,
        this!,
        height: height,
        width: width,
        colorFilter:
            color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
        semanticsLabel: label,
      );

  SvgPicture toSvgIcon({
    Key? key,
    double size = 24,
    Color? color,
    String? label,
  }) =>
      toSvg(
        key: key,
        height: size,
        width: size,
        color: color,
        label: label,
      );
}
