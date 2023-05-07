import 'package:falconx/falconx.dart';

abstract class PaletteColor {
  PaletteColor() {
    tran = TransparentPalette(c600);
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

  late final TransparentPalette tran;
}

class TransparentPalette {
  const TransparentPalette(this.color);

  final Color color;

  Color get tran2 => color.withOpacity(0.02);

  Color get tran4 => color.withOpacity(0.04);

  Color get tran6 => color.withOpacity(0.06);

  Color get tran8 => color.withOpacity(0.08);

  Color get tran12 => color.withOpacity(0.12);

  Color get tran16 => color.withOpacity(0.16);

  Color get tran20 => color.withOpacity(0.20);

  Color get tran30 => color.withOpacity(0.30);

  Color get tran40 => color.withOpacity(0.40);

  Color get tran50 => color.withOpacity(0.50);

  Color get tran60 => color.withOpacity(0.60);

  Color get tran70 => color.withOpacity(0.70);

  Color get tran80 => color.withOpacity(0.80);

  Color get tran90 => color.withOpacity(0.90);

  Color get tran96 => color.withOpacity(0.96);
}
