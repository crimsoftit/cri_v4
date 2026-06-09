import 'package:cri_v3/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:cri_v3/features/store/controllers/txns_controller.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class OtherScreensAppBar extends StatelessWidget {
  const OtherScreensAppBar({
    super.key,
    required this.showScanner,
    required this.title,
    required this.trailingIconLeftPadding,
    required this.showBackActionIcon,
    required this.showTrailingIcon,
    this.subTitle,
    this.showSubTitle = false,
  });

  final bool showScanner, showBackActionIcon, showTrailingIcon;
  final bool showSubTitle;
  final String title;
  final double trailingIconLeftPadding;
  final String? subTitle;

  @override
  Widget build(BuildContext context) {
    final salesController = Get.put(CTxnsController());

    return CPrimaryHeaderContainer(
      child: Column(
        children: [
          const SizedBox(height: CSizes.spaceBtnSections),

          // -- ## APP BAR ## --
          Padding(
            padding: const EdgeInsets.all(CSizes.defaultSpace / 2),
            child: Row(
              children: [
                if (showBackActionIcon)
                  Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: CColors.white,
                        size: CSizes.iconSm,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        //Get.back();
                      },
                    ),
                  ),
                Expanded(
                  //padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                  child: Text(
                    title,
                    style: Theme.of(
                      context,
                    ).textTheme.labelLarge!.apply(color: CColors.white),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                if (showSubTitle)
                  Expanded(
                    child: Text(
                      subTitle!,
                      style: Theme.of(
                        context,
                      ).textTheme.labelMedium!.apply(color: CColors.white),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                const SizedBox(width: CSizes.spaceBtnSections),
                showScanner
                    ? IconButton(
                        onPressed: () {
                          salesController.scanItemForSale();
                          // CPopupSnackBar.customToast(
                          //     message:
                          //         salesController.sellItemScanResults.value);
                          Get.toNamed('/sales/sell_item/');
                        },
                        icon: const Icon(Iconsax.scan, color: CColors.white),
                      )
                    : const SizedBox(),
                const SizedBox(width: CSizes.spaceBtnSections),
                showTrailingIcon
                    ? Padding(
                        padding: EdgeInsets.only(left: trailingIconLeftPadding),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Iconsax.notification,
                            color: CColors.white,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),

          const SizedBox(height: CSizes.spaceBtnSections / 2),
        ],
      ),
    );
  }
}
