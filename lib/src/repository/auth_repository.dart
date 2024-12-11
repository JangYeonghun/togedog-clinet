import 'package:dog/src/config/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class AuthRepository {
  Future<void> signOut({required BuildContext context}) async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    const String domain = GlobalVariables.domain;
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
}