import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String? text;
  final Color? textColor;
  final FontWeight? fontWeight;
  final Widget? icon;
  final double? width;
  final double? height;
  final double? borderRadius;
  final double? borderWidth;
  final Color? backgroundColor;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;
  final double? iconTextSpacing;
  final MainAxisAlignment? alignment;
  final double? iconSize;

  const CustomButton({
    Key? key,
    required this.onPressed,
    this.text,
    this.textColor,
    this.fontWeight,
    this.icon,
    this.width,
    this.height,
    this.borderRadius,
    this.borderWidth,
    this.backgroundColor,
    this.borderColor,
    this.padding,
    this.iconTextSpacing,
    this.alignment,
    this.iconSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle? elevatedButtonStyle = ElevatedButtonTheme.of(context).style;

    final double defaultBorderRadius = borderRadius ?? 20.0;
    final double defaultBorderWidth = borderWidth ?? 1.0;

   /* final double defaultWidth = width ?? 200.0;*/

    final double defaultHeight = height ?? 40.0;

    final Color defaultBackgroundColor = backgroundColor ??
        elevatedButtonStyle?.backgroundColor?.resolve({}) ??
        Theme.of(context).colorScheme.primary;

    final Color? defaultTextColor = textColor ??
        Theme.of(context).elevatedButtonTheme.style?.foregroundColor?.resolve({}) ??
        Theme.of(context).colorScheme.onPrimary;


    final Color defaultBorderColor = borderColor ?? Color(0xFF747775);
    final EdgeInsetsGeometry defaultPadding = padding ?? EdgeInsets.symmetric(horizontal: 12.0);
    final double defaultIconTextSpacing = iconTextSpacing ?? 10.0;
    final MainAxisAlignment defaultAlignment = alignment ?? MainAxisAlignment.center;

    return SizedBox(
      width: width,
      height: defaultHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: defaultPadding,
          backgroundColor: defaultBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(defaultBorderRadius),
            side: BorderSide(
              color: defaultBorderColor,
              width: defaultBorderWidth,
            ),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: defaultAlignment,
          mainAxisSize: MainAxisSize.max,
          children: [
            if (icon != null) ...[
              SizedBox(
                width: iconSize ?? 20.0,
                height: iconSize ?? 20.0,
                child: icon,
              ),
              if (text != null)
                SizedBox(width: defaultIconTextSpacing),
            ],
            if (text != null)
              Flexible(
                child: Text(
                  text!,
                  style:
                      TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: fontWeight ?? FontWeight.w500,
                        fontSize: 14,
                        height: 20 / 14,
                        letterSpacing: 0.25,
                        color: defaultTextColor,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
