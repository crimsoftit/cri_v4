import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class NoSearchResultsScreen extends StatelessWidget {
  const NoSearchResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = CHelperFunctions.isDarkMode(context);

    return Padding(
      padding: const EdgeInsets.only(
        top: CSizes.spaceBtnSections * 2,
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.search_off_outlined,
              size: CSizes.iconLg * 3,
              color: isDarkTheme ? CColors.white : CColors.rBrown,
            ),
            const SizedBox(height: CSizes.spaceBtnSections),
            Text(
              'Search results not found!',
              style: Theme.of(context).textTheme.labelLarge!.apply(
                //fontWeightDelta: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
