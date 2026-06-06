import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
            Text(
              content,
              style: GoogleFonts.exo2(
                color: TFColors.whitePrimary,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                confirmText,
                style: GoogleFonts.robotoSlab(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

void showProfileDialog({required BuildContext context}) {
  final user = FirebaseAuth.instance.currentUser;
  final uid = user?.uid;

  showDialog(
    context: context,
    builder: (context) => Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 400),
        child: uid == null
            ? Padding(
                padding: const EdgeInsets.all(20),
                child: Text("User not logged in"),
              )
            : StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text("No user data found"),
                  );
                }

                final data = snapshot.data!.data() as Map<String, dynamic>;

                final firstName = (data['firstName'] as String?)?.trim() ?? '';
                final lastName = (data['lastName'] as String?)?.trim() ?? '';
                final username = (data['username'] as String?)?.trim() ?? '';

                String capitalize(String text) {
                  if (text.isEmpty) return '';
                  return text[0].toUpperCase() +
                      text.substring(1).toLowerCase();
                }

                final fullName = firstName.isNotEmpty
                    ? (lastName.isNotEmpty
                          ? '${capitalize(firstName)} ${capitalize(lastName)}'
                          : capitalize(firstName))
                    : 'User Name';

                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: TFColors.whitePrimary,
                              width: 2,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.asset(
                              'assets/profile.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),

                      Column(
                        children: [
                          Text(
                            fullName,
                            style: GoogleFonts.exo2(
                              color: TFColors.whitePrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            username.isNotEmpty ? '@$username' : '@username',
                            style: GoogleFonts.exo2(
                              color: TFColors.whitePrimary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              await FirebaseAuth.instance.signOut();
                              Navigator.of(
                                context,
                              ).pushReplacementNamed('homePage');
                            },
                            child: Text(
                              'Log Out',
                              style: GoogleFonts.robotoSlab(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () {
                              showCostumDialog(
                                context: context,
                                title: 'Delete Account',
                                content:
                                    'Are you sure you want to delete your account?',
                                confirmText: 'Delete',
                                onConfirm: () async {
                                  try {
                                    final user =
                                        FirebaseAuth.instance.currentUser;

                                    await user?.reauthenticateWithPopup(
                                      GoogleAuthProvider(),
                                    );

                                    await user?.delete();

                                    Navigator.of(
                                      context,
                                    ).pushNamedAndRemoveUntil(
                                      'homePage',
                                      (route) => false,
                                    );
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                              );
                            },
                            child: Text(
                              'Delete Account',
                              style: GoogleFonts.robotoSlab(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16),
                    ],
                  ),
                );
              },
            ),
    ),
  )
  );
}
