import 'package:flutter/material.dart';

import '../../gen/assets.gen.dart';
import '../forma_theme.dart';

class FormaIcon extends StatelessWidget {
  const FormaIcon({
    super.key,
    required this.glyph,
    required this.color,
    this.size = 20,
  });

  final SvgGenImage glyph;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return glyph.svg(
      width: size,
      height: size,
      excludeFromSemantics: true,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}

class FormaPrimaryButton extends StatelessWidget {
  const FormaPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.trailingIcon,
  });

  final String label;
  final VoidCallback? onPressed;
  final SvgGenImage? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: FormaColors.buttonBackground,
      borderRadius: BorderRadius.circular(FormaSpace.pillRadius),
      child: InkWell(
        borderRadius: BorderRadius.circular(FormaSpace.pillRadius),
        onTap: onPressed,
        child: SizedBox(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 7, 7, 7),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: FormaType.button.copyWith(
                      color: FormaColors.buttonForeground,
                    ),
                  ),
                ),
                CircleAvatar(
                  radius: 23,
                  backgroundColor: FormaColors.buttonIconBackground,
                  child: FormaIcon(
                    glyph: trailingIcon ?? Assets.icons.arrowRight,
                    size: 20,
                    color: FormaColors.buttonIconForeground,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FormaSecondaryButton extends StatelessWidget {
  const FormaSecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.height = 60,
    this.labelStyle,
  });

  final String label;
  final VoidCallback? onPressed;
  final double height;
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: FormaColors.background,
      shape: StadiumBorder(side: BorderSide(color: FormaColors.line)),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onPressed,
        child: SizedBox(
          height: height,
          child: Center(
            child: Text(label, style: labelStyle ?? FormaType.button),
          ),
        ),
      ),
    );
  }
}

class FormaFilledButton extends StatelessWidget {
  const FormaFilledButton({super.key, required this.label, this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: FormaColors.buttonBackground,
      borderRadius: BorderRadius.circular(FormaSpace.pillRadius),
      child: InkWell(
        borderRadius: BorderRadius.circular(FormaSpace.pillRadius),
        onTap: onPressed,
        child: SizedBox(
          height: 60,
          child: Center(
            child: Text(
              label,
              style: FormaType.button.copyWith(
                color: FormaColors.buttonForeground,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FormaRoundIconButton extends StatelessWidget {
  const FormaRoundIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    this.onPressed,
    this.accented = false,
    this.dimension,
    this.iconSize = 22,
  });

  final SvgGenImage icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final bool accented;
  final double? dimension;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final size = dimension ?? (accented ? 52.0 : 48.0);
    return Tooltip(
      message: tooltip,
      child: Material(
        color: accented ? FormaColors.accent : FormaColors.surface,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: SizedBox.square(
            dimension: size,
            child: Center(
              child: SizedBox.square(
                dimension: iconSize,
                child: FormaIcon(
                  glyph: icon,
                  size: iconSize,
                  color: accented ? FormaColors.ink : FormaColors.text,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FormaTextLink extends StatelessWidget {
  const FormaTextLink({super.key, required this.label, this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: FormaColors.accent,
        padding: EdgeInsets.zero,
        minimumSize: const Size(0, 48),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        label,
        style: FormaType.body.copyWith(fontSize: 12, color: FormaColors.accent),
      ),
    );
  }
}
