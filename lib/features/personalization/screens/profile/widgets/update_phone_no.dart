import 'package:cri_v3/common/widgets/appbar/app_bar.dart';
import 'package:cri_v3/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class CUpdatePhoneNoScreen extends StatelessWidget {
  const CUpdatePhoneNoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // -- header --
            CPrimaryHeaderContainer(
              child: Column(
                children: [
                  // app bar
                  CAppBar(
                    title: Text(
                      'update phone number',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall!.apply(color: CColors.white),
                    ),
                    backIconAction: () {
                      Navigator.pop(context, true);
                      //Get.back();
                    },
                    showBackArrow: true,
                    backIconColor: CColors.white,
                    showSubTitle: true,
                  ),

                  const SizedBox(height: CSizes.spaceBtnSections / 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
