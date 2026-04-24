import 'package:cri_v3/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class CCountDownWidget extends StatefulWidget {
  const CCountDownWidget({
    super.key,
    required this.duration,
  });

  /// -- variables --
  final Duration duration;

  @override
  State<CCountDownWidget> createState() => _CCountDownWidgetState();
}

class _CCountDownWidgetState extends State<CCountDownWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;

  String get counterText {
    final Duration count =
        animationController.duration! * animationController.value;

    return count.inSeconds.toString();
  }

  @override
  void initState() {
    animationController = AnimationController(
      duration: Duration(
        seconds: 11,
      ),
      reverseDuration: Duration(
        seconds: 11,
      ),
      vsync: this,
    );

    animationController.reverse(
      from: 1,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Stack(
          children: [
            CRoundedContainer(
              // bgColor: CColors.rBrown.withValues(
              //   alpha: .3,
              // ),
              bgColor: CColors.transparent,
              height: 25.0,
              margin: const EdgeInsets.only(
                left: 10.0,
              ),
              width: 25.0,
              child: CircularProgressIndicator(
                backgroundColor: CColors.transparent,
                color: CColors.white,
                strokeWidth: .8,
                value: animationController.value,
              ),
            ),
            Positioned(
              right: 15.2,
              top: 5.0,
              child: Text(
                counterText,
                style: Theme.of(context).textTheme.labelMedium!.apply(
                  fontWeightDelta: 2,
                  color: CColors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
