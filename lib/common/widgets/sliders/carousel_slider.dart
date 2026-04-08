import 'package:carousel_slider/carousel_slider.dart';
import 'package:cri_v3/common/widgets/custom_shapes/containers/circular_container.dart';
import 'package:cri_v3/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:cri_v3/features/store/controllers/dashboard_controller.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/img_strings.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CCarouselSlider extends StatelessWidget {
  const CCarouselSlider({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardController = Get.put(CDashboardController());
    return Column(
      children: [
        CarouselSlider(
          items: [
            CRoundedContainer(
              borderRadius: CSizes.md,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(CSizes.md),
                child: Image(image: AssetImage(CImages.sliderImg1)),
              ),
            ),
            CRoundedContainer(
              borderRadius: CSizes.md,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(CSizes.md),
                child: Image(image: AssetImage(CImages.sliderImg2)),
              ),
            ),
            CRoundedContainer(
              borderRadius: CSizes.md,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(CSizes.md),
                child: Image(image: AssetImage(CImages.sliderImg3)),
              ),
            ),
          ],
          options: CarouselOptions(
            onPageChanged: (index, _) {
              dashboardController.updateCarouselSliderIndex(index);
            },
            viewportFraction: 1,
          ),
        ),
        const SizedBox(height: CSizes.spaceBtnItems),
        Obx(() {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < 3; i++)
                CCircularContainer(
                  bgColor: dashboardController.carouselSliderIndex.value == i
                      ? CColors.rBrown
                      : CColors.white,
                  height: 4.0,
                  margin: const EdgeInsets.only(
                    right: CSizes.spaceBtnItems / 2,
                  ),
                  width: 20.0,
                ),
            ],
          );
        }),
      ],
    );
  }
}
