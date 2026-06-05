import 'package:flutter/material.dart';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:google_fonts/google_fonts.dart';


void showCostumDialog({
  required BuildContext context,
  required String title,
  required String content,
  required VoidCallback onConfirm,
  String confirmText = 'OK',
}) {
  showDialog(
    context: context,
    builder:(context) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                color: title.toLowerCase().contains('error')
                    ? Colors.red
                    : TFColors.whitePrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(content, style: GoogleFonts.exo2(
              color: TFColors.whitePrimary,
              fontSize: 12,
            ), textAlign: TextAlign.center),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(confirmText, style: GoogleFonts.robotoSlab(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
            ),
          ],
        ),
      ),
    ),
  );
}