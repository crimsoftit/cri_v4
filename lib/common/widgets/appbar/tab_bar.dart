import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/device/device_utilities.dart';
import 'package:flutter/material.dart';

class CTabBar extends StatelessWidget implements PreferredSizeWidget {
  const CTabBar({super.key, required this.tabs});

  final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    //final isDarkTheme = CHelperFunctions.isDarkMode(context);
    return TabBar(
      indicatorColor: CColors.rBrown,
      isScrollable: true,
      labelColor: CColors.rBrown,
      // padding: const EdgeInsets.only(
      //   left: 5.0,
      // ),
      tabAlignment: TabAlignment.start,
      tabs: tabs,

      unselectedLabelColor: CColors.darkGrey,
      // labelColor: isDarkTheme ? CColors.white : CColors.rBrown,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(CDeviceUtils.getAppBarHeight());
}
