import 'package:falconx/lib.dart';

class Space extends SizedBox {

  static get empty => const Space.box(0.00);

  const Space.height(double height, [Key? key]) : super(key: key, height: height);

  const Space.width(double width, [Key? key]) : super(key: key, width: width);

  const Space.box(double size, [Key? key]) : super(key:key, width: size, height: size);

  static Space get height2 => const Space.height(2.0);
  static Space get height4 => const Space.height(4.0);
  static Space get height8 => const Space.height(8.0);
  static Space get height12 => const Space.height(12.0);
  static Space get height16 => const Space.height(16.0);
  static Space get height20 => const Space.height(20.0);
  static Space get height24 => const Space.height(24.0);
  static Space get height32 => const Space.height(32.0);
  static Space get height40 => const Space.height(40.0);
  static Space get height56 => const Space.height(56.0);
  static Space get height64 => const Space.height(64.0);
  static Space get height72 => const Space.height(72.0);

  static Space get width2 => const Space.width(2.0);
  static Space get width4 => const Space.width(4.0);
  static Space get width8 => const Space.width(8.0);
  static Space get width12 => const Space.width(12.0);
  static Space get width16 => const Space.width(16.0);
  static Space get width20 => const Space.width(20.0);
  static Space get width24 => const Space.width(24.0);

  static Space get boxZero => const Space.box(0);
  static Space get box2 => const Space.box(2.0);
  static Space get box4 => const Space.box(4.0);
  static Space get box8 => const Space.box(8.0);
  static Space get box12 => const Space.box(12.0);
  static Space get box16 => const Space.box(16.0);
  static Space get box20 => const Space.box(20.0);
  static Space get box24 => const Space.box(24.0);
  static Space get box32 => const Space.box(32.0);
  static Space get box64 => const Space.box(32.0);


}
