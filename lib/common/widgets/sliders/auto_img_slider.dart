import 'package:carousel_slider/carousel_slider.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/img_strings.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CAutoImgSlider extends StatefulWidget {
  const CAutoImgSlider({super.key});

  @override
  State<CAutoImgSlider> createState() => _CAutoImgSliderState();
}

class _CAutoImgSliderState extends State<CAutoImgSlider> {
  final sliderImages = [
    Image.asset(CImages.sliderImg0, fit: BoxFit.cover),
    Image.asset(CImages.sliderImg1, fit: BoxFit.cover),
    Image.asset(CImages.sliderImg2, fit: BoxFit.cover),
    Image.asset(CImages.sliderImg3, fit: BoxFit.cover),
    Image.asset(CImages.sliderImg4, fit: BoxFit.cover),
    Image.asset(CImages.sliderImg5, fit: BoxFit.cover),
    Image.asset(CImages.sliderImg6, fit: BoxFit.cover),
    Image.asset(CImages.sliderImg7, fit: BoxFit.cover),
  ];

  int currentImgIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        // top: 8.0,
        // bottom: 8.0,
        left: 4.0,
        right: 4.0,
      ),
      child: Column(
        children: [
          CarouselSlider(
            items: sliderImages,
            options: CarouselOptions(
              aspectRatio: 2.0,
              autoPlay: true,
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayCurve: Curves.fastEaseInToSlowEaseOut,
              enlargeCenterPage: true,
              height: 150.0,
              onPageChanged: (index, reason) {
                setState(() {
                  currentImgIndex = index;
                });
              },
              viewportFraction: 1.0,
            ),
          ),
          const SizedBox(height: CSizes.defaultSpace),
          AnimatedSmoothIndicator(
            activeIndex: currentImgIndex,
            count: sliderImages.length,
            effect: const WormEffect(
              activeDotColor: CColors.rBrown,
              dotColor: Colors.grey,
              dotHeight: 7.0,
              dotWidth: 7.0,
              paintStyle: PaintingStyle.fill,
              spacing: 8.0,
            ),
          ),
        ],
      ),
    );
  }
}
