import 'package:cri_v3/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:cri_v3/features/personalization/controllers/contacts_controller.dart';
import 'package:cri_v3/features/personalization/models/contacts_model.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:cri_v3/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CCustomTypeaheadField extends StatelessWidget {
  const CCustomTypeaheadField({
    super.key,
    this.contentPadding,
    this.fieldHeight,
    this.fieldLabelStyle,
    this.fieldValidator,
    this.fillColor,
    this.focusedBorderColor,
    this.minHeight,
    this.onFieldValueChanged,
    this.prefixIcon,
    required this.includeAvatarOnSuggestion,
    required this.includePrefixIcon,
    required this.labelTxt,
    required this.onItemSelected,
    required this.typeAheadFieldController,
  });

  final bool includePrefixIcon, includeAvatarOnSuggestion;
  final Color? fillColor, focusedBorderColor;
  final double? fieldHeight, minHeight;
  final EdgeInsetsGeometry? contentPadding;

  final String labelTxt;
  final TextEditingController typeAheadFieldController;
  final TextStyle? fieldLabelStyle;
  final Widget? prefixIcon;
  final void Function(CContactsModel) onItemSelected;
  final void Function(String)? onFieldValueChanged;
  final FormFieldValidator<String>? fieldValidator;

  // @override
  @override
  Widget build(BuildContext context) {
    final contactsController = Get.put(CContactsController());
    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    final screenWidth = CHelperFunctions.screenWidth();

    return TypeAheadField<CContactsModel>(
      controller: typeAheadFieldController,
      builder: (context, controller, focusNode) {
        return TextFormField(
          autofocus: false,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: controller,
          decoration: InputDecoration(
            constraints: BoxConstraints(
              minHeight: minHeight ?? 65.0,
            ),
            filled: true,
            fillColor:
                fillColor ??
                (isDarkTheme ? CColors.transparent : CColors.white),
            focusColor: CColors.rBrown,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                CSizes.cardRadiusXs,
              ),
              borderSide: BorderSide(
                color: CColors.grey,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color:
                    focusedBorderColor ??
                    CColors.black.withValues(
                      alpha: 0.3,
                    ),
              ),
              borderRadius: BorderRadius.circular(
                CSizes.cardRadiusSm,
              ),
            ),
            labelStyle: Theme.of(
              context,
            ).textTheme.labelSmall,
            labelText: labelTxt,
            prefixIcon: includePrefixIcon
                ? prefixIcon ??
                      Icon(
                        Iconsax.user_add,
                        color: CColors.darkGrey,
                        size: CSizes.iconXs,
                      )
                : null,
          ),
          focusNode: focusNode,
          onChanged: onFieldValueChanged,
          scrollPadding: const EdgeInsets.only(
            bottom: 80.0,
          ),
          style: const TextStyle(
            fontWeight: FontWeight.normal,
          ),
          validator: fieldValidator,
        );
      },
      constraints: BoxConstraints(
        maxWidth: screenWidth,
      ),
      hideOnEmpty: true,
      offset: Offset(
        0,
        5.0,
      ),

      listBuilder: (context, children) {
        return Obx(
          () {
            return ListView.separated(
              itemCount: contactsController.foundMatches.length,
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 5.0,
                );
              }, // 10px space between items
              itemBuilder: (context, index) {
                return children[index];
              },
            );
          },
        );
      },

      suggestionsCallback: (pattern) {
        return contactsController.contactSuggestionsCallBackAction(
          pattern,
        );
      },
      itemBuilder: (context, suggestion) {
        if (contactsController.foundMatches.isEmpty) {
          return SizedBox.shrink();
        } else {
          return CRoundedContainer(
            bgColor: CColors.white,
            borderRadius: 6.0,
            padding: const EdgeInsets.only(
              bottom: 4.0,
              left: 4.0,
              right: 4.0,
            ),
            child: ListTile(
              contentPadding:
                  contentPadding ??
                  const EdgeInsets.all(
                    5.0,
                  ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  10.0,
                ),
              ),

              // tileColor: isDarkTheme
              //     ? CColors.rBrown.withValues(
              //         alpha: .3,
              //       )
              //     : CColors.white.withValues(
              //         alpha: .3,
              //       ),
              tileColor: CColors.white.withValues(
                alpha: .9,
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  includeAvatarOnSuggestion
                      ? CircleAvatar(
                          backgroundColor: CColors.rBrown.shade100,
                          radius: 15.0,
                          child:
                              CValidator.isFirstCharacterALetter(
                                suggestion.contactName,
                              )
                              ? Text(
                                  suggestion.contactName[0].toUpperCase(),
                                  style: Theme.of(context).textTheme.bodyMedium!
                                      .apply(
                                        color: CColors.white,
                                        fontSizeFactor: 1.0,
                                      ),
                                )
                              : Icon(
                                  Iconsax.user,
                                  color:
                                      CHelperFunctions.randomAestheticColor(),
                                ),
                        )
                      : const SizedBox.shrink(),
                  if (includeAvatarOnSuggestion)
                    const SizedBox(
                      width: CSizes.spaceBtnInputFields / 2,
                    ),
                  Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Text(
                      //   suggestion.lastModified,
                      //   style: Theme.of(
                      //     context,
                      //   ).textTheme.labelSmall!.apply(color: CColors.darkGrey),
                      // ),
                      Text(
                        '${suggestion.contactName} ',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelMedium!.apply(
                          color: CColors.rBrown,
                          fontSizeFactor: 1.1,
                          fontWeightDelta: 2,
                        ),
                      ),
                      const SizedBox(
                        height: CSizes.spaceBtnItems / 4.0,
                      ),
                      suggestion.contactPhone != ''
                          ? Text(
                              'Mobile: ${suggestion.contactPhone}',
                              style:
                                  Theme.of(
                                    context,
                                  ).textTheme.labelMedium!.apply(
                                    color: CColors.black,
                                  ),
                            )
                          : SizedBox.shrink(),
                      suggestion.contactEmail != ''
                          ? Text(
                              'Email: ${suggestion.contactEmail}',
                              style:
                                  Theme.of(
                                    context,
                                  ).textTheme.labelSmall!.apply(
                                    color: CColors.black,
                                  ),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
      onSelected: onItemSelected,
    );
  }
}
