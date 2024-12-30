import 'package:dog/src/config/global_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class TokenRepository {
  final String domain = GlobalVariables.domain;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<bool> reissueToken() async {
    final String? refreshToken = await storage.read(key: 'refreshToken');
    final String? accessToken = await storage.read(key: 'accessToken');

    debugPrint('requesting accessToken: $accessToken');
    debugPrint('requesting refreshToken: $refreshToken');

    final Response response = await get(
      Uri.https(domain, 'api/v1/member/reissue-token'),
      headers: <String, String>{
        'Content-type' : 'application/json',
        'Authorization' : 'Bearer $accessToken',
        'refresh-token' : '$refreshToken'
      }
    ).timeout(const Duration(seconds: 3), onTimeout: () {
      debugPrint('타임아웃');
      throw Exception('타임아웃!!');
    });

    debugPrint('''
      
      /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/
      
      TOKEN REISSUE
      
      StatusCode: ${response.statusCode}
      Header: ${response.headers}
      Content: ${response.body}
      
      /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/
      
      ''');

    final json = response.headers;

    if (response.statusCode ~/ 100 == 2) {
      await storage.write(key: 'accessToken', value: json['accesstoken']);
      await storage.write(key: 'refreshToken', value: json['refreshtoken']);
      return true;
    } else {
      return false;
    }
  }
}