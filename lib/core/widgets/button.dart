import 'package:flutter/material.dart';
import 'package:my_portfolio/core/theme/app_colors.dart';

class ButtonWidget extends StatefulWidget {
  const ButtonWidget({
    super.key,
    this.onPressed,
    this.color,
    this.text,
    this.height,
    this.width,
    this.child,
    this.borderColor,
    this.buttonBorder,
    this.hasElevation = false,
    this.loading = false,
    this.loadingColor,
    this.borderRadius = 8,
    this.fontStyle,
    this.decorationColor,
    this.margin,
    this.padding,
    this.buttonHeight,
    this.fontSize,
  }) : assert(child != null || text != null);
  final Function()? onPressed;
  final Color? color;
  final String? text;
  final double? height;
  final double? width;
  final Widget? child;
  final Color? borderColor;
  final BorderSide? buttonBorder;
  final bool hasElevation;
  final bool loading;
  final Color? loadingColor;
  final Color? decorationColor;
  final double borderRadius;
  final double? fontSize;
  final double? buttonHeight;
  final TextStyle? fontStyle;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final Color hoverColor = Colors.white.withAlpha(70);
    final Color baseColor = widget.color ?? AppColors.headerColor;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: Container(
        margin: widget.margin,
        height: widget.buttonHeight,
        decoration: BoxDecoration(
          color: widget.decorationColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: [
            if (widget.hasElevation)
              BoxShadow(
                offset: const Offset(0, 4),
                blurRadius: 4,
                spreadRadius: 0,
                color: Colors.black.withValues(alpha: 0.15),
              ),
          ],
        ),
        child: MaterialButton(
          elevation: 0,
          onPressed: widget.onPressed,
          color: _isHovering ? hoverColor : baseColor,
          disabledTextColor: Colors.red,
          minWidth: widget.width ?? MediaQuery.sizeOf(context).width,
          height: widget.height ?? 54,
          disabledColor: baseColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            side:
                widget.buttonBorder == null
                    ? BorderSide.none
                    : widget.buttonBorder!,
          ),
          splashColor: Colors.white,
          focusColor: baseColor,
          hoverColor: Colors.black45,
          highlightColor: Colors.white,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 12),
          child:
              widget.loading
                  ? SizedBox(
                    width: widget.width,
                    height: widget.height,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: widget.loadingColor ?? Colors.white,
                      ),
                    ),
                  )
                  : widget.text != null
                  ? Text(
                    widget.text ?? '',
                    style:
                        widget.fontStyle ??
                        Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontSize: widget.fontSize,
                        ),
                  )
                  : widget.child,
        ),
      ),
    );
  }
}
