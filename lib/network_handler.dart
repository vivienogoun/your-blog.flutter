import 'dart:convert';

import 'package:http/http.dart' as http;

class NetworkHandler {
  String baseUrl = "your-blog12fp3hbur1.000webhostapp.com";

  Uri urlToUri(String url, Map<String, dynamic>? params) {
    return Uri(
      scheme: 'https',
      host: baseUrl,
      path: "/api$url",
      queryParameters: params
    );
  }

  Future<http.Response> get(String url, Map<String, dynamic>? params) async {
    var response = await http.get(
      urlToUri(url, params),
    ).timeout(const Duration(seconds: 15)).catchError((e) {
      http.Response errorResponse = http.Response('', 500);
      return errorResponse;
    });
    return response;
  }

  Future<http.Response> post(String url, Map<String, dynamic> body, Map<String, dynamic>? params) async {
    var response = await http.post(
      urlToUri(url, params),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode(body)
    ).timeout(const Duration(seconds: 15)).catchError((e) {
      http.Response errorResponse = http.Response('', 500);
      return errorResponse;
    });
    return response;
  }
}