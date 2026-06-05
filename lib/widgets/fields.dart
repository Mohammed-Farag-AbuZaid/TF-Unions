import 'package:ez_email_field/ez_email_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tf_union/constants/tfcolors.dart';

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
      decoration: InputDecoration(
        labelText: label,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: TFColors.hintDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
        suffixIcon: suffixIcon,
      ),
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
      decoration: InputDecoration(
        labelText: label,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: TFColors.hintDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
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

Widget buildVerificationFeild({
  required TextEditingController controller,
  required String label,
  VoidCallback? onTap,
  TextInputType keyboardType = TextInputType.number,
  bool readOnly = false,
}) {
  return Padding(
    padding: const EdgeInsets.only(
      left: 40.0,
      right: 40,
      top: 8.0,
      bottom: 8.0,
    ),
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: TFColors.hintDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required';
        }
        if (!RegExp(r"^\d{6}$").hasMatch(value.trim())) {
          return 'Enter a valid 6-digit code';
        }
        return null;
      },
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: keyboardType,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
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
      decoration: InputDecoration(
        labelText: label,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: TFColors.hintDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
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
      decoration: InputDecoration(
        errorText: errorText,
        suffixIcon: suffixIcon,
        labelText: label,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: TFColors.hintDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
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
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(180),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(30),
          bottomLeft: Radius.circular(30),
          topLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: TFColors.yellowPrimary.withAlpha(30),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
        border: Border.all(
          color: TFColors.yellowPrimary.withAlpha(50),
          width: 1.3,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
      child: Column(
        crossAxisAlignment: center
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            content,
            textAlign: center ? TextAlign.center : TextAlign.left,
            style: TextStyle(
              fontSize: 20,
              letterSpacing: 0.2,
              color: TFColors.whitePrimary,
              fontWeight: FontWeight.w500,
              fontFamily: 'Montserrat',
              height: 1.6,
            ),
          ),
        ],
      ),
    ),
  );
}
