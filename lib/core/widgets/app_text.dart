import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextOverflow? overflow;

  const AppText(
    this.text, {
    super.key,
    this.style,
    this.maxLines,
    this.textAlign,
    this.overflow,
  });

  factory AppText.heading1(String text, {Color? color}) => AppText(
        text,
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color),
      );

  factory AppText.heading2(String text, {Color? color}) => AppText(
        text,
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
      );

  factory AppText.heading3(String text, {Color? color}) => AppText(
        text,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: color),
      );

  factory AppText.body(String text, {Color? color}) => AppText(
        text,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: color),
      );

  factory AppText.caption(String text, {Color? color}) => AppText(
        text,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: color ?? Colors.grey.shade600),
      );

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: overflow ?? (maxLines != null ? TextOverflow.ellipsis : null),
    );
  }
}
