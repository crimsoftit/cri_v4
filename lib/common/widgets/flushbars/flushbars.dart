import 'package:another_flushbar/flushbar.dart';
import 'package:cri_v3/common/widgets/dialogs/count_down_widget.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class CFlushbars {
  static Flushbar undo({
    required Duration duration,
    required String message,
    required VoidCallback onUndo,
  }) {
    return Flushbar<void>(
      backgroundColor: CColors.rBrown,
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
