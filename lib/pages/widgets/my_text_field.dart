import 'package:flutter/material.dart';
import 'package:sacs_app/theme.dart';

class MyTextField extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final String? errorText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextInputType? inputType;
  final String? Function(String?)? validator;
  final void Function(String?)? onFieldSubmitted;
  final String? textToUpdate;
  final int? maxLines;
  final double? height;
  final Color? inputColor;
  bool enabled;

  MyTextField({
    required this.controller,
    required this.icon,
    required this.hintText,
    required this.focusNode,
    required this.enabled,
    this.onFieldSubmitted,
    this.inputColor,
    this.validator,
    this.inputType,
    this.errorText,
    this.textToUpdate,
    this.maxLines,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 46,
      padding: EdgeInsets.only(left: 8, right: 4, bottom: 4),
      margin: EdgeInsets.only(top: 8, bottom: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: CustomTheme.seconadaryColorLight,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(6),
        color: CustomTheme.complementaryColor2,
      ),
      child: TextFormField(
        enabled: enabled,
        textCapitalization: TextCapitalization.words,
        focusNode: focusNode,
        maxLines: maxLines,
        controller: controller,
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.center,
        keyboardType: inputType,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(bottom: 20),
          icon: Icon(
            icon,
            color: CustomTheme.seconadaryColorLight,
            size: 18,
          ),
          errorStyle: TextStyle(fontSize: 10, height: 0.3),
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 14,
          ),
          border: InputBorder.none,
        ),
        style: TextStyle(
          color: inputColor ?? CustomTheme.secondaryColorDark,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        validator: validator,
        onFieldSubmitted: onFieldSubmitted,
      ),
    );
  }
}
