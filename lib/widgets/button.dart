// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CustomFilledButton extends StatelessWidget {
  ButtonStyle? style;
  final void Function()? onPressed;
  final Widget child;
  CustomFilledButton(
      {super.key, required this.onPressed, required this.child, this.style});
  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: style == null
          ? ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
            )
          : style!.copyWith(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
            ),
      child: child,
    );
  }
}

class CustomOutlinedButton extends StatelessWidget {
  ButtonStyle? style;
  final void Function()? onPressed;
  final Widget child;
  CustomOutlinedButton(
      {super.key, required this.onPressed, required this.child, this.style});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: style == null
          ? ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
            )
          : style!.copyWith(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
            ),
      child: child,
    );
  }
}
