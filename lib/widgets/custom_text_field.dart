import 'package:flutter/material.dart';

class CustomTextfield extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final TextInputType? keyboardType;
  final bool isPassword;
  final bool? autoFocus;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final InputDecoration? decoration;
  final bool? readOnly;
  final String? prefixText;
  final Icon? prefixIcon;
  final int? maxLines;
  final String? initialValue;
  final bool? obscureText;
  final Color? labelStyle;

  const CustomTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    this.keyboardType,
    required this.isPassword,
    this.prefixText,
    this.autoFocus,
    this.validator,
    this.onChanged,
    this.decoration,
    this.readOnly,
    this.prefixIcon,
    this.obscureText,
    this.maxLines,
    this.initialValue,
    this.labelStyle,
  });

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _isObscured : false,
      keyboardType: widget.isPassword && !_isObscured
          ? TextInputType.number
          : widget.keyboardType,

      validator: widget.validator,
      onChanged: widget.onChanged,
      initialValue: widget.initialValue,
      autofocus: widget.autoFocus ?? false,
      cursorColor: Colors.white,

      readOnly: widget.readOnly ?? false,
      maxLines: widget.isPassword
          ? 1
          : widget.maxLines, // Fix: set maxLines to 1 if password field
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        prefixText: widget.prefixText,
        prefixIcon: widget.prefixIcon,
        prefixIconColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.focused)) {
            return Colors.cyanAccent;
          }
          return Colors.white;
        }),
        labelText: widget.labelText,
        hintText: widget.hintText,
        labelStyle: WidgetStateTextStyle.resolveWith((states) {
          if (states.contains(WidgetState.focused)) {
            return const TextStyle(color: Colors.cyanAccent);
          }
          return const TextStyle(color: Colors.white);
        }),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.cyanAccent, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent, width: 1.5),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _isObscured ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
              )
            : null,
      ),
    );
  }
}
