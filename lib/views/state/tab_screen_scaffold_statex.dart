import 'package:falconx/falconx.dart';

abstract class TabScreenScaffoldStateX<T extends StatefulWidgetX>
    extends StateX<T> {

  @protected
  @override
  @Deprecated('Please use [buildDefault] instead')
  Widget build(BuildContext context) {
    List<Widget> tabScreenList = buildTabView();
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: WillPopScope(
        onWillPop: () => onWillPop(),
        child: DefaultTabController(
          length: tabScreenList.length,
          initialIndex: initialTabIndex(),
          child: Scaffold(
            appBar: buildAppBar(),
            backgroundColor: backGroundColor,
            body: buildBody(
              context,
              TabBarView(children: tabScreenList),
            ),
          ),
        ),
      ),
    );
  }

  Color get backGroundColor => Colors.white;

  List<Widget> buildTabView();

  Widget buildBody(BuildContext context, TabBarView tabView);

  int initialTabIndex() {
    return 0;
  }

  PreferredSizeWidget? buildAppBar() {
    return null;
  }

  Future<bool> onWillPop() {
    return Future.value(true);
  }
}
