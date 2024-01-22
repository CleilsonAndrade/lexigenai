import 'package:flutter/material.dart';
import 'package:lexigenai_app/src/page/home_page/tabs/tab_image.dart';
import 'package:lexigenai_app/src/page/home_page/tabs/tab_text.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LexiGenAI'),
        centerTitle: true,
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        // swipe navigation handling is not supported
        controller: _tabController,
        children: const <Widget>[
          TabText(),
          TabImage(),
        ],
      ),
      bottomNavigationBar: MotionTabBar(
        initialSelectedTab: "Text",
        labels: const ["Text", "Image"],
        icons: const [Icons.text_fields, Icons.image],
        tabSize: 50,
        tabBarHeight: 55,
        textStyle: const TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        tabIconColor: Colors.white54,
        tabIconSize: 28.0,
        tabIconSelectedSize: 26.0,
        tabSelectedColor: Colors.orange,
        tabIconSelectedColor: Colors.white,
        tabBarColor: Colors.blueGrey,
        onTabItemSelected: (int value) {
          setState(() {
            _tabController!.index = value;
          });
        },
      ),
    );
  }
}
