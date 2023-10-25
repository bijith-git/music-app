import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton(
      {Key? key,
      required this.width,
      required this.icon,
      this.padding = EdgeInsets.zero,
      this.decoration = const BoxDecoration(),
      required this.onPressed,
      this.iconColor = Colors.white})
      : super(key: key);

  final double width;
  final Color iconColor;
  final EdgeInsetsGeometry padding;
  final Decoration decoration;
  final IconData icon;

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: padding,
      decoration: decoration,
      child: TextButton(
        onPressed: onPressed,
        child: Icon(
          icon,
          color: iconColor,
        ),
      ),
    );
  }
}
