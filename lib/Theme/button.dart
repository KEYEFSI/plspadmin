import 'package:flutter/material.dart';

class FFButtonOptions {
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? iconPadding;
  final Color? color;
  final TextStyle? textStyle;
  final double? elevation;
  final BorderSide? borderSide;
  final BorderRadius? borderRadius;

  const FFButtonOptions({
    this.width,
    this.height,
    this.padding,
    this.iconPadding,
    this.color,
    this.textStyle,
    this.elevation,
    this.borderSide,
    this.borderRadius,
  });
}

class FFButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final FFButtonOptions options;

  const FFButtonWidget({super.key, 
    required this.onPressed,
    required this.text,
    this.options = const FFButtonOptions(),
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: options.textStyle?.color, backgroundColor: options.color,
        minimumSize: Size(options.width ?? double.infinity, options.height ?? 44.0),
        padding: options.padding,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        shape: RoundedRectangleBorder(
          borderRadius: options.borderRadius ?? BorderRadius.circular(12.0),
          side: options.borderSide ?? BorderSide.none,
        ),
        elevation: options.elevation ?? 3.0,
      ),
      child: Text(
        text,
        style: options.textStyle ?? const TextStyle(fontSize: 16.0, color: Colors.white),
      ),
    );
  }
}