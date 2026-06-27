import 'dart:typed_data';
import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/widgets/edit_profile_sheet.dart';

// ─── Custom Dialog ────────────────────────────────────────────────────────────
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
            const SizedBox(height: 16),
            Text(
              content,
              style: GoogleFonts.exo2(
                color: TFColors.whitePrimary,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
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

// ─── Profile Dialog ───────────────────────────────────────────────────────────
void showProfileDialog({required BuildContext context}) {
  showDialog(context: context, builder: (context) => const _ProfileDialog());
}

class _ProfileDialog extends StatefulWidget {
  const _ProfileDialog();

  @override
  State<_ProfileDialog> createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<_ProfileDialog> {
  bool _uploadingImage = false;

  static const _cloudinaryUrl =
      'https://api.cloudinary.com/v1_1/ddf0yaapn/image/upload';
  static const _uploadPreset = 'first_unsigned_preset';

  Future<String?> _uploadToCloudinary(Uint8List bytes, String filename) async {
    final req = http.MultipartRequest('POST', Uri.parse(_cloudinaryUrl))
      ..fields['upload_preset'] = _uploadPreset
      ..files.add(
        http.MultipartFile.fromBytes('file', bytes, filename: filename),
      );

    final res = await req.send();
    if (res.statusCode == 200) {
      final body = jsonDecode(await res.stream.bytesToString());
      return body['secure_url'] as String?;
    }
    return null;
  }

  Future<void> _pickAndUpload() async {
    setState(() => _uploadingImage = true);

    try {
      final uploadInput = html.FileUploadInputElement()
        ..accept = 'image/*'
        ..click();

      await uploadInput.onChange.first;

      final file = uploadInput.files?.first;
      if (file == null) {
        setState(() => _uploadingImage = false);
        return;
      }

      final reader = html.FileReader();
      reader.readAsArrayBuffer(file);
      await reader.onLoad.first;

      final bytes = reader.result as Uint8List;
      final url = await _uploadToCloudinary(bytes, file.name);

      if (url != null) {
        final uid = FirebaseAuth.instance.currentUser?.uid;
        if (uid != null) {
          await FirebaseFirestore.instance.collection('users').doc(uid).update({
            'profilePicture': url,
          });
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile picture updated!')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Upload failed. Try again.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _uploadingImage = false);
    }
  }

  Widget _infoRow(String label, String? value) {
    if (value == null || value.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: GoogleFonts.exo2(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.exo2(
                fontSize: 13,
                color: TFColors.whitePrimary,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? _schoolValue(Map<String, dynamic> data, String level) {
    if (level == 'STEM') return data['stemSchool'] as String?;
    if (level == 'Thanawy') return data['thanawySchool'] as String?;
    if (level == 'Prep School') return data['prepSchool'] as String?;
    return null;
  }

  Widget _defaultAvatar(String firstName) {
    return Container(
      color: const Color(0xFF1A1A2E),
      child: Center(
        child: Text(
          firstName.isNotEmpty ? firstName[0].toUpperCase() : '?',
          style: GoogleFonts.robotoSlab(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: TFColors.yellowPrimary,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Dialog(
      backgroundColor: const Color(0xFF111111),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420, maxHeight: 620),
        child: uid == null
            ? const Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Not logged in',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 200,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: TFColors.yellowPrimary,
                        ),
                      ),
                    );
                  }

                  final data = snapshot.data?.exists == true
                      ? snapshot.data!.data() as Map<String, dynamic>
                      : <String, dynamic>{};

                  String cap(String? s) {
                    if (s == null || s.trim().isEmpty) return '';
                    final t = s.trim();
                    return t[0].toUpperCase() + t.substring(1).toLowerCase();
                  }

                  final firstName = cap(data['firstName']);
                  final lastName = cap(data['lastName']);
                  final fullName = [
                    firstName,
                    lastName,
                  ].where((s) => s.isNotEmpty).join(' ');
                  final username = data['username'] as String? ?? '';
                  final profilePic = data['profilePicture'] as String? ?? '';
                  final level = data['academicLevel'] as String? ?? '';

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ── Avatar ─────────────────────────────────────
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: TFColors.yellowPrimary,
                                  width: 2.5,
                                ),
                                color: const Color(0xFF1A1A2E),
                              ),
                              child: ClipOval(
                                child: _uploadingImage
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          color: TFColors.yellowPrimary,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : profilePic.isNotEmpty
                                    ? Image.network(
                                        profilePic,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, _, _) =>
                                            _defaultAvatar(firstName),
                                      )
                                    : _defaultAvatar(firstName),
                              ),
                            ),
                            GestureDetector(
                              onTap: _uploadingImage ? null : _pickAndUpload,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                  color: TFColors.yellowPrimary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  size: 13,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // ── Name & username ────────────────────────────
                        Text(
                          fullName.isNotEmpty ? fullName : 'Your Name',
                          style: GoogleFonts.robotoSlab(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: TFColors.whitePrimary,
                          ),
                        ),
                        if (username.isNotEmpty)
                          Text(
                            '@$username',
                            style: GoogleFonts.exo2(
                              fontSize: 12,
                              color: TFColors.yellowPrimary,
                            ),
                          ),

                        const SizedBox(height: 20),
                        const Divider(color: Colors.white12),
                        const SizedBox(height: 12),

                        // ── Info rows ──────────────────────────────────
                        _infoRow('Email', data['email'] as String?),
                        _infoRow('Phone', data['phone'] as String?),
                        _infoRow('Gender', data['gender'] as String?),
                        _infoRow('Birth Date', data['birthDate'] as String?),
                        _infoRow('Level', level),
                        if (level == 'University') ...[
                          _infoRow('University', data['university'] as String?),
                          _infoRow('Faculty', data['faculty'] as String?),
                          _infoRow('Year', data['year'] as String?),
                        ] else ...[
                          _infoRow('School', _schoolValue(data, level)),
                          _infoRow('Grade', data['grade'] as String?),
                        ],

                        const SizedBox(height: 20),
                        const Divider(color: Colors.white12),
                        const SizedBox(height: 12),

                        // ── Edit button ────────────────────────────────
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                useSafeArea: true,
                                builder: (_) => EditProfileSheet(data: data),
                              );
                            },
                            icon: const Icon(Icons.edit_outlined, size: 15),
                            label: const Text('Edit Profile'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: TFColors.bglight1,
                              foregroundColor: TFColors.whitePrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // ── Log out / Delete ───────────────────────────
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () async {
                                  await FirebaseAuth.instance.signOut();
                                  if (!context.mounted) return;
                                  Navigator.of(
                                    context,
                                  ).pushReplacementNamed('homePage');
                                },
                                icon: const Icon(Icons.logout, size: 15),
                                label: const Text('Log Out'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: TFColors.whitePrimary,
                                  side: const BorderSide(color: Colors.white24),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  showCostumDialog(
                                    context: context,
                                    title: 'Delete Account',
                                    content:
                                        'This will permanently delete your account and all your data.',
                                    confirmText: 'Delete',
                                    onConfirm: () async {
                                      try {
                                        final user =
                                            FirebaseAuth.instance.currentUser;
                                        final uid = user?.uid;
                                        await user?.reauthenticateWithPopup(
                                          GoogleAuthProvider(),
                                        );
                                        if (uid != null) {
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(uid)
                                              .delete();
                                        }
                                        await user?.delete();
                                        if (!context.mounted) return;
                                        Navigator.of(
                                          context,
                                        ).pushNamedAndRemoveUntil(
                                          'homePage',
                                          (r) => false,
                                        );
                                      } catch (e) {
                                        debugPrint('Delete error: $e');
                                      }
                                    },
                                  );
                                },
                                icon: const Icon(
                                  Icons.delete_outline,
                                  size: 15,
                                ),
                                label: const Text('Delete'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.redAccent,
                                  side: const BorderSide(
                                    color: Colors.red,
                                    width: 0.5,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
