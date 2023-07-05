import 'package:falconx/lib.dart';

extension SvgIcons on String? {
  Widget toSvg({
    Key? key,
    double? height,
    double? width,
    Color? color,
    String? label,
  }) =>
      SizedBox(
        height: height,
        width: width,
        child: SvgPicture.asset(
          key: key,
          this!,
          colorFilter:
              color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
          semanticsLabel: label,
          fit: BoxFit.fill,
          allowDrawingOutsideViewBox: true,
        ),
      );

  Widget toSvgIcon({
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
