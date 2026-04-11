import 'package:cri_v3/common/widgets/buttons/icon_buttons/custom_icon_btn.dart';
import 'package:cri_v3/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:cri_v3/common/widgets/shimmers/vert_items_shimmer.dart';
import 'package:cri_v3/features/personalization/controllers/contacts_controller.dart';
import 'package:cri_v3/features/personalization/screens/no_data/no_data_screen.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/img_strings.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:cri_v3/utils/popups/snackbars.dart';
import 'package:cri_v3/utils/validators/validation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CContactsExpansionPanelView extends StatelessWidget {
  const CContactsExpansionPanelView({
    super.key,
    required this.space,
  });

  final String space;

  @override
  Widget build(BuildContext context) {
    final contactsController = Get.put(CContactsController());
    final isDarkTheme = CHelperFunctions.isDarkMode(context);

    return SingleChildScrollView(
      child: Obx(
        () {
          var demContacts = [];

          switch (space) {
            case 'all':
              demContacts.assignAll(contactsController.myContacts);
              break;
            case 'customers':
              demContacts.assignAll(
                contactsController.myContacts.where(
                  (contact) => contact.contactCategory.toLowerCase().contains(
                    'customer'.toLowerCase(),
                  ),
                ),
              );
              break;
            case 'friends':
              demContacts.assignAll(
                contactsController.myContacts.where(
                  (contact) => contact.contactCategory.toLowerCase().contains(
                    'friend'.toLowerCase(),
                  ),
                ),
              );
              break;
            case 'suppliers':
              demContacts.assignAll(
                contactsController.myContacts.where(
                  (contact) => contact.contactCategory.toLowerCase().contains(
                    'supplier'.toLowerCase(),
                  ),
                ),
              );
              break;
            default:
              demContacts.clear();

              if (kDebugMode) {
                CPopupSnackBar.errorSnackBar(
                  message: 'no contacts for this tab space!',
                  title: 'invalid tab space',
                );
              }
          }

          if (demContacts.isEmpty && !contactsController.isLoading.value) {
            return Center(
              child: NoDataScreen(
                lottieImage: CImages.pencilAnimation,
                txt: space == 'all'
                    ? 'All your contacts appear here...'
                    : 'Your $space\' contacts appear here...',
              ),
            );
          }
          if (demContacts.isNotEmpty && contactsController.isLoading.value) {
            return const CVerticalProductShimmer(
              itemCount: 5,
            );
          }
          return Padding(
            padding: const EdgeInsets.only(
              left: 2.0,
              right: 2.0,
              top: 10.0,
            ),
            child: Card(
              color: isDarkTheme
                  ? CColors.rBrown.withValues(
                      alpha: 0.3,
                    )
                  : CColors.lightGrey,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  CSizes.borderRadiusLg,
                ),
                child: ExpansionPanelList.radio(
                  animationDuration: const Duration(
                    milliseconds: 400,
                  ),
                  elevation: 3,
                  expandedHeaderPadding: EdgeInsets.all(
                    2.0,
                  ),
                  // expandIconColor: CNetworkManager.instance.hasConnection.value
                  //     ? CColors.rBrown
                  //     : CColors.darkGrey,
                  expandIconColor: CColors.transparent,
                  expansionCallback: (panelIndex, isExpanded) {
                    if (isExpanded) {
                      // Perform an action when the panel is expanded
                      if (kDebugMode) {
                        print('Panel at index $panelIndex is now expanded');
                      }
                    } else {
                      // Perform an action when the panel is collapsed
                      if (kDebugMode) {
                        print('Panel at index $panelIndex is now collapsed');
                      }
                    }
                  },
                  materialGapSize: 10.0,
                  children: demContacts.map(
                    (contact) {
                      return ExpansionPanelRadio(
                        backgroundColor: isDarkTheme
                            ? CColors.rBrown.withValues(
                                alpha: 0.3,
                              )
                            : CColors.lightGrey,
                        canTapOnHeader: true,
                        highlightColor: CColors.rBrown,
                        headerBuilder: (context, isExpanded) {
                          return ListTile(
                            // contentPadding: const EdgeInsets.only(
                            //   bottom: 2.0,
                            //   left: 5.0,
                            //   right: 5.0,
                            //   top: 2.0,
                            // ),
                            contentPadding: EdgeInsets.fromLTRB(
                              5.0,
                              2.0,
                              5.0,
                              2.0,
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                      CHelperFunctions.randomAstheticColor(),
                                  radius: 20.0,
                                  child:
                                      CValidator.isFirstCharacterALetter(
                                        contact.contactName,
                                      )
                                      ? Text(
                                          contact.contactName[0].toUpperCase(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .apply(
                                                color: CColors.white,
                                              ),
                                        )
                                      : Icon(
                                          Iconsax.user,
                                          color:
                                              CHelperFunctions.randomAstheticColor(),
                                        ),
                                ),
                                const SizedBox(
                                  width: CSizes.spaceBtnItems,
                                ),

                                Text(
                                  contact.contactName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .apply(
                                        fontSizeFactor: 1.1,
                                      ),
                                ),
                              ],
                            ),
                            titleAlignment: ListTileTitleAlignment.top,
                            trailing: SizedBox.shrink(),
                          );
                        },
                        value: contact.contactId,

                        body: Padding(
                          padding: const EdgeInsets.only(
                            bottom: 4.0,
                            left: 61.0,
                            right: 4.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child:
                                    contact.contactPhone == '' ||
                                        contact.contactEmail == ''
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          contact.contactPhone != ''
                                              ? Expanded(
                                                  child: Text(
                                                    'Mobile ${contact.contactPhone}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        Theme.of(
                                                              context,
                                                            )
                                                            .textTheme
                                                            .labelMedium!
                                                            .apply(),
                                                  ),
                                                )
                                              : Expanded(
                                                  child: Text(
                                                    'Email: ${contact.contactEmail}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        Theme.of(
                                                              context,
                                                            )
                                                            .textTheme
                                                            .labelMedium!
                                                            .apply(),
                                                  ),
                                                ),
                                          Expanded(
                                            child: TextButton.icon(
                                              icon: Icon(
                                                Iconsax.edit,
                                                color: isDarkTheme
                                                    ? CColors.white
                                                    : CColors.rBrown,
                                                size: CSizes.iconSm,
                                              ),
                                              label: Text(
                                                contact.contactPhone == ''
                                                    ? 'add phone no.'
                                                    : 'add email',
                                                style:
                                                    Theme.of(
                                                          context,
                                                        ).textTheme.labelMedium!
                                                        .apply(),
                                              ),
                                              onPressed: () {
                                                contactsController
                                                    .addUpdateContactActionModal(
                                                      context,
                                                      contact,
                                                      contact.contactPhone == ''
                                                          ? 'add phone'
                                                          : 'add email',
                                                    );
                                              },
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              'Mobile ${contact.contactPhone}',
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(
                                                context,
                                              ).textTheme.labelMedium!.apply(),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              'Email: ${contact.contactEmail}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(
                                                context,
                                              ).textTheme.labelMedium!.apply(),
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                              const SizedBox(
                                height: CSizes.spaceBtnItems,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton.outlined(
                                    color: CColors.rBrown,
                                    disabledColor: CColors.grey,
                                    focusColor: CColors.grey,
                                    icon: Icon(
                                      Iconsax.call_outgoing,
                                      applyTextScaling: true,
                                      color:
                                          contact.contactPhone == '' &&
                                              isDarkTheme
                                          ? CColors.darkerGrey
                                          : contact.contactPhone == '' &&
                                                !isDarkTheme
                                          ? CColors.grey
                                          : isDarkTheme
                                          ? CColors.white
                                          : CColors.rBrown,
                                      fill: .2,
                                    ),
                                    onPressed: contact.contactPhone != ''
                                        ? () {
                                            contactsController
                                                .launchPhoneDialer(
                                                  contact.contactPhone,
                                                );
                                          }
                                        : null,
                                  ),
                                  IconButton.outlined(
                                    color: CColors.rBrown,
                                    disabledColor: CColors.grey,
                                    focusColor: CColors.grey,

                                    icon: FaIcon(
                                      FontAwesomeIcons.whatsapp,
                                      applyTextScaling: true,
                                      color:
                                          contact.contactPhone == '' &&
                                              isDarkTheme
                                          ? CColors.darkerGrey
                                          : contact.contactPhone == '' &&
                                                !isDarkTheme
                                          ? CColors.grey
                                          : isDarkTheme
                                          ? CColors.white
                                          : CColors.rBrown,
                                      fill: .2,
                                    ),
                                    onPressed: contact.contactPhone == ''
                                        ? null
                                        : () {
                                            contact.contactIsoCode == ''
                                                ? contactsController
                                                      .updateDialCodeDialog(
                                                        context,
                                                        contact,
                                                      )
                                                : contactsController
                                                      .launchWhatsappChat(
                                                        '+${contact.contactIsoCode}${contact.contactPhone}',
                                                      );
                                          },
                                  ),

                                  IconButton.outlined(
                                    color: CColors.rBrown,
                                    disabledColor: CColors.darkGrey,
                                    //focusColor: CColors.rBrown,
                                    icon: Icon(
                                      Iconsax.message,
                                      // color: contact.contactPhone == ''
                                      //     ? CColors.grey
                                      //     : isDarkTheme
                                      //     ? CColors.white
                                      //     : CColors.rBrown,
                                      color:
                                          contact.contactPhone == '' &&
                                              isDarkTheme
                                          ? CColors.darkerGrey
                                          : contact.contactPhone == '' &&
                                                !isDarkTheme
                                          ? CColors.grey
                                          : isDarkTheme
                                          ? CColors.white
                                          : CColors.rBrown,
                                    ),
                                    onPressed: contact.contactPhone != ''
                                        ? () {
                                            contactsController.sendSimpleSms(
                                              [contact.contactPhone],
                                            );
                                          }
                                        : null,
                                  ),

                                  IconButton.outlined(
                                    color: CColors.rBrown,
                                    disabledColor: CColors.darkGrey,

                                    icon: Icon(
                                      Icons.email,

                                      color:
                                          contact.contactEmail == '' &&
                                              isDarkTheme
                                          ? CColors.darkerGrey
                                          : contact.contactEmail == '' &&
                                                !isDarkTheme
                                          ? CColors.grey
                                          : isDarkTheme
                                          ? CColors.white
                                          : CColors.rBrown,
                                    ),
                                    onPressed: contact.contactEmail != ''
                                        ? () {
                                            contactsController.launchEmailApp(
                                              contact.contactEmail,
                                            );
                                          }
                                        : null,
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.info_outlined,
                                      color: isDarkTheme
                                          ? CColors.white
                                          : CColors.rBrown,
                                    ),
                                    onPressed: () {
                                      Get.toNamed(
                                        '/my_contacts/contact_details',
                                        arguments: contact.contactId,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
