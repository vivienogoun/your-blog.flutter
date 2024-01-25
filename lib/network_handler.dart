import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class NetworkHandler {
  String baseUrl = "dummyjson.com";
  var logger = Logger();
  FlutterSecureStorage storage = const FlutterSecureStorage();

  Uri urlToUri(String url) {
    return Uri(
      scheme: 'https',
      host: baseUrl,
      path: url,
    );
  }

  Future<dynamic> get(String url) async {
    String? token = await storage.read(key: "id");

    var response = await http.get(
      urlToUri(url),
      headers: {"Authorization": "Bearer $token"}
    );
    return response;
  }

  Future<http.Response> post(String url, Map<String, dynamic> body) async {
    String? token = await storage.read(key: "id");

    var response = await http.post(
      urlToUri(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: json.encode(body)
    );
    return response;
  }

  Future<http.StreamedResponse> patchImage(String url, String filePath) async {
    String? token = await storage.read(key: "id");

    var request = http.MultipartRequest("PATCH", Uri.parse(urlToUri(url) as String));
    request.files.add(await http.MultipartFile.fromPath("img", filePath));
    request.headers.addAll({
      "Content-Type": "multipart/form-data",
      "Authorization": "Bearer $token"
    });
    var response = request.send();
    return response;
  }
}