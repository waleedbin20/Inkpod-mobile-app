import 'package:app/screens/home/AddArticle.dart';
import 'package:app/screens/home/NewsPage.dart';
import 'package:app/screens/home/ProfileMenu.dart';
import 'package:app/screens/home/Search.dart';
import 'package:app/screens/home/Trending.dart';
import 'package:app/widget_config/BottomNavBar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _navindex = 0;

  PageController pageController =
      PageController(initialPage: 0, keepPage: true);

  @override
  void initState() {
    super.initState();
  }

  PreferredSizeWidget buildAppBar() {
    final double screenHeight = MediaQuery.of(context).size.height;
    //final double screenWidth = MediaQuery.of(context).size.width;
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      actions: <Widget>[],
      title: Row(
        // mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Image(
              width: screenHeight * 1 / 6,
              image: AssetImage('assets/logo.png'),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (idx) => setState(() {
        _navindex = idx;
      }),
      children: <Widget>[
        NewsPage(),
        TrendingPage(),
        AddArticle(),
        SearchPage(),
        ProfileMenu()
      ],
    );
  }

  Widget buildBottomNav(context) {
    return Container(
      height: 60,
      child: SingleChildScrollView(
        child: BottomNavigationBar(
          iconSize: 24,
          selectedFontSize: 12,
          backgroundColor: Colors.white,
          elevation: 0,
          currentIndex: _navindex,
          unselectedItemColor: Colors.grey[400],
          selectedItemColor: Theme.of(context).primaryColor,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          items:
              List.generate(navBarItems.length, (idx) => getBottomNavItem(idx)),
          onTap: (idx) => setState(() {
            _navindex = idx;
            pageController.animateToPage(idx,
                duration: Duration(milliseconds: 250), curve: Curves.easeOut);
          }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildPageView(),
      bottomNavigationBar: buildBottomNav(context),
    );
  }
}
