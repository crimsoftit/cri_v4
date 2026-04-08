import 'package:cri_v3/features/authentication/screens/login/login.dart';
import 'package:cri_v3/features/authentication/screens/onboarding/onboarding_screen.dart';
import 'package:cri_v3/features/authentication/screens/pswd_config/forgot_password.dart';
import 'package:cri_v3/features/authentication/screens/signup/signup.dart';
import 'package:cri_v3/features/authentication/screens/signup/verify_email.dart';
import 'package:cri_v3/features/personalization/screens/contacts/contacts_screen.dart';
import 'package:cri_v3/features/personalization/screens/contacts/widgets/contact_details/contact_details_screen.dart';
import 'package:cri_v3/features/personalization/screens/profile/profile.dart';
import 'package:cri_v3/features/personalization/screens/settings/user_settings_screen.dart';
import 'package:cri_v3/features/store/screens/home/home.dart';
import 'package:cri_v3/features/store/screens/store_items_tings/checkout/checkout_screen.dart';
import 'package:cri_v3/features/store/screens/store_items_tings/inventory/inventory_details/inv_details.dart';
import 'package:cri_v3/features/store/screens/store_items_tings/store_screen.dart';
import 'package:cri_v3/features/store/screens/txns/sales_screen.dart';
import 'package:cri_v3/features/store/screens/txns/txn_details/sold_item_details.dart';
import 'package:cri_v3/features/store/screens/search/search_results.dart';
import 'package:cri_v3/features/store/screens/txns/sell_item_screen/sell_item_screen.dart';
import 'package:cri_v3/features/store/screens/txns/txns_screen.dart';
import 'package:cri_v3/nav_menu.dart';
import 'package:get/get.dart';

import 'routes.dart';

class CAppRoutes {
  static final pages = [
    GetPage(
      name: CRoutes.landingScreen,
      page: () => const NavMenu(),
    ),

    GetPage(
      name: CRoutes.home,
      page: () => const HomeScreen(),
    ),

    GetPage(
      name: CRoutes.store,
      page: () => const CStoreScreen(),
    ),

    // GetPage(
    //   name: CRoutes.inventory,
    //   page: () => const CInventoryScreen(),
    // ),
    GetPage(
      name: CRoutes.inventoryDetails,
      page: () => const CInvDetails(),
    ),

    GetPage(
      name: CRoutes.sales,
      page: () => const CSalesScreen(),
    ),

    GetPage(
      name: CRoutes.txns,
      page: () => const CTxnsScreen(),
    ),

    GetPage(
      name: CRoutes.sellItemScreen,
      page: () => const CSellItemScreen(),
    ),

    GetPage(
      name: CRoutes.soldItemDetailsScreen,
      page: () => const CSoldItemDetails(),
    ),

    GetPage(
      name: CRoutes.checkoutScreen,
      page: () => const CCheckoutScreen(),
    ),

    GetPage(
      name: CRoutes.settings,
      page: () => const CUserSettingsScreen(),
    ),

    // GetPage(
    //   name: CRoutes.settingsScreenRaw,
    //   page: () => const SettingsScreenRaw(),
    // ),
    GetPage(
      name: CRoutes.userProfile,
      page: () => const CProfileScreen(),
    ),

    GetPage(
      name: CRoutes.signup,
      page: () => const SignupScreen(),
    ),

    GetPage(
      name: CRoutes.verifyEmail,
      page: () => const VerifyEmailScreen(),
    ),

    GetPage(
      name: CRoutes.login,
      page: () => const LoginScreen(),
    ),

    GetPage(
      name: CRoutes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
    ),

    GetPage(
      name: CRoutes.onBoarding,
      page: () => const OnboardingScreen(),
    ),

    GetPage(
      name: CRoutes.searchResults,
      page: () => const CSearchResultsScreen(),
    ),
    GetPage(
      name: CRoutes.contactsScreen,
      page: () {
        return const CContactsScreen();
      },
    ),
    GetPage(
      name: CRoutes.contactDetailsScreen,
      page: () {
        return const CContactDetailsScreen();
      },
    ),
  ];
}
