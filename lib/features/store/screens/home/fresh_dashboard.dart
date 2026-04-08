import 'package:cri_v3/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:cri_v3/common/widgets/dividers/custom_divider.dart';
import 'package:cri_v3/common/widgets/products/cart/cart_counter_icon.dart';
import 'package:cri_v3/common/widgets/sliders/auto_img_slider.dart';
import 'package:cri_v3/features/store/controllers/inv_controller.dart';
import 'package:cri_v3/features/store/controllers/nav_menu_controller.dart';
import 'package:cri_v3/features/store/models/inv_model.dart';
import 'package:cri_v3/features/store/screens/home/widgets/dashboard_header.dart';
import 'package:cri_v3/features/store/screens/home/widgets/fresh_dashboard_screen_view.dart';
import 'package:cri_v3/features/store/screens/store_items_tings/inventory/widgets/inv_dialog.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/constants/txt_strings.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CFreshDashboardScreen extends StatelessWidget {
  const CFreshDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AddUpdateItemDialog dialog = AddUpdateItemDialog();

    final invController = Get.put(CInventoryController());
    final isDarkTheme = CHelperFunctions.isDarkMode(context);

    final navController = Get.put(CNavMenuController());

    return CRoundedContainer(
      bgColor: isDarkTheme ? CColors.transparent : CColors.white,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.only(
              left: 0.5,
              right: 0.5,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Iconsax.menu,
                  size: 25.0,
                  color: CColors.rBrown,
                ),
                CCartCounterIcon(
                  iconColor: CColors.rBrown,
                  showCounterWidget: true,
                ),
              ],
            ),
          ),
        ),
        backgroundColor: CColors.rBrown.withValues(alpha: 0.2),
        body: SingleChildScrollView(
          child: Obx(
            () {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: CSizes.defaultSpace / 4.0,
                  ),

                  /// -- dashboard header widget --
                  DashboardHeaderWidget(
                    actionsSection: SizedBox.shrink(),
                    appBarTitle: CTexts.homeAppbarTitle,
                    isHomeScreen: true,
                    screenTitle: 'dashboard',
                    showAppBarTitle: false,
                  ),

                  /// -- custom divider --
                  CCustomDivider(),

                  const SizedBox(
                    height: CSizes.defaultSpace * 2.5,
                  ),

                  CAutoImgSlider(),

                  const SizedBox(
                    height: CSizes.defaultSpace * 2.5,
                  ),
                  Text(
                    'welcome aboard!!'.toUpperCase(),
                    style: Theme.of(context).textTheme.bodyLarge!.apply(
                      // color: isDarkTheme
                      //     ? CColors.darkGrey
                      //     : CColors.rBrown,
                      color: CColors.rBrown,
                      fontSizeFactor: 1.3,
                      fontWeightDelta: -2,
                    ),
                  ),
                  const SizedBox(
                    height: CSizes.defaultSpace / 4,
                  ),
                  Text(
                    'your perfect dashboard is just a few sales away!'
                        .toUpperCase(),
                    style: Theme.of(context).textTheme.labelMedium!.apply(
                      color: isDarkTheme ? CColors.darkGrey : CColors.rBrown,
                    ),
                  ),

                  Text(
                    'your consummate brand awaits!'.toUpperCase(),
                    style: Theme.of(context).textTheme.labelMedium!.apply(
                      color: isDarkTheme ? CColors.darkGrey : CColors.rBrown,
                    ),
                  ),

                  const SizedBox(
                    height: CSizes.defaultSpace,
                  ),

                  invController.inventoryItems.isEmpty
                      ? CFreshDashboardScreenView(
                          iconData: Icons.add,
                          label:
                              'add your first inventory item to get started!',
                          onTap: () {
                            invController.resetInvFields();
                            showDialog(
                              context: context,
                              useRootNavigator: false,
                              builder: (BuildContext context) =>
                                  dialog.buildDialog(
                                    context,
                                    CInventoryModel(
                                      '',
                                      '',
                                      '',
                                      '',
                                      '',
                                      0,
                                      '',
                                      0,
                                      0,
                                      0,
                                      0.0,
                                      0.0,
                                      0.0,
                                      0,
                                      '',
                                      '',
                                      '',
                                      '',
                                      '',
                                      0,
                                      '',
                                    ),
                                    true,
                                    true,
                                  ),
                            );
                          },
                        )
                      : CFreshDashboardScreenView(
                          iconData: Iconsax.tag,
                          label:
                              'your perfect brand awaits! make your first sale...',
                          onTap: () {
                            navController.selectedIndex.value = 1;
                          },
                        ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
