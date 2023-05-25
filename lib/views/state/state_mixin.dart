import 'package:falconx/falconx.dart';

mixin StateXMixin<T> {
  void initState();

  void didChangeDependencies();

  void restoreState(RestorationBucket? oldBucket, bool initialRestore);

  /// Came back to Foreground
  void resumed();

  Widget build(BuildContext context);

  void postFrame(BuildContext context);

  void deactivate();

  void dispose();

  void inactive();

  /// Went to Background
  void paused();

  void detached();
}
