import 'package:cri_v3/common/widgets/appbar/app_bar.dart';
import 'package:cri_v3/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:cri_v3/features/store/screens/search/widgets/c_typeahead_field.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class CSearchResultsScreen extends StatelessWidget {
  const CSearchResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CPrimaryHeaderContainer(
            child: Column(
              children: [
                // -- ## APP BAR ## --
                CAppBar(
                  title: const CTypeAheadSearchField(),
                  backIconAction: () {
                    Navigator.of(context).pop();
                    //Get.back();
                  },
                ),

                const SizedBox(height: CSizes.spaceBtnSections),
              ],
            ),
          ),

          /// -- search results card --
          Card(
            shadowColor: CColors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    //BasicTilePage(),
                    ExpansionTile(
                      childrenPadding: const EdgeInsets.all(
                        10,
                      ).copyWith(top: 10),
                      title: const Text('data'),
                      children: const [
                        Text('manu ni yule mguyz...'),
                        Text('na si ati niaje...'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
