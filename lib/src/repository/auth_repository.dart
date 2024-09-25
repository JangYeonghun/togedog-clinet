import 'package:dog/src/config/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class AuthRepository {
  final String domain = GlobalVariables.domain;
  final int port = GlobalVariables.port;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<bool> reissueToken() async {
    final String? refreshToken = await storage.read(key: 'refreshToken');

    final Response response = await get(
      Uri.https(domain, 'api/v1/member/reissue-token'),
      headers: <String, String>{
        'Content-type' : 'application/json',
        'Authorization' : 'Bearer $refreshToken'
      }
    );

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