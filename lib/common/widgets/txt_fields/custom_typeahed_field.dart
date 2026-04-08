import 'package:cri_v3/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:cri_v3/features/personalization/controllers/contacts_controller.dart';
import 'package:cri_v3/features/personalization/models/contacts_model.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CCustomTypeahedField extends StatelessWidget {
  const CCustomTypeahedField({
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
    required this.labelTxt,
    required this.typeAheadFieldController,
    required this.onItemSelected,
    required this.includePrefixIcon,
  });

  final bool includePrefixIcon;
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

    return CRoundedContainer(
      bgColor: CColors.transparent,
      height: fieldHeight ?? 60.0,
      width: screenWidth,
      child: TypeAheadField<CContactsModel>(
        controller: typeAheadFieldController,
        builder: (context, controller, focusNode) {
          return TextFormField(
            autofocus: false,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: controller,
            decoration: InputDecoration(
              constraints: BoxConstraints(
                minHeight: minHeight ?? 70.0,
              ),
              filled: true,
              fillColor:
                  fillColor ??
                  (isDarkTheme ? CColors.transparent : CColors.lightGrey),
              focusColor: CColors.rBrown.withValues(alpha: 0.3),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(CSizes.cardRadiusXs),
                borderSide: BorderSide(color: CColors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color:
                      focusedBorderColor ??
                      CColors.black.withValues(alpha: 0.3),
                ),
                borderRadius: BorderRadius.circular(
                  CSizes.cardRadiusXs,
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
              bottom: 200,
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

        suggestionsCallback: (pattern) {
          return contactsController.contactSuggestionsCallBackAction(pattern);
        },
        itemBuilder: (context, suggestion) {
          if (contactsController.foundMatches.isEmpty) {
            return SizedBox.shrink();
          } else {
            return CRoundedContainer(
              margin: const EdgeInsets.all(
                4.0,
              ),
              child: ListTile(
                contentPadding:
                    contentPadding ??
                    const EdgeInsets.all(
                      5.0,
                    ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    5.0,
                  ),
                ),
                tileColor: isDarkTheme
                    ? CColors.rBrown.withValues(
                        alpha: .6,
                      )
                    : CColors.grey,

                title: Column(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   suggestion.lastModified,
                    //   style: Theme.of(
                    //     context,
                    //   ).textTheme.labelSmall!.apply(color: CColors.darkGrey),
                    // ),
                    Text(
                      '${suggestion.contactName} ',
                      style: Theme.of(context).textTheme.labelMedium!.apply(
                        color: CColors.rBrown,
                        fontSizeFactor: 1.2,
                        fontWeightDelta: 2,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    Text(
                      '#${suggestion.productId}; phone: ${suggestion.contactPhone}; email: (${suggestion.contactEmail})',
                      style:
                          Theme.of(
                            context,
                          ).textTheme.labelSmall!.apply(
                            color: CColors.rBrown,
                          ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
        onSelected: onItemSelected,
      ),
    );
  }
}
