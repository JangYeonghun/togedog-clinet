import 'package:dog/src/config/global_variables.dart';
import 'package:dog/src/repository/auth_repository.dart';
import 'package:dog/src/util/toast_popup_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class API {
  final String domain = GlobalVariables.domain;
  final int port = GlobalVariables.port;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  // 401 unauthorized 발생시 토큰 재발급 및 API 호출 재시도
  Future<Response> api({required Future<Response> Function() func, BuildContext? context}) async {

    return await func().then((response) async {
      debugPrint('''
      
      /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/
      
      StatusCode: ${response.statusCode}
      Content: ${response.body}
      
      /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/
      
      ''');

      if (response.statusCode == 401) {
        await AuthRepository().reissueToken().then((succeed) async {
          if (succeed) {
            return await api(func: () => func(), context: context);
          } else {
            await storage.deleteAll();
            throw Exception('Error: Token Expired');
          }
        });

      } else if (response.statusCode ~/ 100 == 2) {
        return response;

      } else if (context != null) {
        _failureNotifier(response: response, context: context);
      }

      throw Exception("API call failed");
    });
  }

  // Http status code에 따른 토스트 팝업
  void _failureNotifier({
    required Response response,
    required BuildContext context
  }) {
    switch (response.statusCode ~/ 100) {
      case 5:
        ToastPopupUtil.error(context: context, content: '서버와의 통신에 실패했습니다.');
        throw Exception('Server Connection Error: ${response.statusCode}');
      case 4:
        ToastPopupUtil.error(context: context, content: '문제가 발생하였습니다.');
        throw Exception('Error: ${response.statusCode}');
      default:
        ToastPopupUtil.error(context: context, content: '문제가 발생하였습니다.');
        throw Exception('Error: ${response.statusCode}');
    }
  }

}