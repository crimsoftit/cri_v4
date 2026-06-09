import 'package:cri_v3/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class CFreshDashboardScreenView extends StatelessWidget {
  const CFreshDashboardScreenView({
    super.key,
    required this.label,
    required this.iconData,
    this.onTap,
  });

  final String label;
  final IconData iconData;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CRoundedContainer(
        width: CHelperFunctions.screenWidth() * .45,
        child: Column(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.all(CSizes.defaultSpace / 3),
              onTap: onTap,
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  //'add your first item to get started!'.toUpperCase(),
                  label.toUpperCase(),
                  style: Theme.of(
                    context,
                  ).textTheme.labelMedium!.apply(color: CColors.rBrown),
                  textAlign: TextAlign.center,
                ),
              ),
              title: Icon(iconData, color: CColors.rBrown),

              //trailing: Icon(Icons.more_vert),
            ),
            const SizedBox(),
          ],
        ),
      ),
    );
  }
}
