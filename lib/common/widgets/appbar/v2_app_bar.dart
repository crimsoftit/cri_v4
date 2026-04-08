import 'package:cri_v3/common/widgets/img_widgets/c_circular_img.dart';
import 'package:cri_v3/features/personalization/controllers/user_controller.dart';
import 'package:cri_v3/features/personalization/screens/profile/profile.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/img_strings.dart';
import 'package:cri_v3/utils/device/device_utilities.dart';
import 'package:cri_v3/utils/helpers/network_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CVersion2AppBar extends StatelessWidget implements PreferredSizeWidget {
  const CVersion2AppBar({
    super.key,
    required this.autoImplyLeading,
    this.displayMenuIcon = true,
    this.menuIconReplacementWidget = const SizedBox.shrink(),
  });

  final bool autoImplyLeading;
  final bool? displayMenuIcon;
  final Widget menuIconReplacementWidget;

  @override
  Widget build(BuildContext context) {
    final isConnectedToInternet = CNetworkManager.instance.hasConnection.value;
    //final isDarkTheme = CHelperFunctions.isDarkMode(context);
    //final navController = Get.put(CNavMenuController());
    final userController = Get.put(CUserController());

    return AppBar(
      automaticallyImplyLeading: autoImplyLeading,
      iconTheme: IconThemeData(
        color: CColors.rBrown,
      ),
      title: Padding(
        padding: const EdgeInsets.only(
          left: 0.5,
          right: 0.5,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            displayMenuIcon == true
                ? Icon(
                    Iconsax.menu,
                    size: 25.0,
                    color: CColors.rBrown,
                  )
                : menuIconReplacementWidget,
            Obx(() {
              final networkImg = userController.user.value.profPic;

              final dpImg = networkImg.isNotEmpty && isConnectedToInternet
                  ? networkImg
                  : CImages.user;

              return InkWell(
                onTap: () {
                  //navController.selectedIndex.value = 3;
                  Get.to(() => const CProfileScreen());
                },
                child: CCircularImg(
                  isNetworkImg: networkImg.isNotEmpty && isConnectedToInternet,
                  img: dpImg,
                  width: 47.0,
                  height: 47.0,
                  padding: 1.0,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(CDeviceUtils.getAppBarHeight());
}
