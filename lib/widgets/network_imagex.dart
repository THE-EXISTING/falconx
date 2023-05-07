import 'package:falconx/falconx.dart';

class NetworkImageX extends StatelessWidgetX {
  const NetworkImageX._({
    required Key key,
    required this.imageUrl,
    required this.boxShape,
    this.loadingColor,
    this.width,
    this.height,
    this.borderRadius,
    this.cacheManager,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String imageUrl;
  final BorderRadius? borderRadius;
  final BoxShape boxShape;
  final Color? loadingColor;
  final BaseCacheManager? cacheManager;

  static Widget circle({
    required double size,
    required String imageUrl,
    Color? loadingColor,
    BaseCacheManager? cacheManager,
  }) =>
      NetworkImageX._(
        key: UniqueKey(),
        width: size,
        height: size,
        imageUrl: imageUrl,
        boxShape: BoxShape.circle,
        loadingColor: loadingColor,
        cacheManager: cacheManager,
      );

  static Widget rect({
    double? width,
    double? height,
    required String imageUrl,
    BorderRadius? borderRadius,
    Color? loadingColor,
  }) =>
      NetworkImageX._(
        key: UniqueKey(),
        width: width,
        height: height,
        imageUrl: imageUrl,
        boxShape: BoxShape.rectangle,
        borderRadius: borderRadius,
        loadingColor: loadingColor,
      );

  @override
  Widget buildDefault(BuildContext context) {
    switch (boxShape) {
      case BoxShape.rectangle:
        return buildRect(context);
      case BoxShape.circle:
        return buildCircle(context);
      default:
        return buildRect(context);
    }
  }

  Widget buildCircle(BuildContext context) {
    return CachedNetworkImage(
      cacheManager: cacheManager ?? DefaultCacheManager(),
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            borderRadius: borderRadius,
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
      placeholder: (context, url) {
        return SkeletonX.circle(
          color: loadingColor ?? Colors.grey,
          size: width!,
        );
      },
      errorWidget: (context, url, error) {
        return SkeletonX.circle(
          color: loadingColor ?? Colors.grey,
          size: width!,
        );
      },
    );
  }

  Widget buildImage(BuildContext context, ImageWidgetBuilder? imageBuilder) {
    return CachedNetworkImage(
      cacheManager: cacheManager ?? DefaultCacheManager(),
      imageUrl: imageUrl,
      imageBuilder: imageBuilder,
      placeholder: (context, url) {
        return SkeletonX.circle(
          color: loadingColor ?? Colors.grey,
          size: width!,
        );
      },
      errorWidget: (context, url, error) {
        return SkeletonX.circle(
          color: loadingColor ?? Colors.grey,
          size: width!,
        );
      },
    );
  }

  Widget buildRect(BuildContext context) {
    return CachedNetworkImage(
      cacheManager: cacheManager ?? DefaultCacheManager(),
      imageUrl: imageUrl,
      fit: BoxFit.contain,
      width: width,
      height: height,
      imageBuilder: (context, imageProvider) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(0),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
      placeholder: (context, url) {
        return SkeletonX.rect(
          width: width,
          height: height,
          color: loadingColor ?? Colors.grey,
          borderRadius: borderRadius ?? BorderRadius.circular(0),
        );
      },
      errorWidget: (context, url, error) {
        return SkeletonX.rect(
          width: width,
          height: height,
          color: loadingColor ?? Colors.grey,
          borderRadius: borderRadius ?? BorderRadius.circular(0),
        );
      },
    );
  }
}
