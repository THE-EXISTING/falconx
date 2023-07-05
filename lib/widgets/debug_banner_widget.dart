import 'package:falconx/lib.dart';

class DebugBannerView extends StatelessWidget {
  const DebugBannerView({Key? key, required this.child, this.color})
      : super(key: key);

  final Widget child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (BuildConfig.release) return child;
    return Stack(
      alignment: Alignment.topRight,
      children: <Widget>[
        child,
        _buildBanner(context),
      ],
    );
  }

  Widget _buildBanner(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onLongPress: () {
        // final globalContext = Catcher.navigatorKey?.currentContext;
        if (BuildConfig.debug) {
          showDialog(
            // context: globalContext ?? context,
            context: context,
            builder: (context) => const DeviceInfoDialog(),
          );
        }
      },
      child: SafeArea(
        child: SizedBox(
          width: 50,
          height: 50,
          child: CustomPaint(
            painter: BannerPainter(
              //TODO: Research how to get flavor name
              message: 'DEBUG',
              textDirection: Directionality.of(context),
              layoutDirection: Directionality.of(context),
              location: BannerLocation.topEnd,
              color: color ?? const Color(0xffff6153),
            ),
          ),
        ),
      ),
    );
  }
}
