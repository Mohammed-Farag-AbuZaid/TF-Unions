import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'saved_accounts_stub.dart'
    if (dart.library.js_interop) 'saved_accounts_web.dart';

class SavedAccountEntry {
  final String email;
  final String name;
  final String provider;
  final String uid;

  const SavedAccountEntry({
    required this.email,
    required this.name,
    this.provider = 'password',
    this.uid = '',
  });

  factory SavedAccountEntry.fromJson(Map<String, dynamic> j) =>
      SavedAccountEntry(
        email: (j['email'] ?? '').toString(),
        name: (j['name'] ?? '').toString(),
        provider: (j['provider'] ?? 'password').toString(),
        uid: (j['uid'] ?? '').toString(),
      );

  Map<String, dynamic> toJson() => {
        'email': email,
        'name': name,
        'provider': provider,
        'uid': uid,
        'lastUsedAt': DateTime.now().millisecondsSinceEpoch,
      };
}

class SavedAccountsStore {
  static const _key = 'tf_saved_accounts';

  static List<SavedAccountEntry> list() {
    try {
      final raw = readStorage(_key);
      if (raw == null || raw.isEmpty) return [];
      final decoded = jsonDecode(raw);
      if (decoded is! List) return [];
      return decoded
          .whereType<Map>()
          .map((m) => SavedAccountEntry.fromJson(Map<String, dynamic>.from(m)))
          .where((e) => e.email.isNotEmpty)
          .toList();
    } catch (_) {
      return [];
    }
  }

  static void save({
    required String email,
    String name = '',
    String provider = 'password',
    String uid = '',
  }) {
    final cleanEmail = email.trim();
    if (cleanEmail.isEmpty) return;
    final current = list()
      ..removeWhere((e) => e.email.toLowerCase() == cleanEmail.toLowerCase());
    current.insert(
      0,
      SavedAccountEntry(
        email: cleanEmail,
        name: name.trim().isNotEmpty ? name.trim() : cleanEmail.split('@').first,
        provider: provider,
        uid: uid,
      ),
    );
    writeStorage(
      _key,
      jsonEncode(current.take(6).map((e) => e.toJson()).toList()),
    );
  }

  static void saveFromUser(User user) {
    final email = user.email ?? '';
    if (email.isEmpty) return;
    final hasGoogle =
        user.providerData.any((p) => p.providerId.contains('google'));
    save(
      email: email,
      name: user.displayName ?? email.split('@').first,
      provider: hasGoogle ? 'google' : 'password',
      uid: user.uid,
    );
  }

  static void remove(String email) {
    final lower = email.trim().toLowerCase();
    final updated = list()..removeWhere((e) => e.email.toLowerCase() == lower);
    writeStorage(
      _key,
      jsonEncode(updated.map((e) => e.toJson()).toList()),
    );
  }
}
