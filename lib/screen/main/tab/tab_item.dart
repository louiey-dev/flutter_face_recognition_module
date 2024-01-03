import 'package:face_recognition_module/common/common.dart';
import 'package:face_recognition_module/screen/main/tab/configuration/f_configuration.dart';
import 'package:face_recognition_module/screen/main/tab/favorite/f_favorite.dart';
import 'package:face_recognition_module/screen/main/tab/home/f_home.dart';
import 'package:face_recognition_module/screen/main/tab/terminal/f_terminal.dart';
import 'package:flutter/material.dart';

enum TabItem {
  // home(Icons.home, '홈', HomeFragment()),
  // favorite(Icons.star, '즐겨찾기', FavoriteFragment(isShowBackButton: false)),
  configuration(
      Icons.room_preferences_outlined, 'Configuration', ConfigFragment()),
  terminal(Icons.terminal, 'Terminal', TerminalFragment());

  final IconData activeIcon;
  final IconData inActiveIcon;
  final String tabName;
  final Widget firstPage;

  const TabItem(this.activeIcon, this.tabName, this.firstPage,
      {IconData? inActiveIcon})
      : inActiveIcon = inActiveIcon ?? activeIcon;

  BottomNavigationBarItem toNavigationBarItem(BuildContext context,
      {required bool isActivated}) {
    return BottomNavigationBarItem(
        icon: Icon(
          key: ValueKey(tabName),
          isActivated ? activeIcon : inActiveIcon,
          color: isActivated
              ? context.appColors.iconButton
              : context.appColors.iconButtonInactivate,
        ),
        label: tabName);
  }
}
