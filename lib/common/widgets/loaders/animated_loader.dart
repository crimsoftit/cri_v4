import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/helpers/network_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

/// -- a widget for displaying an animated loading indicator with optional text & action button --
class CAnimatedLoaderWidget extends StatelessWidget {
  /// === parameters ===
  ///   - text: text to be displayed below the animation --
  ///   - animation: path to the lottie animation file --
  ///   - showActionBtn: toggles displaying an action button below the text --
  ///   - actionText: text displayed on the action button --
  ///   - onActionPressed: callback function executed onPress of the action button --
  ///
  /// === default constructor for the CAnimationLoaderWidget

  const CAnimatedLoaderWidget({
    super.key,
    required this.text,
    required this.animation,
    this.actionBtnText,
    this.actionBtnWidth = 250.0,
    this.lottieAssetWidth,
    this.onActionBtnPressed,
    this.showActionBtn = false,
    this.txtColor,
  });

  final bool showActionBtn;
  final Color? txtColor;
  final double? actionBtnWidth, lottieAssetWidth;
  final String text, animation;
  final String? actionBtnText;
  final VoidCallback? onActionBtnPressed;

  @override
  Widget build(BuildContext context) {
    //final isDarkTheme = CHelperFunctions.isDarkMode(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            animation,
            width: lottieAssetWidth ?? MediaQuery.of(context).size.width * 0.8,
          ),
          const SizedBox(height: CSizes.defaultSpace),
          Text(
            text,
            style:
                Theme.of(
                  context,
                ).textTheme.bodyMedium!.apply(
                  color: txtColor,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: CSizes.defaultSpace),
          showActionBtn
              ? Obx(() {
                  return SizedBox(
                    width: actionBtnWidth,
                    child: OutlinedButton(
                      onPressed: onActionBtnPressed,
                      style: OutlinedButton.styleFrom(
                        //backgroundColor: CColors.rBrown,
                        backgroundColor:
                            CNetworkManager.instance.hasConnection.value
                            ? CColors.rBrown
                            : CColors.dark,
                      ),
                      child: Text(
                        actionBtnText!,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium!.apply(color: CColors.light),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                })
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
