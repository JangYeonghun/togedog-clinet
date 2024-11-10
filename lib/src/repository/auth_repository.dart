import 'package:dog/src/config/global_variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class AuthRepository {
  final String domain = GlobalVariables.domain;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<void> signOut({required BuildContext context}) async {
    final String? accessToken = await storage.read(key: 'accessToken');

    final Response response = await post(
        Uri.https(domain, 'api/v1/member/logout'),
        headers: <String, String>{
          'Content-type' : 'application/json',
          'Authorization' : 'Bearer $accessToken'
        }
    );

    debugPrint('''
      
      /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/
      
      SIGN OUT
      
      StatusCode: ${response.statusCode}
      Header: ${response.headers}
      Content: ${response.body}
      
      /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/
      
      ''');

    if (response.statusCode ~/ 100 != 2) return;

    await storage.deleteAll().whenComplete(() async {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false, arguments: {'isLogout': true});
    });
  }

  Future<bool> reissueToken() async {
    final String? refreshToken = await storage.read(key: 'refreshToken');
    final String? accessToken = await storage.read(key: 'accessToken');

    final Response response = await get(
      Uri.https(domain, 'api/v1/member/reissue-token'),
      headers: <String, String>{
        'Content-type' : 'application/json',
        'Authorization' : 'Bearer $accessToken',
        'refresh-token' : '$refreshToken'
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