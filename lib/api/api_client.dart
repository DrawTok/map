import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:http/http.dart' as http;

class ApiClient extends GetxService {
  final String _baseUrl = 'https://geocode.search.hereapi.com/v1/';
  final int _timeoutInSeconds = 90;
  final String _noInternetMessage = 'Không có kết nối Internet';

  Future<Response> getData(String uri, Map<String, String> headers,
      {Map<String, dynamic>? query}) async {
    try {
      if (kDebugMode) {
        print('====> API Call: $uri');
      }
      http.Response response = await http
          .get(
            Uri.parse(_baseUrl + uri).replace(queryParameters: query),
            headers: headers,
          )
          .timeout(Duration(seconds: _timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      if (kDebugMode) {
        print('------------${e.toString()}');
      }
      return Response(statusCode: 1, statusText: _noInternetMessage);
    }
  }

  Response handleResponse(http.Response response, String uri) {
    dynamic body;
    try {
      body = jsonDecode(utf8.decode(response.bodyBytes));
    } catch (e) {
      if (kDebugMode) {
        print('Error decoding JSON: $e');
      }
    }
    Response response0 = Response(
      body: body ?? response.body,
      bodyString: response.body.toString(),
      request: Request(
          headers: response.request!.headers,
          method: response.request!.method,
          url: response.request!.url),
      headers: response.headers,
      statusCode: response.statusCode,
      statusText: response.reasonPhrase,
    );
    if (response0.statusCode != 200 &&
        response0.body != null &&
        response0.body is! String) {
      if (response0.body.toString().startsWith('{status:')) {
        response0 = Response(
            statusCode: response0.statusCode,
            body: response0.body,
            statusText: response0.body['title']);
      }
    } else if (response0.statusCode != 200 && response0.body == null) {
      response0 = Response(statusCode: 0, statusText: _noInternetMessage);
    }
    if (kDebugMode) {
      print(
          '====> API Response: [${response0.statusCode}] $uri\n${response0.body}');
    }
    return response0;
  }
}
