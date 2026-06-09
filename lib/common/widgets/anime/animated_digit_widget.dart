import 'package:animated_digit/animated_digit.dart';
import 'package:flutter/material.dart';

class CAnimatedDigitWidget extends StatelessWidget {
  const CAnimatedDigitWidget({
    required this.value,
    this.animationDuration,
    this.fractionDigits,
    this.prefix,
    this.suffix,
    this.txtStyle,
    super.key,
  });

  final double value;

  final int? animationDuration, fractionDigits;
  final String? prefix, suffix;
  final TextStyle? txtStyle;

  @override
  Widget build(BuildContext context) {
    return AnimatedDigitWidget(
      animateUnchangedDigits: true,
      curve: Curves.easeInOut,
      duration: Duration(
        milliseconds: animationDuration ?? 2000,
      ),
      enableSeparator: true, // Adds commas: 5,000
      fractionDigits: fractionDigits ?? 2,
      prefix: prefix ?? 'kES.',
      suffix: suffix,
      textStyle:
          txtStyle ??
          const TextStyle(
            fontSize: 32,
            color: Colors.orange,
          ),
      value: value,
    );
  }
}
