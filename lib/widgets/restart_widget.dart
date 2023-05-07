import 'package:falconx/falconx.dart';

class DebugRestartWidget extends StatefulWidget {
  const DebugRestartWidget({Key? key, required this.child}): super(key:key);

  final Widget child;

  static void restartApp(BuildContext context) {
    if(BuildConfig.debug){
      context.findAncestorStateOfType<_DebugRestartWidgetState>()?.restartApp();
    }
  }

  @override
  _DebugRestartWidgetState createState() => _DebugRestartWidgetState();
}

class _DebugRestartWidgetState extends State<DebugRestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    if(BuildConfig.release) return widget.child;
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}