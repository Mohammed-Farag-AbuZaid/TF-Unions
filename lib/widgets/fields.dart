import 'package:ez_email_field/ez_email_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tf_union/constants/tfcolors.dart';

InputDecoration _minimalDecoration(String label, {Widget? suffixIcon, String? errorText}) {
  return InputDecoration(
    labelText: label,
    errorText: errorText,
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: TFColors.tile,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: TFColors.accent, width: 1.5),
    ),
  );
}

Widget buildTextField({
  required TextEditingController controller,
  required String label,
  String? Function(String?)? validator,
  VoidCallback? onTap,
  TextInputType keyboardType = TextInputType.text,
  bool readOnly = false,
  bool obscureText = false,
  Widget? suffixIcon,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextFormField(
      controller: controller,
      decoration: _minimalDecoration(label, suffixIcon: suffixIcon),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your $label';
        }
        return null;
      },
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: keyboardType,
      obscureText: obscureText,
    ),
  );
}

Widget buildDropdown<T>({
  required String label,
  required T? value,
  required List<T> items,
  required void Function(T?) onChanged,
  String? Function(T?)? validator,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: DropdownButtonFormField<T>(
      decoration: _minimalDecoration(label),
      initialValue: value,
      items: items
          .map(
            (option) => DropdownMenuItem<T>(
              value: option,
              child: Text(option.toString()),
            ),
          )
          .toList(),
      onChanged: onChanged,
      validator: validator,
    ),
  );
}

Widget buildMailField({
  required TextEditingController controller,
  required String label,
  String? Function(String?)? validator,
  TextInputType keyboardType = TextInputType.emailAddress,
  bool readOnly = false,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: EZEmailField(
      controller: controller,
      decoration: _minimalDecoration(label),
      customValidator: validator,
      readOnly: readOnly,
      keyboardType: keyboardType,
    ),
  );
}

Widget buildUsernameField({
  required TextEditingController controller,
  required String label,
  String? errorText,
  Widget? suffixIcon,
  ValueChanged<String>? onChanged,
  String? Function(String?)? validator,
  VoidCallback? onTap,
  bool readOnly = false,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextFormField(
      onChanged: onChanged,
      controller: controller,
      decoration: _minimalDecoration(
        label,
        suffixIcon: suffixIcon,
        errorText: errorText,
      ),
      validator: (String? value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a username';
        }
        final validUsername = RegExp(r'^[a-z0-9_]+$');
        if (!validUsername.hasMatch(value)) {
          return 'Use lowercase letters, numbers, and underscores only';
        }
        if (value.contains(' ')) {
          return 'No spaces allowed';
        }
        return null;
      },
      readOnly: readOnly,
      onTap: onTap,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[a-z0-9_]')),
      ],
    ),
  );
}

Widget buildTextArea({required String content, bool center = true}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
    child: Container(
      decoration: BoxDecoration(
        color: TFColors.tile,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(24),
      child: Text(
        content,
        textAlign: center ? TextAlign.center : TextAlign.left,
        style: const TextStyle(
          fontSize: 16,
          color: TFColors.ink,
          height: 1.6,
        ),
      ),
    ),
  );
}
