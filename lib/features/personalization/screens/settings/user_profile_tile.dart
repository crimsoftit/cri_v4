import 'package:cri_v3/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:cri_v3/common/widgets/img_widgets/c_circular_img.dart';
import 'package:cri_v3/common/widgets/shimmers/shimmer_effects.dart';
import 'package:cri_v3/features/personalization/controllers/user_controller.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/img_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CUserProfileTile extends StatelessWidget {
  const CUserProfileTile({super.key, required this.onEditBtnPressed});

  final VoidCallback onEditBtnPressed;

  @override
  Widget build(BuildContext context) {
    //final currentUser = FirebaseAuth.instance.currentUser;
    final userController = Get.put(CUserController());

    return ListTile(
      leading: CRoundedContainer(
        showBorder: true,
        borderRadius: 120,
        borderColor: CColors.rBrown.withValues(alpha: 0.3),
        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
        child: Stack(
          children: [
            Obx(() {
              final networkImg = userController.user.value.profPic;

              final dpImg = networkImg.isNotEmpty ? networkImg : CImages.user;

              return CCircularImg(
                img: dpImg,
                width: 47.0,
                height: 47.0,
                isNetworkImg: networkImg.isNotEmpty,
                //padding: 10.0,
              );
            }),
          ],
        ),
      ),
      title: Obx(() {
        if (userController.profileLoading.value) {
          // -- display a shimmer loader effect while loading user profile
          return const CShimmerEffect(width: 80.0, height: 15.0);
        } else {
          return Text(
            userController.user.value.email,
            style: Theme.of(
              context,
            ).textTheme.labelMedium!.apply(color: CColors.grey),
          );
        }
      }),
      subtitle: Obx(() {
        if (userController.profileLoading.value) {
          return const CShimmerEffect(width: 80.0, height: 15.0);
        } else {
          return Text(
            userController.user.value.businessName.isNotEmpty
                ? userController.user.value.businessName
                : userController.user.value.fullName,
            style: Theme.of(context).textTheme.labelLarge!.apply(
              // color: CNetworkManager.instance.hasConnection.value
              //     ? CColors.rBrown
              //     : CColors.darkGrey,
              fontSizeFactor: .8,
              fontWeightDelta: -7,
            ),
          );
        }
      }),
      trailing: IconButton(
        onPressed: onEditBtnPressed,
        icon: const Icon(Iconsax.edit, color: CColors.white),
      ),
    );
  }
}
