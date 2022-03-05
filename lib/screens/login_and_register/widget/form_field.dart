import 'package:flutter/material.dart';
import 'package:habit_tracker_application_main/utilitis/constants.dart';

class FormWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String? lableText;
  final String? hintText;
  final IconData? prefixIcon;
  final Widget? sufixIcon;
  final Color? borderColor;
  final bool? isPassword;
  final bool? enabled;
  final bool? readOnly;
  final Function(String)? validator;
  final TextInputType? textInputType;
  final Function()? onTap;
  final Function(String)? onChange;
  final int? length;

  FormWidget(
      {this.controller,
      this.lableText,
      this.hintText,
      this.prefixIcon,
      this.sufixIcon,
      this.borderColor,
      this.isPassword = false,
      this.enabled,
      this.readOnly,
      this.textInputType = TextInputType.text,
      this.validator,
      this.onTap,
      this.onChange,
      this.length,
      Key? key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // textAlign: TextAlign.center,

      cursorColor: kFullGreenColor,
      readOnly: null == readOnly ? false : true,
      obscureText: isPassword!,
      controller: controller,
      // validator: validator,
      keyboardType: textInputType,
      style: const TextStyle(fontSize: 12),
      onTap: onTap,

      onChanged: onChange,
      maxLength: length,
      textInputAction: TextInputAction.done,

      decoration: InputDecoration(
        counterText: "",
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: kFullGreenColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: kLightGreenColor),
        ),
        labelText: lableText ?? '',
        hintText: hintText ?? '',
        labelStyle: const TextStyle(fontSize: 12, color: Colors.grey),
        hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
        errorStyle: const TextStyle(fontSize: 12),
        prefixIcon: null == prefixIcon
            ? null
            : Icon(
                prefixIcon,
                color: kBlack26,
              ),
        suffixIcon: sufixIcon,
        enabled: null == enabled ? true : false,
      ),
    );
  }
}
