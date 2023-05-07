import 'package:falconx/falconx.dart';

extension AssetImages on String {
  AssetImage toImage({
    AssetBundle? bundle,
    String? package,
  }) =>
      AssetImage(
        this,
        bundle: bundle,
        package: package,
      );

  Widget toWidgetImage({
    double? width,
    double? height,
    BoxFit? fit,
  }) =>
      Image.asset(
        this,
        width: width,
        height: height,
        fit: fit,
      );
}
