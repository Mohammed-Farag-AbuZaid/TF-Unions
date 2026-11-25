import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:tf_union/constants/tfcolors.dart';
import 'package:tf_union/widgets/edit_profile_sheet.dart';
import 'package:web/web.dart' as web;

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
      backgroundColor: TFColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: TFColors.border),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Bricolage Grotesque',
                  color: title.toLowerCase().contains('error') ||
                          title.toLowerCase().contains('delete')
                      ? const Color(0xFFB91C1C)
                      : TFColors.ink,
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                content,
                style: const TextStyle(
                  color: TFColors.muted,
                  fontSize: 13.5,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: title.toLowerCase().contains('delete')
                        ? const Color(0xFFB91C1C)
                        : TFColors.accent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    confirmText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
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
      final uploadInput = web.document.createElement('input') as web.HTMLInputElement
        ..type = 'file'
        ..accept = 'image/*';

      final completer = Completer<web.File?>();
      late JSFunction onChange;
      late JSFunction onCancel;
      onChange = ((web.Event _) {
        uploadInput.removeEventListener('change', onChange);
        uploadInput.removeEventListener('cancel', onCancel);
        final files = uploadInput.files;
        if (!completer.isCompleted) {
          completer.complete(
            files != null && files.length > 0 ? files.item(0) : null,
          );
        }
      }).toJS;
      onCancel = ((web.Event _) {
        uploadInput.removeEventListener('change', onChange);
        uploadInput.removeEventListener('cancel', onCancel);
        if (!completer.isCompleted) completer.complete(null);
      }).toJS;

      uploadInput.addEventListener('change', onChange);
      uploadInput.addEventListener('cancel', onCancel);
      uploadInput.click();

      final file = await completer.future;
      if (file == null) {
        if (mounted) setState(() => _uploadingImage = false);
        return;
      }

      final ab = await file.arrayBuffer().toDart;
      final bytes = ab.toDart.asUint8List();
      final url = await _uploadToCloudinary(bytes, file.name);

      if (url != null) {
        final uid = FirebaseAuth.instance.currentUser?.uid;
        if (uid != null) {
          await FirebaseFirestore.instance.collection('users').doc(uid).set({
            'profilePicture': url,
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
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
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 12,
                color: TFColors.muted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 13,
                color: TFColors.ink,
                fontWeight: FontWeight.w500,
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
      color: TFColors.tealSoft,
      child: Center(
        child: Text(
          firstName.isNotEmpty ? firstName[0].toUpperCase() : '?',
          style: GoogleFonts.bricolageGrotesque(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: TFColors.gold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Dialog(
      backgroundColor: TFColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: TFColors.border),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420, maxHeight: 620),
        child: uid == null
            ? const Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Not logged in',
                  style: TextStyle(color: TFColors.ink),
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
                          color: TFColors.accent,
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
                                  color: TFColors.tealBorder,
                                  width: 2.5,
                                ),
                                color: TFColors.tealSoft,
                              ),
                              child: ClipOval(
                                child: _uploadingImage
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          color: TFColors.accent,
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
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: TFColors.accent,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  size: 13,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // ── Name & username ────────────────────────────
                        Text(
                          fullName.isNotEmpty ? fullName : 'Your Name',
                          style: GoogleFonts.bricolageGrotesque(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: TFColors.ink,
                          ),
                        ),
                        if (username.isNotEmpty)
                          Text(
                            '@$username',
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: TFColors.gold,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                        const SizedBox(height: 18),
                        const Divider(color: TFColors.border),
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

                        const SizedBox(height: 18),
                        const Divider(color: TFColors.border),
                        const SizedBox(height: 12),

                        // ── Edit button ────────────────────────────────
                        SizedBox(
                          width: double.infinity,
                          height: 44,
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
                              backgroundColor: TFColors.accent,
                              foregroundColor: Colors.white,
                              elevation: 0,
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
                                  foregroundColor: TFColors.ink,
                                  side: const BorderSide(color: TFColors.border),
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
                                  foregroundColor: const Color(0xFFB91C1C),
                                  side: const BorderSide(
                                    color: Color(0xFFFECACA),
                                    width: 1,
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
