import 'package:falconx/lib.dart';

enum SkeletonDirection { horizontal, vertical }

class LoadingSkeleton extends StatelessWidget {
  LoadingSkeleton({
    Key? key,
    this.width,
    this.height,
    required this.color,
    required this.borderRadius,
    required this.boxShape,
    this.direction,
  }) : super(key: key);

  final _random = Random();
  final double? width;
  final double? height;
  final Color color;
  final BorderRadius borderRadius;
  final BoxShape boxShape;
  final SkeletonDirection? direction;

  static Widget rect({
    double? width,
    double? height,
    required Color color,
    required BorderRadius borderRadius,
  }) =>
      LoadingSkeleton(
        width: width,
        height: height,
        color: color,
        boxShape: BoxShape.rectangle,
        borderRadius: borderRadius,
      );

  static Widget rectHorizontal({
    double? width,
    double? height,
    required Color color,
    required BorderRadius borderRadius,
  }) =>
      LoadingSkeleton(
        width: width,
        height: height,
        color: color,
        boxShape: BoxShape.rectangle,
        borderRadius: borderRadius,
        direction: SkeletonDirection.horizontal,
      );

  static Widget circle({
    required double size,
    required Color color,
  }) =>
      LoadingSkeleton(
        width: size,
        height: size,
        color: color,
        boxShape: BoxShape.circle,
        borderRadius: BorderRadius.circular(0),
      );

  Widget buildCircle(BuildContext context) {
    return ClipOval(
      child: Shimmer(
        duration: const Duration(seconds: 1),
        //Default value
        interval: const Duration(seconds: 2),
        //Default value: Duration(seconds: 0)
        color: Colors.white,
        //Default value
        colorOpacity: 0.4,
        //Default value
        direction: const ShimmerDirection.fromLTRB(),
        //Default Value
        child: Container(
          width: width,
          height: height,
          color: color,
        ),
      ),
    );
  }

  Widget buildRect(BuildContext context) {
    final box = context.findRenderObject() as RenderBox?;
    return ClipRRect(
      borderRadius: borderRadius,
      child: Shimmer(
        duration: const Duration(seconds: 1),
        interval: const Duration(seconds: 2),
        color: Colors.white,
        colorOpacity: 0.4,
        direction: const ShimmerDirection.fromLTRB(),
        //Default Value
        child: Container(
          width: box == null
              ? width
              : direction == SkeletonDirection.horizontal
                  ? _randomSize(box.size.width)
                  : box.size.width,
          height: box == null
              ? height
              : direction == SkeletonDirection.vertical
                  ? _randomSize(box.size.height)
                  : box.size.height,
          color: color,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (boxShape) {
      case BoxShape.rectangle:
        return buildRect(context);
      case BoxShape.circle:
        return buildCircle(context);
      default:
        return buildRect(context);
    }
  }

  double _randomSize(double size) {
    final double min = size * 3 / 4;
    final double max = size;
    return min + _random.nextInt(max.toInt() - min.toInt());
  }
}
