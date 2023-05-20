import 'package:falconx/falconx.dart';

abstract class PaletteColor {
  PaletteColor() {
    transparent = TransparentPalette(c600);
  }

  Color get c25;

  Color get c50;

  Color get c100;

  Color get c200;

  Color get c300;

  Color get c400;

  Color get c500;

  Color get c600;

  Color get c700;

  Color get c800;

  Color get c900;

  late final TransparentPalette transparent;
}

class TransparentPalette {
  const TransparentPalette(this.color);

  final Color color;

  Color get p2 => color.withOpacity(0.02);

  Color get p4 => color.withOpacity(0.04);

  Color get p6 => color.withOpacity(0.06);

  Color get p8 => color.withOpacity(0.08);

  Color get p12 => color.withOpacity(0.12);

  Color get p16 => color.withOpacity(0.16);

  Color get p20 => color.withOpacity(0.20);

  Color get p30 => color.withOpacity(0.30);

  Color get p40 => color.withOpacity(0.40);

  Color get p50 => color.withOpacity(0.50);

  Color get p60 => color.withOpacity(0.60);

  Color get p70 => color.withOpacity(0.70);

  Color get p80 => color.withOpacity(0.80);

  Color get p90 => color.withOpacity(0.90);

  Color get p96 => color.withOpacity(0.96);
}
