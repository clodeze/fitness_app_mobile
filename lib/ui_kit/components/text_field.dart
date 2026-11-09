import 'package:flutter/material.dart';

import '../forma_theme.dart';

class FormaTextField extends StatefulWidget {
  const FormaTextField({
    super.key,
    required this.label,
    this.initialValue,
    this.controller,
    this.keyboardType,
    this.showFocusedStyle = false,
    this.labelGap = 10,
    this.hintText,
    this.obscureText = false,
    this.textInputAction,
    this.onSubmitted,
  }) : assert(initialValue == null || controller == null);

  final String label;
  final String? initialValue;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool showFocusedStyle;
  final double labelGap;
  final String? hintText;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  State<FormaTextField> createState() => _FormaTextFieldState();
}

class _FormaTextFieldState extends State<FormaTextField> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(_onFocusChanged);
  }

  void _onFocusChanged() => setState(() {});

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final highlighted = _focusNode.hasFocus || widget.showFocusedStyle;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(FormaSpace.fieldRadius),
      borderSide: BorderSide(
        color: highlighted ? FormaColors.focusedLine : FormaColors.line,
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: FormaType.caption.copyWith(
            color: highlighted ? FormaColors.accent : FormaColors.muted,
          ),
        ),
        SizedBox(height: widget.labelGap),
        SizedBox(
          height: 54,
          child: TextFormField(
            initialValue: widget.initialValue,
            controller: widget.controller,
            focusNode: _focusNode,
            keyboardType: widget.keyboardType,
            obscureText: widget.obscureText,
            textInputAction: widget.textInputAction,
            onFieldSubmitted: widget.onSubmitted,
            autocorrect: false,
            enableSuggestions: !widget.obscureText,
            cursorColor: FormaColors.accent,
            style: FormaType.body.copyWith(
              color: widget.obscureText ? FormaColors.muted : FormaColors.text,
            ),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: FormaType.body.copyWith(color: FormaColors.muted),
              filled: true,
              fillColor: FormaColors.surface,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 17,
              ),
              border: border,
              enabledBorder: border,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(FormaSpace.fieldRadius),
                borderSide: BorderSide(color: FormaColors.focusedLine),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
