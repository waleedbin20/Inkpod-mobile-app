import 'package:flutter/material.dart';

final navBarItems = [
  {
    "label": "Home",
    "tag": "home",
  },
  {
    "label": "Trending",
    "tag": "trending",
  },
  {
    "label": "Add Article",
    "tag": "addArticle",
  },
  {
    "label": "Search",
    "tag": "search",
  },
  {
    "label": "Profile",
    "tag": "profile",
  },
];

Map<String, IconData> iconMap = {
  "home": Icons.home,
  "trending": Icons.whatshot,
  "addArticle": Icons.add_circle_outline,
  "search": Icons.search,
  "profile": Icons.account_circle,
};

getBottomNavItem(int idx) {
  final navItem = navBarItems[idx];

  return BottomNavigationBarItem(
    icon: Padding(
        padding: EdgeInsets.symmetric(vertical: 0),
        child: Icon(iconMap[navItem['tag']], size: 35)),
    label: navItem['label'].toString(),
  );
}
