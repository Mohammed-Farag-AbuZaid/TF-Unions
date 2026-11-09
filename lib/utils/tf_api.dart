import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

const String kTfApiBaseUrl = 'https://n8n.tfunions.com/tf-api';

class TfApiService {
  static Future<List<Map<String, dynamic>>> fetchCollection(String name) async {
    try {
      final res = await http
          .get(Uri.parse('$kTfApiBaseUrl/api/collections/$name'))
          .timeout(const Duration(seconds: 8));
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        final items = body['items'] as List<dynamic>? ?? [];
        return items.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      }
    } catch (_) {}

    final snap = await FirebaseFirestore.instance.collection(name).get();
    return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
  }

  static Future<Map<String, dynamic>?> fetchDoc(String collection, String id) async {
    try {
      final res = await http
          .get(Uri.parse('$kTfApiBaseUrl/api/collections/$collection/$id'))
          .timeout(const Duration(seconds: 6));
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        final data = (body['data'] as Map<String, dynamic>?) ?? body;
        return {'id': id, ...data};
      }
    } catch (_) {}

    final doc = await FirebaseFirestore.instance.collection(collection).doc(id).get();
    if (!doc.exists) return null;
    return {'id': doc.id, ...(doc.data() ?? {})};
  }

  static Future<void> saveDoc(
    String collection,
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      final clean = Map<String, dynamic>.from(data)
        ..removeWhere((_, v) => v is FieldValue);
      await http
          .put(
            Uri.parse('$kTfApiBaseUrl/api/collections/$collection/$id'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(clean),
          )
          .timeout(const Duration(seconds: 6));
      return;
    } catch (_) {}

    await FirebaseFirestore.instance
        .collection(collection)
        .doc(id)
        .set(data, SetOptions(merge: true));
  }
}
