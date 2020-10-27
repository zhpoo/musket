import 'package:flutter/material.dart';
import 'package:musket/route/mixin/index_mixin.dart';

mixin BottomNavigationBarMixin<T extends StatefulWidget> on IndexMixin<T> {
  NavigationBarStyle get navigationBarStyle;

  List<NavigationBarItem> get navigationBarItems;

  Widget get bottomNavigationBar {
    final style = navigationBarStyle ?? const NavigationBarStyle();
    final items = navigationBarItems;
    assert(items != null && items.length > 1, "navigationBarItems's length must more than 1");
    assert(0 <= currentIndex && currentIndex < items.length);
    return BottomNavigationBar(
      elevation: style.elevation,
      backgroundColor: style.backgroundColor,
      selectedItemColor: style.selectedItemColor,
      unselectedItemColor: style.unselectedItemColor,
      selectedFontSize: style.selectedFontSize,
      unselectedFontSize: style.unselectedFontSize,
      type: style.type,
      iconSize: style.iconSize,
      items: items.map(buildNavigationBarItem).toList(),
      currentIndex: currentIndex,
      onTap: setCurrentIndex,
    );
  }

  BottomNavigationBarItem buildNavigationBarItem(NavigationBarItem itemInfo) {
    var style = navigationBarStyle;
    return BottomNavigationBarItem(
      backgroundColor: itemInfo.backgroundColor,
      label: itemInfo.title ?? '',
      icon: Image.asset(itemInfo.icon, height: style.iconSize, width: style.iconSize),
      activeIcon: Image.asset(itemInfo.activeIcon, width: style.iconSize, height: style.iconSize),
    );
  }
}

class NavigationBarStyle {
  final double elevation;
  final double selectedFontSize;
  final double unselectedFontSize;
  final Color backgroundColor;
  final Color selectedItemColor;
  final Color unselectedItemColor;
  final BottomNavigationBarType type;
  final double iconSize;

  const NavigationBarStyle({
    this.elevation = 0.5,
    this.selectedFontSize = 10,
    this.unselectedFontSize = 10,
    this.iconSize = 24,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.type = BottomNavigationBarType.fixed,
  });
}

class NavigationBarItem {
  final String title;
  final String icon;
  final String activeIcon;
  final Color backgroundColor;

  NavigationBarItem({
    this.title,
    @required this.icon,
    String activeIcon,
    this.backgroundColor,
  }) : activeIcon = activeIcon ?? icon;
}
