import 'package:another_flushbar/flushbar.dart';
import 'package:cri_v3/common/widgets/dialogs/count_down_widget.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CFlushbars extends GetxController {
  /// -- set up constructor --
  static CFlushbars get instance {
    return Get.find();
  }

  static Flushbar undo({
    required Duration duration,
    required String message,
    required VoidCallback onUndo,
    TextStyle? undoTextStyle,
  }) {
    return Flushbar<void>(
      backgroundColor: CColors.rBrown.withValues(
        alpha: .6,
      ),
      borderRadius: BorderRadius.circular(
        5.0,
      ),
      duration: duration,
      flushbarPosition: FlushbarPosition.BOTTOM,
      icon: CCountDownWidget(
        duration: duration,
      ),
      mainButton: TextButton.icon(
        onPressed: onUndo,
        label: Text(
          'undo',
          style: undoTextStyle,
        ),
      ),
      margin: const EdgeInsets.all(
        10.0,
      ),
      messageText: Text(
        message,
      ),
    );
  }
}
