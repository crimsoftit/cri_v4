import 'package:cri_v3/common/widgets/appbar/v2_app_bar.dart';
import 'package:cri_v3/common/widgets/dividers/c_divider.dart' show CDivider;
import 'package:cri_v3/common/widgets/list_tiles/menu_tile.dart';
import 'package:cri_v3/common/widgets/txt_widgets/c_section_headings.dart';
import 'package:cri_v3/features/personalization/controllers/user_controller.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:cri_v3/utils/helpers/network_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CPaymentPlatforms extends StatelessWidget {
  const CPaymentPlatforms({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    final userController = Get.put(CUserController());

    return Container(
      color: isDarkTheme ? CColors.transparent : CColors.white,
      child: Scaffold(
        appBar: CVersion2AppBar(autoImplyLeading: true, displayMenuIcon: false),
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
                    color: CNetworkManager.instance.hasConnection.value
                        ? CColors.rBrown
                        : CColors.darkGrey,
                  ),
                ),
                Text(
                  userController.user.value.fullName.split(" ").elementAt(0),
                  style: Theme.of(context).textTheme.labelLarge!.apply(
                    color: CNetworkManager.instance.hasConnection.value
                        ? CColors.rBrown
                        : CColors.darkGrey,
                    fontSizeFactor: 2.5,
                    fontWeightDelta: -7,
                  ),
                ),
                CDivider(endIndent: 270.0, startIndent: 0),
                const SizedBox(height: CSizes.spaceBtnItems),
                const CSectionHeading(
                  showActionBtn: false,
                  title: 'payment methods/accounts',
                  btnTitle: '',
                  editFontSize: false,
                ),

                /// -- mpesa express --
                CMenuTile(
                  icon: Iconsax.money,
                  title: 'mpesa express',
                  subTitle: 'set your lipa na mpesa paybill/business number',
                  trailing: IconButton(
                    onPressed: () {},
                    icon: const Icon(Iconsax.arrow_right),
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
