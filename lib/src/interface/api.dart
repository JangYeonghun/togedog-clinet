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
  int retry = 0;
  int backoffDelay = 2;

  // 401 unauthorized 발생시 토큰 재발급 및 API 호출 재시도
  Future<Response> api({BuildContext? context, required Future<Response> Function(String? accessToken) func}) {

    return storage.read(key: 'accessToken').then((accessToken) {

      return func(accessToken).then((response) async {
        debugPrint('''
      
      /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/
      
      StatusCode: ${response.statusCode}
      Content: ${response.body}
      
      /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/
      
      ''');

        if (response.statusCode == 401) {
          retry ++;

          if (retry > 1) {
            await Future.delayed(Duration(seconds: backoffDelay));
            backoffDelay *= 2;
          }

          if (retry < 3) {
            return AuthRepository().reissueToken().then((succeed) async {
              if (succeed) {
                return await api(func: (accessToken) => func(accessToken), context: context);
              } else {
                await storage.deleteAll();
                throw Exception('Error: Token Expired');
              }
            });
          } else {
            retry = 0;
            backoffDelay = 2;
            throw Exception('Error: Token reissue failure');
          }

        } else if (response.statusCode ~/ 100 == 2) {
          return response;

        } else if (context != null) {
          _failureNotifier(response: response, context: context);
          throw Exception("Error: API call gone wrong");
        } else {
          throw Exception("API call failed");
        }
      });
    });


  }

  // Http status code에 따른 토스트 팝업
  void _failureNotifier({
    required Response response,
    required BuildContext context
  }) {

    final String errMsg;
    final String errLog;

    switch (response.statusCode ~/ 100) {
      case 5:
        errMsg = '서버와의 통신에 실패했습니다.';
        errLog = 'Server Connection Error: ${response.statusCode}';
        break;
      case 4:
        errMsg = '요청에 실패했습니다.';
        errLog = 'Request Error: ${response.statusCode}';
        break;
      default:
        errMsg = '알수없는 오류가 발생했습니다.';
        errLog = 'Unknown Error: ${response.statusCode}';
        break;
    }

    ToastPopupUtil.error(context: context, content: errMsg);
    throw Exception(errLog);
  }

}