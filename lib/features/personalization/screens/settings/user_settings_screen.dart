import 'package:cri_v3/common/widgets/appbar/v2_app_bar.dart';
import 'package:cri_v3/common/widgets/dividers/custom_divider.dart'
    show CCustomDivider;
import 'package:cri_v3/common/widgets/list_tiles/menu_tile.dart';
import 'package:cri_v3/common/widgets/txt_widgets/c_section_headings.dart';
import 'package:cri_v3/data/repos/auth/auth_repo.dart';
import 'package:cri_v3/features/personalization/controllers/app_settings_controller.dart';
import 'package:cri_v3/features/personalization/controllers/user_controller.dart';
import 'package:cri_v3/features/personalization/screens/profile/profile.dart';
import 'package:cri_v3/features/personalization/screens/settings/widgets/payment_platforms.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:cri_v3/utils/helpers/network_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CUserSettingsScreen extends StatelessWidget {
  const CUserSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appSettingsController = Get.put(CAppSettingsController());
    //final isConnectedToInternet = CNetworkManager.instance.hasConnection.value;
    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    //final navController = Get.put(CNavMenuController());
    final userController = Get.put(CUserController());

    return Container(
      color: isDarkTheme ? CColors.transparent : CColors.white,
      child: Scaffold(
        appBar: CVersion2AppBar(
          autoImplyLeading: false,
        ),
        backgroundColor: CColors.rBrown.withValues(alpha: 0.2),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 15.0, top: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userController.user.value.email,
                  style: Theme.of(context).textTheme.labelSmall!.apply(
                    color: isDarkTheme
                        ? CColors.darkGrey
                        : CNetworkManager.instance.hasConnection.value
                        ? CColors.rBrown
                        : CColors.darkGrey,
                  ),
                ),
                Text(
                  userController.user.value.fullName.split(" ").elementAt(0),
                  style: Theme.of(context).textTheme.labelLarge!.apply(
                    color: isDarkTheme
                        ? CColors.darkGrey
                        : CNetworkManager.instance.hasConnection.value
                        ? CColors.rBrown
                        : CColors.darkGrey,
                    fontSizeFactor: 2.5,
                    fontWeightDelta: -7,
                  ),
                ),

                /// -- custom divider --
                CCustomDivider(leftPadding: 5.0),

                // -- app settings
                const SizedBox(height: CSizes.spaceBtnItems),

                CMenuTile(
                  icon: Iconsax.user_edit,
                  title: 'My profile',
                  subTitle: 'Check out your profile',
                  trailing: IconButton(
                    onPressed: () {
                      Get.to(() => const CProfileScreen());
                    },
                    icon: const Icon(
                      Iconsax.arrow_right,
                    ),
                  ),
                  onTap: () {
                    Get.to(
                      () {
                        return const CProfileScreen();
                      },
                    );
                  },
                ),
                const CSectionHeading(
                  showActionBtn: false,
                  title: 'App settings',
                  btnTitle: '',
                  editFontSize: false,
                ),

                CMenuTile(
                  icon: Iconsax.money_recive,
                  title: 'Payment methods',
                  subTitle:
                      'Set payment platforms and(or) accounts for transactions',
                  trailing: IconButton(
                    onPressed: () {
                      Get.to(() => CPaymentPlatforms());
                    },
                    icon: const Icon(Iconsax.arrow_right),
                  ),
                  onTap: () {
                    Get.to(() => CPaymentPlatforms());
                  },
                ),

                CMenuTile(
                  icon: Iconsax.document_upload,
                  title: 'Upload data',
                  subTitle:
                      'Upload inventory, transactions data, and contacts to the cloud',
                  trailing: IconButton(
                    onPressed: () {},
                    icon: const Icon(Iconsax.arrow_right),
                  ),
                  onTap: () {},
                ),

                CMenuTile(
                  icon: Iconsax.cloud,
                  title: 'Auto-sync data',
                  subTitle:
                      'Set automatic cloud sync for your inventory, contacts, and sales data',
                  trailing: Obx(() {
                    return Switch(
                      value: appSettingsController.dataSyncIsOn.value,
                      activeThumbColor: CColors.rBrown,
                      onChanged: (value) {
                        appSettingsController.toggleSyncSettings(value);
                      },
                    );
                  }),
                ),
                CMenuTile(
                  icon: Iconsax.location,
                  title: 'Geolocation',
                  subTitle:
                      'Set recommendation based on location. This is recommended to help us keep you and your customers safe.',
                  trailing: Switch(
                    value: true,
                    activeThumbColor: CColors.rBrown,
                    onChanged: (value) {},
                  ),
                ),
                // CMenuTile(
                //   icon: Iconsax.shopping_cart,
                //   title: 'My cart',
                //   subTitle: 'Add, remove products, and proceed to checkout',
                //   onTap: () {},
                // ),
                CMenuTile(
                  icon: Iconsax.shopping_cart,
                  subTitle: 'Add, remove products, and proceed to checkout',
                  title: 'checkout items',
                  onTap: () {},
                ),

                const Divider(),
                const SizedBox(height: CSizes.spaceBtnItems),

                Center(
                  child: Row(
                    children: [
                      const Icon(
                        Iconsax.logout,
                        size: 28.0,
                        color: CColors.primaryBrown,
                      ),
                      const SizedBox(width: CSizes.spaceBtnInputFields),
                      TextButton(
                        onPressed: () {
                          AuthRepo.instance.logout();
                        },
                        child: Text(
                          'log out',
                          style: TextStyle(
                            color: isDarkTheme
                                ? CColors.grey
                                : CColors.darkGrey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
