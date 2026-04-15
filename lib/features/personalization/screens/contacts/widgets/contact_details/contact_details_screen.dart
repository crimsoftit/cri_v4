import 'package:cri_v3/common/widgets/buttons/icon_buttons/custom_icon_btn.dart';
import 'package:cri_v3/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:cri_v3/common/widgets/list_tiles/menu_tile.dart';
import 'package:cri_v3/features/personalization/controllers/contacts_controller.dart';
import 'package:cri_v3/features/personalization/models/contacts_model.dart';
import 'package:cri_v3/features/personalization/screens/contacts/widgets/contact_details/widgets/contact_items_display.dart';
import 'package:cri_v3/features/personalization/screens/profile/profile.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:cri_v3/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CContactDetailsScreen extends StatelessWidget {
  const CContactDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contactsController = Get.put(CContactsController());
    final isDarkTheme = CHelperFunctions.isDarkMode(context);

    var contactId = Get.arguments;

    var contactItem = contactsController.myContacts.firstWhereOrNull(
      (element) => element.contactId == contactId,
    );

    return Container(
      color: isDarkTheme ? CColors.transparent : CColors.white,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          elevation: 1.0,
          shadowColor: CColors.rBrown.withValues(alpha: 0.1),
          iconTheme: IconThemeData(
            color: isDarkTheme ? CColors.white : CColors.rBrown,
          ),
          title: Text(
            '',
            style: Theme.of(context).textTheme.labelMedium!.apply(
              color: isDarkTheme ? CColors.grey : CColors.rBrown,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Iconsax.star,
                color: isDarkTheme ? CColors.white : CColors.rBrown,
                size: CSizes.iconMd,
              ),
            ),
            IconButton(
              onPressed: () {
                contactsController.addUpdateContactActionModal(
                  context,
                  contactItem!,
                  'edit',
                );
              },
              icon: Icon(
                Iconsax.edit,
                color: isDarkTheme ? CColors.white : CColors.rBrown,
                size: CSizes.iconMd,
              ),
            ),

            // IconButton(
            //   onPressed: () {

            //   },
            //   icon: Icon(
            //     Iconsax.notification,
            //     color: isDarkTheme ? CColors.white : CColors.rBrown,
            //   ),
            // ),
          ],
        ),
        backgroundColor: CColors.rBrown.withValues(
          alpha: 0.2,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 10.0,
                      top: 20.0,
                    ),
                    child: CircleAvatar(
                      backgroundColor: CHelperFunctions.randomAstheticColor(),
                      radius: 40.0,
                      child:
                          CValidator.isFirstCharacterALetter(
                            contactItem!.contactName,
                          )
                          ? Text(
                              contactItem.contactName[0].toUpperCase(),
                              style: Theme.of(context).textTheme.bodyLarge!
                                  .apply(
                                    color: CColors.white,
                                    fontSizeFactor: 2.0,
                                  ),
                            )
                          : Icon(
                              Iconsax.user,
                              color: CHelperFunctions.randomAstheticColor(),
                            ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: CSizes.spaceBtnItems,
                ),
                Text(
                  contactItem.contactName,
                  style: Theme.of(context).textTheme.labelLarge!.apply(
                    fontSizeFactor: 2.0,
                  ),
                ),
                const SizedBox(
                  height: CSizes.spaceBtnItems,
                ),
                Padding(
                  padding: const EdgeInsets.all(
                    15.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CCustomIconBtn(
                        height: 40,
                        iconData: Icon(
                          Iconsax.call_outgoing,
                          color: contactItem.contactPhone == ''
                              ? CColors.darkerGrey
                              : isDarkTheme
                              ? CColors.white
                              : CColors.rBrown,
                        ),
                        iconLabel: 'Call',
                        labelColor: contactItem.contactPhone == ''
                            ? CColors.darkerGrey
                            : isDarkTheme
                            ? CColors.white
                            : CColors.rBrown,
                        onTap: contactItem.contactPhone == ''
                            ? null
                            : () {
                                contactsController.launchPhoneDialer(
                                  contactItem.contactPhone,
                                );
                              },
                        width: 55.0,
                      ),

                      CCustomIconBtn(
                        height: 40,
                        iconData: Center(
                          child: FaIcon(
                            FontAwesomeIcons.whatsapp,
                            color: contactItem.contactPhone == ''
                                ? CColors.darkerGrey
                                : isDarkTheme
                                ? CColors.white
                                : CColors.rBrown,
                            size: 24.0,
                          ),
                        ),

                        iconLabel: 'Whatsapp',
                        labelColor: contactItem.contactPhone == ''
                            ? CColors.darkerGrey
                            : isDarkTheme
                            ? CColors.white
                            : CColors.rBrown,
                        onTap: contactItem.contactPhone == ''
                            ? null
                            : () {
                                contactItem.contactIsoCode == ''
                                    ? contactsController.updateDialCodeDialog(
                                        context,
                                        contactItem,
                                      )
                                    : contactsController.launchWhatsappChat(
                                        '+${contactItem.contactIsoCode}${contactItem.contactPhone}',
                                      );
                              },
                        width: 55.0,
                      ),
                      CCustomIconBtn(
                        height: 40,
                        iconData: Icon(
                          Iconsax.message,
                          color: contactItem.contactPhone == ''
                              ? CColors.darkerGrey
                              : isDarkTheme
                              ? CColors.white
                              : CColors.rBrown,
                        ),
                        iconLabel: 'Message',
                        labelColor: contactItem.contactPhone == ''
                            ? CColors.darkerGrey
                            : isDarkTheme
                            ? CColors.white
                            : CColors.rBrown,
                        onTap: contactItem.contactPhone == ''
                            ? null
                            : () {
                                contactsController.sendSimpleSms(
                                  [contactItem.contactPhone],
                                );
                              },
                        width: 55.0,
                      ),

                      CCustomIconBtn(
                        height: 40,
                        iconData: Icon(
                          Icons.email,
                          color: contactItem.contactEmail == ''
                              ? CColors.darkerGrey
                              : isDarkTheme
                              ? CColors.white
                              : CColors.rBrown,
                        ),
                        iconLabel: 'Email',
                        labelColor: contactItem.contactEmail == ''
                            ? CColors.darkerGrey
                            : isDarkTheme
                            ? CColors.white
                            : CColors.rBrown,
                        onTap: contactItem.contactEmail == ''
                            ? null
                            : () {
                                contactsController.launchEmailApp(
                                  contactItem.contactEmail,
                                );
                              },
                        width: 55.0,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: CSizes.spaceBtnItems,
                ),

                /// -- phone number display --
                CMenuTile(
                  bgColor: CColors.rBrown.withValues(
                    alpha: .2,
                  ),
                  containerWidth: CHelperFunctions.screenWidth() * .855,
                  displayTrailingWidget: true,

                  leadingWidget: IconButton(
                    icon: Icon(
                      contactItem.contactPhone == ''
                          ? Iconsax.call_add
                          : Iconsax.call,
                      color: contactItem.contactPhone != ''
                          ? CColors.rBrown
                          : CColors.rOrange,
                      size: CSizes.iconMd,
                    ),
                    onPressed: contactItem.contactPhone == ''
                        ? null
                        : () {
                            contactsController.launchPhoneDialer(
                              contactItem.contactPhone,
                            );
                          },
                  ),
                  onTap: contactItem.contactPhone == ''
                      ? () {
                          contactsController.addUpdateContactActionModal(
                            context,
                            contactItem,
                            'add phone',
                          );
                        }
                      : null,
                  subTitle: contactItem.contactPhone != '' ? 'Mobile' : '',
                  title:
                      contactItemintl.contactPhone != '' &&
                          contactItem.contactCountryCode != ''
                      ? '${contactItem.contactCountryCode} ${contactItem.contactPhone}'
                      : contactItem.contactPhone != '' &&
                            contactItem.contactCountryCode == ''
                      ? contactItem.contactPhone
                      : 'Add phone number',
                  titleMaxLines: 1,
                  titleStyle: Theme.of(context).textTheme.headlineMedium!.apply(
                    color: contactItem.contactPhone == ''
                        ? CColors.rOrange
                        : CColors.rBrown,
                  ),
                  titleTopPadding: contactItem.contactPhone != '' ? 0 : 12.0,

                  trailing: contactItem.contactPhone != ''
                      ? IconButton(
                          icon: Icon(
                            Iconsax.message,
                            color: contactItem.contactPhone != ''
                                ? CColors.rBrown
                                : CColors.rOrange,
                            size: CSizes.iconMd,
                          ),
                          onPressed: contactItem.contactPhone == ''
                              ? null
                              : () {
                                  contactsController.sendSimpleSms(
                                    [contactItem.contactPhone],
                                  );
                                },
                        )
                      : SizedBox.shrink(),
                  useCustomLeadingWiget: true,
                ),

                const SizedBox(
                  height: CSizes.spaceBtnItems / 3.0,
                ),

                // CContactItemsDisplay(
                //   contactItem: contactItem,

                //   includeTrailingWidget: false,
                //   leadingIcon: Icon(
                //     Icons.email,
                //     color: contactItem.contactEmail != ''
                //         ? CColors.rBrown
                //         : CColors.rOrange,
                //     size: CSizes.iconMd,
                //   ),
                //   onLeadingIconPressed: contactItem.contactEmail == ''
                //       ? null
                //       : () {
                //           contactsController.launchEmailApp(
                //             contactItem.contactEmail,
                //           );
                //         },
                //   subTitleWidget: contactItem.contactEmail != ''
                //       ? Text(
                //           'Email',
                //           style:
                //               Theme.of(
                //                 context,
                //               ).textTheme.labelMedium!.apply(
                //                 color: contactItem.contactEmail != ''
                //                     ? CColors.rBrown
                //                     : CColors.rOrange,
                //                 fontSizeDelta: .8,
                //               ),
                //         )
                //       : SizedBox.shrink(),
                //   title: contactItem.contactEmail != ''
                //       ? contactItem.contactEmail
                //       : 'Add email',
                //   titleColor: contactItem.contactEmail == ''
                //       ? CColors.rOrange
                //       : CColors.rBrown,
                //   titleTopPadding: contactItem.contactEmail != '' ? 10.0 : 13.0,
                //   trailingIcon: SizedBox(),
                // ),

                // const SizedBox(
                //   height: CSizes.spaceBtnItems / 3.0,
                // ),
                /// -- email address display --
                CMenuTile(
                  bgColor: CColors.rBrown.withValues(
                    alpha: .2,
                  ),
                  containerWidth: CHelperFunctions.screenWidth() * .855,
                  displayTrailingWidget: false,
                  icon: Iconsax.user_edit,
                  leadingWidget: IconButton(
                    icon: Icon(
                      Icons.email,
                      color: contactItem.contactEmail != ''
                          ? CColors.rBrown
                          : CColors.rOrange,
                      size: CSizes.iconMd,
                    ),
                    onPressed: contactItem.contactEmail == ''
                        ? null
                        : () {
                            contactsController.launchEmailApp(
                              contactItem.contactEmail,
                            );
                          },
                  ),
                  onTap: () {},
                  subTitle: contactItem.contactEmail != '' ? 'Email' : '',
                  title: contactItem.contactEmail != ''
                      ? contactItem.contactEmail
                      : 'Add email',
                  titleMaxLines: 1,
                  titleStyle: Theme.of(context).textTheme.headlineMedium!.apply(
                    color: contactItem.contactEmail == ''
                        ? CColors.rOrange
                        : CColors.rBrown,
                    fontSizeFactor: contactItem.contactEmail != '' ? .85 : 1.0,
                  ),
                  titleTopPadding: contactItem.contactEmail != '' ? 0 : 12.0,

                  // trailing: IconButton(
                  //   onPressed: () {
                  //     Get.to(() => const CProfileScreen());
                  //   },
                  //   icon: const Icon(
                  //     Iconsax.arrow_right,
                  //   ),
                  // ),
                  useCustomLeadingWiget: true,
                ),
                Text(
                  'country code: ${contactItem.contactCountryCode}',
                  style: Theme.of(context).textTheme.labelLarge!.apply(
                    fontSizeFactor: 1.0,
                  ),
                ),
                Text(
                  'iso code: ${contactItem.contactIsoCode}',
                  style: Theme.of(context).textTheme.labelLarge!.apply(
                    fontSizeFactor: 1.0,
                    color: CColors.white,
                  ),
                ),
                Text(
                  'last modified: ${contactItem.lastModified}',
                  style: Theme.of(context).textTheme.labelLarge!.apply(
                    fontSizeFactor: 1.0,
                    color: CColors.white,
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
