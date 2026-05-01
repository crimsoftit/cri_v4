import 'dart:io';

import 'package:clock/clock.dart';
import 'package:cri_v3/api/sheets/store_sheets_api.dart';
import 'package:cri_v3/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:cri_v3/common/widgets/flushbars/flushbars.dart';
import 'package:cri_v3/common/widgets/txt_fields/custom_type_ahead_field.dart';
import 'package:cri_v3/features/personalization/controllers/user_controller.dart';
import 'package:cri_v3/features/personalization/models/contacts_model.dart';
import 'package:cri_v3/features/store/controllers/inv_controller.dart';
import 'package:cri_v3/features/store/controllers/nav_menu_controller.dart';
import 'package:cri_v3/nav_menu.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/db/sqflite/db_helper.dart';
import 'package:cri_v3/utils/helpers/formatter.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:cri_v3/utils/helpers/network_manager.dart';
import 'package:cri_v3/utils/popups/snackbars.dart';
import 'package:cri_v3/utils/validators/validation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:send_message/send_message.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CContactsController extends GetxController {
  /// -- constructor --
  static CContactsController get instance => Get.find();

  /// -- variables --
  DbHelper dbHelper = DbHelper.instance;
  final invController = Get.put(CInventoryController());

  final localStorage = GetStorage();

  final updateContactItemFormKey = GlobalKey<FormState>();
  final userController = Get.put(CUserController());

  final txtEmailController = TextEditingController();
  final txtContactNameController = TextEditingController();
  final txtPhoneController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool processingContactsSync = false.obs;
  final RxBool undoTrashBtnPressed = false.obs;

  final RxList<CContactsModel> allCloudContacts = <CContactsModel>[].obs;
  final RxList<CContactsModel> userCloudContacts = <CContactsModel>[].obs;
  final RxList<CContactsModel> foundMatches = <CContactsModel>[].obs;
  final RxList<CContactsModel> myContacts = <CContactsModel>[].obs;
  final RxList<CContactsModel> trashedContacts = <CContactsModel>[].obs;
  final RxList<CContactsModel> unsyncedContactAppends = <CContactsModel>[].obs;
  final RxList<CContactsModel> unsyncedContactUpdates = <CContactsModel>[].obs;

  final RxString contactCountryCode = 'KE'.obs;
  final RxString contactDialCode = '254'.obs;

  @override
  void onInit() async {
    foundMatches.value = [];
    isLoading.value = false;
    processingContactsSync.value = false;
    undoTrashBtnPressed.value = false;
    await fetchMyContacts();
    await initContactsSync();
    super.onInit();
  }

  /// -- initialize cloud sync --
  initContactsSync() async {
    if (localStorage.read('SyncContactsWithCloud') == true) {
      await importContacts();
      if (await importContacts()) {
        localStorage.write('SyncContactsWithCloud', false);
      } else {
        localStorage.write('SyncContactsWithCloud', true);
      }
    }
  }

  /// -- check if contact details exist in the database --
  Future<bool> contactActionIsAdd(
    String contactName,
    String contactDetails,
  ) async {
    try {
      bool addContact = false;
      List<CContactsModel> contactMatches = [];
      await fetchMyContacts().then(
        (results) {
          switch (results.isNotEmpty) {
            case true:
              contactMatches = myContacts
                  .where(
                    (match) =>
                        match.contactEmail.toLowerCase().contains(
                          contactDetails.toLowerCase(),
                        ) ||
                        match.contactPhone.toLowerCase().contains(
                          contactDetails.toLowerCase(),
                        ),
                  )
                  .toList();
              if (contactMatches.isNotEmpty) {
                addContact = false;
              } else {
                addContact = true;
              }
              break;

            default:
              contactMatches = [];
              addContact = true;
              break;
          }
        },
      );

      return addContact;
    } catch (e) {
      if (kDebugMode) {
        print('error checking contact existence: $e');
        CPopupSnackBar.errorSnackBar(
          message: 'error checking contact existence: $e',
          title: 'error checking contact existence!',
        );
      }
      rethrow;
    }
  }

  /// -- add a contact to the local database --
  Future addContact(
    bool fromInventoryDetails,
    CContactsModel? contact,
    int? productId,
  ) async {
    try {
      // -- extract dial code from phone number
      final (dialCode, mobileNumber) =
          CValidator.isValidPhoneNumber(
            invController.txtSupplierContacts.text.trim(),
          )
          ? CFormatter.seperatePhoneAndDialCode(
              invController.txtSupplierContacts.text.trim(),
            )
          : ('', '');

      var contactDetails = CContactsModel(
        userController.user.value.email,
        productId,
        fromInventoryDetails
            ? invController.txtSupplierName.text.trim()
            : contact!.contactName,

        fromInventoryDetails ? '' : contact!.contactCountryCode,
        fromInventoryDetails ? dialCode : '',
        fromInventoryDetails &&
                CValidator.isValidPhoneNumber(
                  invController.txtSupplierContacts.text.trim(),
                )
            ? mobileNumber
            : fromInventoryDetails &&
                  !CValidator.isValidPhoneNumber(
                    invController.txtSupplierContacts.text.trim(),
                  )
            ? ''
            : contact!.contactPhone,
        fromInventoryDetails &&
                CValidator.isValidEmail(
                  invController.txtSupplierContacts.text.trim(),
                )
            ? invController.txtSupplierContacts.text.trim()
            : fromInventoryDetails &&
                  !CValidator.isValidEmail(
                    invController.txtSupplierContacts.text.trim(),
                  )
            ? ''
            : contact!.contactEmail,
        fromInventoryDetails ? 'supplier' : contact!.contactCategory,
        fromInventoryDetails
            ? DateFormat(
                'yyyy-MM-dd kk:mm',
              ).format(clock.now())
            : contact!.lastModified,
        fromInventoryDetails
            ? DateFormat('yyyy-MM-dd kk:mm').format(clock.now())
            : contact!.createdAt,
        0,
        'append',
        0,
        0,
      );

      await dbHelper.addContact(contact ?? contactDetails);

      if (kDebugMode) {
        print(
          '${contactDetails.contactName} ${contactDetails.contactPhone} ${contactDetails.contactEmail} added successfully',
        );
        CPopupSnackBar.successSnackBar(
          message:
              '${contactDetails.contactName} ${contactDetails.contactPhone} ${contactDetails.contactEmail} added successfully',
          title: 'contact added',
        );
      }
      fetchMyContacts();
    } catch (e) {
      if (kDebugMode) {
        print('error adding contact: $e');
        CPopupSnackBar.errorSnackBar(
          message: 'an error occurred while adding contact: $e',
          title: 'error adding contact!',
        );
      }
      rethrow;
    }
  }

  /// -- fetch contacts from sqflite db --
  Future<List<CContactsModel>> fetchMyContacts() async {
    try {
      // start loader while contacts are fetched
      isLoading.value = true;

      myContacts.clear();

      final fetchedContacts = await dbHelper.fetchUserContacts(
        userController.user.value.email,
      );
      myContacts.assignAll(fetchedContacts);

      unsyncedContactAppends.assignAll(
        fetchedContacts
            .where(
              (unsyncedAppend) =>
                  unsyncedAppend.isSynced == 0 &&
                  unsyncedAppend.syncAction == 'append',
            )
            .toList(),
      );

      unsyncedContactUpdates.assignAll(
        fetchedContacts
            .where(
              (unsyncedUpdate) =>
                  unsyncedUpdate.isSynced == 1 &&
                  unsyncedUpdate.syncAction.toLowerCase().contains(
                    'update'.toLowerCase(),
                  ),
            )
            .toList(),
      );

      List<CContactsModel> returnItems;

      switch (myContacts.isEmpty) {
        case true:
          returnItems = [];
          break;
        case false:
          returnItems = myContacts;
          break;
      }

      // stop loader
      isLoading.value = false;
      return returnItems;
    } catch (e) {
      // stop loader
      isLoading.value = false;
      if (kDebugMode) {
        print('error fetching contacts: $e');
        CPopupSnackBar.errorSnackBar(
          message: 'an error occurred while fetching contacts: $e',
          title: 'error fetching contacts!',
        );
      }
      rethrow;
    }
  }

  Future<List<CContactsModel>> getContactSuggestion(String query) async {
    try {
      List<CContactsModel> contactMatches = [];
      await fetchMyContacts();

      contactMatches.addAll(myContacts);
      contactMatches.retainWhere(
        (contact) {
          return contact.contactName.toLowerCase().contains(
                query.toLowerCase(),
              ) ||
              contact.contactPhone.toLowerCase().contains(
                query.toLowerCase(),
              ) ||
              contact.contactEmail.toLowerCase().contains(
                query.toLowerCase(),
              );
        },
      );
      return contactMatches;
    } catch (e) {
      if (kDebugMode) {
        print('error fetching contact suggestions: $e');
        CPopupSnackBar.errorSnackBar(
          message: 'error fetching contact suggestions: $e',
          title: 'error fetching contact suggestions!',
        );
      }
      rethrow;
    }
  }

  contactSuggestionsCallBackAction(String pattern) {
    foundMatches.clear;
    foundMatches.value = myContacts
        .where(
          (contact) =>
              contact.contactName.toLowerCase().contains(
                pattern.toLowerCase(),
              ) ||
              contact.contactPhone.toLowerCase().contains(
                pattern.toLowerCase(),
              ) ||
              contact.contactEmail.toLowerCase().contains(
                pattern.toLowerCase(),
              ),
        )
        .toList();

    return foundMatches;
  }

  /// -- update contact details --
  Future<bool> updateContact(CContactsModel contact) async {
    try {
      // --  start loader --
      isLoading.value = true;

      await dbHelper.updateContact(contact);

      fetchMyContacts();

      // -- stop loader --
      isLoading.value = false;

      return true;
    } catch (e) {
      // -- stop loader --
      isLoading.value = false;
      if (kDebugMode) {
        print('error updating contact: $e');
        CPopupSnackBar.errorSnackBar(
          message: 'error updating contact: $e',
          title: 'error updating contact!',
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          message: 'an unknown error occurred while updating contact details!',
          title: 'error updating contact!',
        );
      }
      rethrow;
    }
  }

  Future<dynamic> addUpdateContactActionModal(
    BuildContext context,
    CContactsModel? contactItem,
    String updateAction,
  ) async {
    try {
      final isDarkTheme = CHelperFunctions.isDarkMode(context);
      return showModalBottomSheet(
        backgroundColor: isDarkTheme
            ? CColors.black.withValues(
                alpha: .9,
              )
            : CColors.white,
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        useSafeArea: true,
        useRootNavigator: true,
        builder: (context) {
          // -- set field values --
          contactCountryCode.value = contactItem!.contactCountryCode != ''
              ? contactItem.contactCountryCode
              : contactCountryCode.value;
          contactDialCode.value = contactItem.contactDialCode != ''
              ? contactItem.contactDialCode
              : contactDialCode.value;
          txtEmailController.text = txtEmailController.text == ''
              ? contactItem.contactEmail
              : txtEmailController.text.trim();
          txtContactNameController.text =
              txtContactNameController.text.trim() == ''
              ? contactItem.contactName
              : txtContactNameController.text.trim();
          txtPhoneController.text = txtPhoneController.text == ''
              ? contactItem.contactPhone
              : txtPhoneController.text.trim();

          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: CRoundedContainer(
              bgColor: CColors.transparent,
              height: updateAction.toLowerCase() == 'edit'.toLowerCase()
                  ? CHelperFunctions.screenHeight() * .51
                  : CHelperFunctions.screenHeight() * .39,
              //height: CHelperFunctions.screenHeight() * .49,
              padding: const EdgeInsets.all(
                CSizes.lg / 3,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor:
                            CHelperFunctions.randomAestheticColor(),
                        radius: 20.0,
                        child:
                            CValidator.isFirstCharacterALetter(
                              contactItem.contactName,
                            )
                            ? Text(
                                contactItem.contactName[0].toUpperCase(),
                                style: Theme.of(context).textTheme.bodyLarge!
                                    .apply(
                                      color: CColors.white,
                                    ),
                              )
                            : Icon(
                                Iconsax.user,
                                color: CHelperFunctions.randomAestheticColor(),
                              ),
                      ),
                      const SizedBox(
                        width: CSizes.spaceBtnItems / 2.0,
                      ),
                      Text(
                        contactItem.contactName.toUpperCase(),
                        style: Theme.of(
                          context,
                        ).textTheme.headlineMedium!.apply(),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 30.0,
                      right: 30.0,
                      top: 30.0,
                    ),
                    child: Form(
                      key: updateContactItemFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Visibility(
                            maintainState: false,
                            visible:
                                updateAction.toLowerCase() ==
                                'edit'.toLowerCase(),
                            child: Column(
                              children: [
                                TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: txtContactNameController,
                                  decoration: InputDecoration(
                                    constraints: BoxConstraints(
                                      minHeight: 60.0,
                                    ),
                                    filled: true,
                                    fillColor: isDarkTheme
                                        ? CColors.transparent
                                        : CColors.lightGrey,
                                    labelText: 'Name',
                                    labelStyle: Theme.of(
                                      context,
                                    ).textTheme.labelSmall,
                                    prefixIcon: Icon(
                                      Iconsax.tag,
                                      color: CColors.darkGrey,
                                      size: CSizes.iconXs,
                                    ),
                                  ),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                  ),
                                  validator:
                                      updateAction.toLowerCase() == 'edit'
                                      ? (value) {
                                          return CValidator.validateEmptyText(
                                            'Name',
                                            value,
                                          );
                                        }
                                      : null,
                                ),
                                const SizedBox(
                                  height: CSizes.spaceBtnInputFields,
                                ),
                              ],
                            ),
                          ),

                          CCustomTypeaheadField(
                            fieldValidator: updateAction == 'add email'
                                ? (value) {
                                    return CValidator.validateEmail(value);
                                  }
                                : null,
                            fillColor: isDarkTheme
                                ? CColors.transparent
                                : CColors.lightGrey,
                            focusedBorderColor: isDarkTheme
                                ? CColors.white
                                : CColors.rBrown,
                            includeAvatarOnSuggestion: true,
                            includePrefixIcon: true,
                            labelTxt: 'E-mail address',
                            onFieldValueChanged: (value) {
                              txtEmailController.text = value.trim();
                            },
                            onItemSelected: (suggestion) {
                              txtEmailController.text = suggestion.contactEmail;
                            },
                            prefixIcon: Icon(
                              Icons.contact_mail,
                              color: CColors.darkGrey,
                              size: CSizes.iconXs,
                            ),
                            typeAheadFieldController: txtEmailController,
                          ),

                          const SizedBox(
                            height: CSizes.spaceBtnInputFields,
                          ),

                          // CInternationalPhoneNumberInput(
                          //   controller: txtPhoneController,
                          // ),

                          // const SizedBox(
                          //   height: CSizes.spaceBtnInputFields,
                          // ),
                          IntlPhoneField(
                            controller: txtPhoneController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              fillColor: isDarkTheme
                                  ? CColors.transparent
                                  : CColors.lightGrey,
                              labelText: 'Phone number',
                            ),
                            // Default country code (e.g., India)
                            // initialCountryCode: contactItem.contactIsoCode != ''
                            //     ? contactItem.contactIsoCode
                            //     : 'UG',
                            initialCountryCode:
                                contactItem.contactCountryCode != ''
                                ? contactItem.contactCountryCode
                                : 'KE',
                            invalidNumberMessage: 'Invalid phone number!',
                            onChanged: (phone) {
                              contactCountryCode.value = phone.countryISOCode;

                              contactDialCode.value = phone.countryCode;

                              if (kDebugMode) {
                                print('=========\n');
                                print('country code: ${phone.countryCode}\n');
                                print('---------\n');
                                print(
                                  'country iso code: ${phone.countryISOCode}\n',
                                );
                                print('---------\n');
                                print(
                                  'complete number: ${phone.completeNumber}\n',
                                );
                                print('=========\n');
                              }
                            },
                            onCountryChanged: (country) {
                              contactCountryCode.value = country.code;

                              contactDialCode.value = country.dialCode;

                              if (kDebugMode) {
                                print('=========\n');
                                print('country code: ${country.code}\n');
                                print('---------\n');
                                print(
                                  'dial code: ${country.dialCode}',
                                );
                                print('---------\n');
                                print(
                                  'full country code: ${country.fullCountryCode}\n',
                                );
                                print('=========\n');
                              }
                            },
                          ),
                          const SizedBox(
                            height: CSizes.spaceBtnInputFields,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 4,
                                child: TextButton.icon(
                                  icon: Icon(
                                    Iconsax.save_add,
                                    size: CSizes.iconSm,
                                    color: isDarkTheme
                                        ? CColors.rBrown
                                        : CColors.white,
                                  ),
                                  label: Text(
                                    'Update',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .apply(
                                          color: isDarkTheme
                                              ? CColors.rBrown
                                              : CColors.white,
                                        ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: CColors
                                        .white, // foreground (text) color
                                    backgroundColor: isDarkTheme
                                        ? CColors.white
                                        : CColors.rBrown, // background color
                                  ),
                                  onPressed: () async {
                                    // -- form validation
                                    if (!updateContactItemFormKey.currentState!
                                        .validate()) {
                                      return;
                                    }

                                    if (kDebugMode) {
                                      print('<<< safi >>>\n');
                                      print('radaree kaka...');
                                      print('<<< safi >>>\n');
                                    }
                                    contactItem.contactCountryCode =
                                        contactItem.contactCountryCode == ''
                                        ? contactCountryCode.value
                                        : contactItem.contactCountryCode;
                                    contactItem.contactDialCode =
                                        contactItem.contactDialCode == ''
                                        ? contactDialCode.value
                                        : contactItem.contactDialCode;
                                    contactItem.contactPhone =
                                        txtPhoneController.text.trim();
                                    contactItem.contactEmail =
                                        txtEmailController.text.trim();
                                    contactItem.contactName =
                                        txtContactNameController.text.trim() !=
                                                '' &&
                                            updateAction == 'edit'
                                        ? txtContactNameController.text.trim()
                                        : contactItem.contactName;
                                    contactItem.lastModified = DateFormat(
                                      'yyyy-MM-dd kk:mm',
                                    ).format(clock.now());

                                    if (await updateContact(contactItem)) {
                                      resetFields();
                                      Navigator.pop(
                                        Get.overlayContext!,
                                        true,
                                      );
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: CSizes.spaceBtnSections / 4,
                              ),
                              Expanded(
                                flex: 4,
                                child: TextButton.icon(
                                  icon: const Icon(
                                    Iconsax.undo,
                                    size: CSizes.iconSm,
                                    color: CColors.rBrown,
                                  ),
                                  label: Text(
                                    'Back',
                                    style:
                                        Theme.of(
                                          context,
                                        ).textTheme.labelMedium!.apply(
                                          color: CColors.rBrown,
                                        ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: CColors
                                        .rBrown, // foreground (text) color
                                    backgroundColor:
                                        CColors.white, // background color
                                  ),
                                  onPressed: () {
                                    //Navigator.pop(context, true);

                                    resetFields();
                                    Navigator.pop(
                                      Get.overlayContext!,
                                      true,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print('error displaying bottom sheet modal: $e');
        CPopupSnackBar.errorSnackBar(
          message: 'error displaying bottom sheet modal: $e',
          title: 'error popping bottom sheet modal!',
        );
      }
      rethrow;
    }
  }

  /// -- restore trashed contact --
  restoreTrashedContact(CContactsModel trashedItem) async {
    try {
      trashedItem.isTrashed = 0;
      trashedItem.lastModified = DateFormat(
        'yyyy-MM-dd kk:mm',
      ).format(clock.now());
      trashedItem.syncAction = trashedItem.isSynced == 1 ? 'update' : 'append';
      await updateContact(trashedItem);
    } catch (e) {
      if (kDebugMode) {
        print('error restoring contact: $e');
        CPopupSnackBar.errorSnackBar(
          message: 'error restoring contact from trash bin: $e',
          title: 'error restoring contact!',
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          message: 'error restoring contact from trash bin: $e',
          title: 'error restoring contact!',
        );
      }
      rethrow;
    }
  }

  /// -- delete contact dialog --
  onDeleteContactDialog(CContactsModel contact) async {
    try {
      Get.defaultDialog(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: CHelperFunctions.randomAestheticColor(),
              radius: 30.0,
              child:
                  CValidator.isFirstCharacterALetter(
                    contact.contactName,
                  )
                  ? Text(
                      contact.contactName[0].toUpperCase(),
                      style: Theme.of(Get.overlayContext!).textTheme.bodyLarge!
                          .apply(
                            color: CColors.white,
                            fontSizeFactor: 1.5,
                          ),
                    )
                  : Icon(
                      Iconsax.user,
                      color: CHelperFunctions.randomAestheticColor(),
                    ),
            ),
            const SizedBox(
              height: CSizes.spaceBtnSections,
            ),
            Text(
              contact.contactName,
              style: Theme.of(Get.overlayContext!).textTheme.bodyMedium!.apply(
                fontSizeFactor: 1.3,
                fontWeightDelta: 2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: CSizes.spaceBtnItems,
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text:
                        'Are you certain you want to permanently delete this contact?',
                  ),
                  TextSpan(
                    text: '\n\nTHIS ACTION CAN\'T BE UNDONE!',
                    style: Theme.of(Get.overlayContext!).textTheme.labelMedium!
                        .apply(
                          fontSizeFactor: 1.5,
                          fontWeightDelta: 2,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
        contentPadding: const EdgeInsets.all(
          CSizes.md,
        ),

        confirm: ElevatedButton(
          onPressed: () async {
            // -- check internet connectivity
            // final isConnected = CNetworkManager.instance.hasConnection.value;

            // await dbHelper.deleteContact(contact);

            // Navigator.of(Get.overlayContext!).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            side: const BorderSide(
              color: Colors.red,
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: CSizes.lg,
            ),
            child: Text(
              'Delete anyway',
            ),
          ),
        ),
        cancel: OutlinedButton(
          onPressed: () {
            fetchMyContacts();
            Navigator.of(Get.overlayContext!).pop();
          },
          child: const Text('Cancel'),
        ),

        title: 'Delete contact?',
      );
    } catch (e) {
      if (kDebugMode) {
        print('error displaying bottom sheet modal: $e');
        CPopupSnackBar.errorSnackBar(
          message: 'An unknown error occurred while deleting contact: $e',
          title: 'error deleting contact!',
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          message:
              'An unknown error occurred while deleting contact! Please try again later...',
          title: 'error deleting contact!',
        );
      }
      rethrow;
    }
  }

  Future<void> sendSimpleSms(List<String> recipients) async {
    String message = "hi,";
    try {
      String result = await sendSMS(
        message: message,
        recipients: recipients,
      );
      if (kDebugMode) {
        print("Messages launched: $result");
        // CPopupSnackBar.successSnackBar(
        //   message: result,
        //   title: 'Messages launched!',
        // );
      }
    } catch (error) {
      if (kDebugMode) {
        print("Error: $error");
        CPopupSnackBar.errorSnackBar(
          message: 'error sending simple sms: $error',
          title: 'error sending simple sms!',
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          message: 'an unknown error occurred while sending sms!',
          title: 'error sending sms!',
        );
      }
      rethrow;
    }
  }

  Future<void> sendDirectSms() async {
    String message = "Test message!";
    List<String> recipients = ["1234567890", "5556787676"];

    try {
      String result = await sendSMS(
        message: message,
        recipients: recipients,
        sendDirect: true, // Skips confirmation dialog (Android only)
      );
      if (kDebugMode) {
        print("Direct SMS sent: $result");
      }
    } catch (error) {
      if (kDebugMode) {
        print("Error: $error");
      }
      rethrow;
    }
  }

  /// -- open native dialer (make a call) --
  Future<void> launchPhoneDialer(String phoneNumber) async {
    try {
      final Uri phoneUri = Uri(
        path: phoneNumber,
        scheme: 'tel',
      );

      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        CPopupSnackBar.customToast(
          forInternetConnectivityStatus: false,
          message: 'could not launch $phoneUri',
        );
        throw 'could not launch $phoneUri';
      }
    } catch (e) {
      if (kDebugMode) {
        print('error launching dialer: $e');
        CPopupSnackBar.errorSnackBar(
          message: 'error launching dialer: $e',
          title: 'error launching dialer',
        );
      }
      rethrow;
    }
  }

  Future<void> sendEmail(String emailAddress) async {
    try {
      final Email email = Email(
        body: 'This is the email body',
        subject: 'Test Subject',
        recipients: [emailAddress],
        cc: ['cc@example.com'],
        bcc: ['bcc@example.com'],
        attachmentPaths: ['/path/to/file.pdf'],
        isHTML: false,
      );

      await FlutterEmailSender.send(email);
    } catch (e) {
      if (kDebugMode) {
        print('error sending email: $e');
        CPopupSnackBar.errorSnackBar(
          message: 'error sending email: $e',
          title: 'error sending email',
        );
      }
      rethrow;
    }
  }

  Future<void> launchEmailApp(String emailAddress) async {
    try {
      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: emailAddress,
        queryParameters: {
          'subject': '',
          'body': '',
        },
      );

      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        CPopupSnackBar.warningSnackBar(
          message: 'Unable to launch email app! try again later.',
          title: 'Could not launch email app!',
        );
        throw 'Could not launch email app!';
      }
    } catch (e) {
      if (kDebugMode) {
        print('error sending email: $e');
        CPopupSnackBar.errorSnackBar(
          message: 'error sending email: $e',
          title: 'error sending email',
        );
      }
      rethrow;
    }
  }

  Future<void> launchWhatsappChat(String recipientNumber) async {
    try {
      var androidWhatsappUrl =
          'whatsapp://send?phone=$recipientNumber&text=wooza!';
      var iosWhatsappUrl =
          'https://wa.me/$recipientNumber?text=${Uri.parse('rada...')}';

      if (Platform.isIOS) {
        if (await canLaunchUrlString(iosWhatsappUrl)) {
          await launchUrlString(iosWhatsappUrl);
        } else {
          CPopupSnackBar.customToast(
            forInternetConnectivityStatus: false,
            message: 'unable to launch whatsapp chat! please try again later',
          );
        }
      } else {
        if (await canLaunchUrlString(androidWhatsappUrl)) {
          await launchUrlString(androidWhatsappUrl);
        } else {
          CPopupSnackBar.customToast(
            forInternetConnectivityStatus: false,
            message: 'unable to launch whatsapp chat! please try again later',
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('error launching whatsapp: $e');
        CPopupSnackBar.errorSnackBar(
          message: 'error launching whatsapp: $e',
          title: 'error launching whatsapp',
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          message: 'unable to launch whatsapp chat! please try again later',
          title: 'error launching whatsapp',
        );
      }
      rethrow;
    }
  }

  /// -- bottomSheetModal for when usp is less than ubp --
  updateDialCodeDialog(
    BuildContext context,
    CContactsModel contactItem,
  ) async {
    return showModalBottomSheet(
      context: context,

      builder: (context) {
        final isDarkTheme = CHelperFunctions.isDarkMode(context);

        resetFields();
        // -- set field values --
        contactCountryCode.value = contactItem.contactCountryCode != ''
            ? contactItem.contactCountryCode
            : contactCountryCode.value;
        contactDialCode.value = contactItem.contactDialCode != ''
            ? contactItem.contactDialCode
            : contactDialCode.value;
        txtPhoneController.text = contactItem.contactPhone;
        return SizedBox(
          height: CHelperFunctions.screenHeight() * .28,
          child: Padding(
            padding: const EdgeInsets.all(
              CSizes.lg * .8,
            ),
            child: Column(
              children: [
                Text(
                  'Whatsapp requires your contact\'s country code...',
                  style: Theme.of(context).textTheme.bodyMedium!.apply(),
                ),
                const SizedBox(
                  height: CSizes.spaceBtnSections * .7,
                ),
                SizedBox(
                  width: CHelperFunctions.screenWidth() * .8,
                  child: Column(
                    children: [
                      IntlPhoneField(
                        controller: txtPhoneController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          fillColor: isDarkTheme
                              ? CColors.transparent
                              : CColors.lightGrey,
                          labelText: 'Phone number',
                        ),
                        // Default country code (e.g., India)
                        // initialCountryCode: contactItem.contactIsoCode != ''
                        //     ? contactItem.contactIsoCode
                        //     : 'UG',
                        initialCountryCode: contactItem.contactCountryCode != ''
                            ? contactItem.contactCountryCode
                            : 'KE',
                        invalidNumberMessage: 'Invalid phone number!',
                        onChanged: (phone) {
                          contactCountryCode.value = phone.countryISOCode;
                          contactDialCode.value = phone.countryCode;

                          if (kDebugMode) {
                            print('=========\n');
                            print('country code: ${phone.countryISOCode}\n');
                            print('---------\n');
                            print(
                              'country iso code: ${phone.countryCode}\n',
                            );
                            print('---------\n');
                            print(
                              'complete number: ${phone.completeNumber}\n',
                            );
                            print('=========\n');

                            CPopupSnackBar.customToast(
                              forInternetConnectivityStatus: false,
                              message:
                                  'country code: ${contactCountryCode.value}\n dial code: ${contactDialCode.value}',
                            );
                          }
                        },
                        onCountryChanged: (country) {
                          contactCountryCode.value = country.code;

                          contactDialCode.value = country.dialCode;

                          if (kDebugMode) {
                            print('=========\n');
                            print('country code: ${country.code}\n');
                            print('---------\n');
                            print(
                              'dial code: ${country.dialCode}',
                            );
                            print('---------\n');
                            print(
                              'full country code: ${country.fullCountryCode}\n',
                            );
                            print('=========\n');
                          }
                        },
                      ),
                      const SizedBox(
                        height: CSizes.spaceBtnSections * .5,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton.icon(
                            icon: FaIcon(
                              FontAwesomeIcons.whatsapp,
                              color: CColors.white,
                              //size: 24.0,
                            ),
                            // Icon(
                            //   Iconsax.save_add,
                            //   size: CSizes.iconSm,
                            //   color: isDarkTheme
                            //       ? CColors.rBrown
                            //       : CColors.white,
                            // ),
                            label: Text(
                              'Proceed',
                              style: Theme.of(context).textTheme.labelMedium!
                                  .apply(
                                    color: isDarkTheme
                                        ? CColors.white
                                        : CColors.rBrown,
                                  ),
                            ),
                            onPressed: () async {
                              contactItem.contactCountryCode =
                                  contactItem.contactCountryCode == ''
                                  ? contactCountryCode.value
                                  : contactItem.contactCountryCode;
                              contactItem.contactDialCode =
                                  contactItem.contactDialCode == ''
                                  ? contactDialCode.value
                                  : contactItem.contactDialCode;
                              contactItem.contactPhone = txtPhoneController.text
                                  .trim();

                              if (await updateContact(contactItem)) {
                                fetchMyContacts().then(
                                  (_) {
                                    launchWhatsappChat(
                                      '${contactItem.contactDialCode}${contactItem.contactPhone}',
                                    );
                                  },
                                );

                                //resetFields();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor:
                                  CColors.white, // foreground (text) color
                              // backgroundColor: isDarkTheme
                              //     ? CColors.white
                              //     : CColors.rBrown, // background color
                              backgroundColor: Colors.green,
                            ),
                          ),
                          TextButton.icon(
                            icon: const Icon(
                              Iconsax.undo,
                              size: CSizes.iconSm,
                              color: CColors.rBrown,
                            ),
                            label: Text(
                              'Cancel',
                              style:
                                  Theme.of(
                                    context,
                                  ).textTheme.labelMedium!.apply(
                                    color: CColors.rBrown,
                                  ),
                            ),
                            onPressed: () {
                              resetFields();
                              Get.back();
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor:
                                  CColors.rBrown, // foreground (text) color
                              backgroundColor:
                                  CColors.white, // background color
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// -- on trash contact button pressed --
  Future<void> onTrashAction(
    BuildContext context,
    CContactsModel trashItem,
  ) async {
    try {
      CFlushbars.undo(
        duration: const Duration(
          seconds: 11,
        ),
        message: 'You can still undo this action!!',
        onUndo: () {
          undoTrashBtnPressed.value = true;
          Navigator.pop(context, true);
        },
        undoTextStyle: Theme.of(context).textTheme.bodyMedium!.apply(
          color: CColors.white,
          fontSizeFactor: 1.3,
        ),
      ).show(context);

      delayedTrashAction(trashItem);
    } catch (e) {
      if (kDebugMode) {
        print('error trashing contact: $e');
        CPopupSnackBar.errorSnackBar(
          message: 'error trashing contact: $e',
          title: 'error trashing contact',
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          message:
              'Unable to send contact to trash bin. Please try again later',
          title: 'error trashing contact',
        );
      }
      rethrow;
    }
  }

  /// -- restore contact from trash --

  void delayedTrashAction(CContactsModel trashItem) async {
    // Wait for 2 seconds
    await Future.delayed(
      const Duration(
        seconds: 13,
      ),
      () {
        if (undoTrashBtnPressed.value == false) {
          trashItem.isTrashed = 1;
          trashItem.lastModified = DateFormat(
            'yyyy-MM-dd kk:mm',
          ).format(clock.now());
          trashItem.syncAction = trashItem.isSynced == 0 ? 'append' : 'update';

          updateContact(trashItem).then(
            (_) {
              Get.offAll(
                () {
                  final navController = Get.put(CNavMenuController());
                  navController.selectedIndex.value = 2;
                  undoTrashBtnPressed.value = false;
                  return const NavMenu();
                },
              );
            },
          );
        }
      },
    );

    // Perform action after delay
    if (kDebugMode) {
      print("Action performed after 2 seconds");
    }

    resetFields();
  }

  /// -- process cloud sync --
  Future<void> processContactsSync() async {
    try {
      processingContactsSync.value = true;
      await addUnsyncedContactsToCloud();

      // -- stop loader --
      processingContactsSync.value = false;
    } catch (e) {
      // -- stop loader --
      processingContactsSync.value = false;
      if (kDebugMode) {
        print('error adding contact to cloud: $e');
        CPopupSnackBar.errorSnackBar(
          message: 'error processing contacts\' cloud sync: $e',
          title: 'error processing contacts\' cloud sync',
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          message:
              'Unable to process contacts\' cloud sync! Please try again later..',
          title: 'error processing contacts\' cloud sync',
        );
      }
      rethrow;
    }
  }

  /// -- add unsynced contacts to cloud --
  Future<bool> addUnsyncedContactsToCloud() async {
    try {
      // -- start loader --
      isLoading.value = true;

      await fetchMyContacts();

      // -- check internet connectivity
      final isConnectedToInternet = await CNetworkManager.instance
          .isConnected();

      if (isConnectedToInternet &&
          CNetworkManager.instance.connectionIsStable.value) {
        var cloudContactAppends = unsyncedContactAppends.map(
          (element) {
            return {
              'contactId': element.contactId,
              'productId': element.productId,
              'addedBy': element.addedBy,
              'contactName': element.contactName,
              'contactCountryCode': element.contactCountryCode,
              'contactDialCode': element.contactDialCode,
              'contactPhone': element.contactPhone,
              'contactEmail': element.contactEmail,
              'contactCategory': element.contactCategory,
              'lastModified': element.lastModified,
              'createdAt': element.createdAt,
              'isSynced': 1,
              'syncAction': 'none',
              'isStarred': element.isStarred,
              'isTrashed': element.isTrashed,
            };
          },
        ).toList();

        if (cloudContactAppends.isNotEmpty ||
            unsyncedContactAppends.isNotEmpty) {
          await StoreSheetsApi.addLocalContactsToCloud(
            cloudContactAppends,
          ).then((_) {
            updateSyncedContactsLocally();
          });
        } else {
          CPopupSnackBar.customToast(
            forInternetConnectivityStatus: false,
            message: 'rada safi nani...',
          );
        }
        // -- stop loader --
        isLoading.value = false;
        fetchMyContacts();
        return true;
      } else {
        CPopupSnackBar.customToast(
          forInternetConnectivityStatus: false,
          message:
              "Your internet connection is not stable enough for cloud sync!",
        );
        // -- stop loader --
        isLoading.value = false;
        return false;
      }
    } catch (e) {
      // -- stop loader --
      isLoading.value = false;
      if (kDebugMode) {
        print('error adding contact to cloud: $e');
        CPopupSnackBar.errorSnackBar(
          message: 'error adding contact to cloud: $e',
          title: 'error adding contact to cloud',
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          message:
              'Unable to add unsynced contacts to cloud! Please try again later..',
          title: 'error adding contact to cloud',
        );
      }
      rethrow;
    }
  }

  /// -- update synced contacts locally --
  Future<void> updateSyncedContactsLocally() async {
    try {
      if (unsyncedContactAppends.isNotEmpty) {
        for (var contactAppend in unsyncedContactAppends) {
          contactAppend.isSynced = 1;
          contactAppend.syncAction = 'none';

          await dbHelper.updateContact(contactAppend);
        }
      } else {
        CPopupSnackBar.customToast(
          forInternetConnectivityStatus: false,
          message: 'rada safi nani...',
        );
      }
      fetchMyContacts();
    } catch (e) {
      if (kDebugMode) {
        print('error updating contacts\' sync status locally: $e');
        CPopupSnackBar.errorSnackBar(
          message: 'error updating contacts\' sync status locally: $e',
          title: 'error updating contacts\' sync status!',
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          message:
              'Unable to update contacts\' sync status on your devices! Please try again later...',
          title: 'error updating contacts\' sync status!',
        );
      }
      rethrow;
    }
  }

  /// -- import contacts from cloud to local storage --
  Future<bool> importContacts() async {
    try {
      // -- start loader --
      processingContactsSync.value = true;

      await fetchUserCloudContacts().then(
        (result) async {
          if (userCloudContacts.isNotEmpty) {
            for (var contact in userCloudContacts) {
              var forImportContacts = CContactsModel.withId(
                contact.contactId,
                contact.productId,
                contact.addedBy,
                contact.contactName,
                contact.contactCountryCode,
                contact.contactDialCode,
                contact.contactPhone,
                contact.contactEmail,
                contact.contactCategory,
                contact.lastModified,
                contact.createdAt,
                contact.isSynced,
                contact.syncAction,
                contact.isStarred,
                contact.isTrashed,
              );

              // -- save imported data to local sqflite database --
              await dbHelper.addContact(forImportContacts);
            }
          }
        },
      );

      // -- refresh myContacts list --
      Future.delayed(
        Duration.zero,
        () {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) async {
              await fetchMyContacts();
            },
          );
        },
      );

      // -- stop loader --
      processingContactsSync.value = false;

      return true;
    } catch (e) {
      // -- stop loader --
      processingContactsSync.value = false;
      if (kDebugMode) {
        print('error importing contacts from cloud: $e');
        CPopupSnackBar.errorSnackBar(
          message: 'error importing contacts from cloud: $e',
          title: 'error importing contacts from cloud!',
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          message:
              'Unable to import your contacts from cloud! Please try again later...',
          title: 'error importing contacts from cloud!',
        );
      }
      rethrow;
    }
  }

  /// -- fetch all contacts from cloud --
  Future fetchUserCloudContacts() async {
    try {
      var cloudContacts = await StoreSheetsApi.fetchContactsFromCloud();

      allCloudContacts.assignAll(cloudContacts as Iterable<CContactsModel>);

      userCloudContacts.value = allCloudContacts
          .where(
            (contact) => contact.addedBy.toLowerCase().contains(
              userController.user.value.email.toLowerCase(),
            ),
          )
          .toList();

      return userCloudContacts;
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        print('error fetching all contacts from cloud: $e');
        CPopupSnackBar.errorSnackBar(
          title: 'error fetching all contacts from cloud!',
          message: e.toString(),
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          title: 'error fetching all contacts from cloud!',
          message:
              'an unknown error occurred whil fetching all contacts from cloud! Please try again later.',
        );
      }
      rethrow;
    }
  }

  resetFields() {
    contactCountryCode.value = 'KE';
    contactDialCode.value = '254';
    txtEmailController.text = '';
    txtContactNameController.text = '';
    txtPhoneController.text = '';
    undoTrashBtnPressed.value = false;
  }

  /// -- dispose text editing controllers --
  @override
  void dispose() {
    txtContactNameController.dispose();
    txtEmailController.dispose();
    txtPhoneController.dispose();
    super.dispose();
  }
}
