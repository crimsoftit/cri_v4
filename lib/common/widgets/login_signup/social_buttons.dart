import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/img_strings.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/popups/snackbars.dart';
import 'package:flutter/material.dart';

class CSocialButtons extends StatelessWidget {
  const CSocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    //final loginController = Get.put(CLoginController());

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: CColors.grey),
            borderRadius: BorderRadius.circular(100),
          ),
          child: IconButton(
            onPressed: () async {
              // -- check internet connectivity
              // final isConnectedToInternet = await CNetworkManager.instance
              //     .isConnected();
              // if (isConnectedToInternet) {
              //   await loginController.googleSignIn();
              // } else {
              //   CPopupSnackBar.warningSnackBar(
              //     title: 'not connected to internet!',
              //     message: 'login requires an internet connection',
              //   );
              // }
              CPopupSnackBar.warningSnackBar(
                title: 'option not available at the moment!',
                message:
                    'WOOPS... sorry for the inconvenience, this option is '
                    'temporarily disabled.',
              );
            },
            icon: const Image(
              width: CSizes.iconMd,
              height: CSizes.iconMd,
              image: AssetImage(CImages.google),
            ),
          ),
        ),
        const SizedBox(width: CSizes.spaceBtnItems),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: CColors.grey),
            borderRadius: BorderRadius.circular(100),
          ),
          child: IconButton(
            onPressed: () {},
            icon: const Image(
              width: CSizes.iconMd,
              height: CSizes.iconMd,
              image: AssetImage(CImages.fb),
            ),
          ),
        ),
      ],
    );
  }
}
