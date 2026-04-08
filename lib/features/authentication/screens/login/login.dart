import 'package:cri_v3/common/widgets/appbar/app_bar.dart';
import 'package:cri_v3/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:cri_v3/features/authentication/screens/login/widgets/login_form.dart';
import 'package:cri_v3/common/widgets/headers/app_header.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/constants/txt_strings.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:cri_v3/utils/helpers/network_manager.dart' show CNetworkManager;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = CHelperFunctions.isDarkMode(context);

    return CRoundedContainer(
      bgColor: isDarkTheme ? CColors.transparent : CColors.white,
      borderRadius: 0,
      showBorder: false,
      child: Scaffold(
        appBar: CAppBar(
          backIconAction: () {
            SystemNavigator.pop();
          },
          backIconColor: CColors.rBrown,
          horizontalPadding: 0.0,
        ),
        backgroundColor: CColors.rBrown.withValues(alpha: 0.2),
        // backgroundColor: isDarkTheme
        //     ? CColors.rBrown.withValues(alpha: 0.2)
        //     : CColors.lightGrey,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(CSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // -- logo, title, and subtitle --
                AppScreenHeader(
                  includeAfterSpace: false,
                  subTitle: CTexts.loginSubTitle,

                  title: 'Sign in...',
                  // txtColor: isDarkTheme
                  //     ? CColors.darkGrey
                  //     : CNetworkManager.instance.hasConnection.value
                  //     ? CColors.rBrown
                  //     : CColors.darkGrey,
                  txtColor: CNetworkManager.instance.hasConnection.value
                      ? CColors.rBrown
                      : CColors.darkGrey,
                ),

                // -- login form --
                const LoginForm(),

                // -- divider --
                // CFormDivider(
                //   dividerText: CTexts.orSignInWith.capitalize!,
                // ),
                // const SizedBox(
                //   height: CSizes.spaceBtnSections,
                // ),

                // -- footer --
                //const CSocialButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
