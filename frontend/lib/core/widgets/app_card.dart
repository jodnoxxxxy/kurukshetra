import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final VoidCallback? onTap;
  final Color? color;
  final double borderRadius;
  final List<BoxShadow>? boxShadow;
  final BoxBorder? border;

  const AppCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(20),
    this.margin = EdgeInsets.zero,
    this.onTap,
    this.color,
    this.borderRadius = 20,
    this.boxShadow,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final cardContent = Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border ?? Border.all(color: Colors.grey.withValues(alpha: 0.08), width: 1),
        boxShadow: boxShadow ?? [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );

    return Padding(
      padding: margin,
      child: onTap != null
          ? Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(borderRadius),
                onTap: onTap,
                child: cardContent,
              ),
            )
          : cardContent,
    );
  }
}
