import 'package:dog/src/config/global_variables.dart';
import 'package:dog/src/repository/auth_repository.dart';
import 'package:dog/src/util/toast_popup_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class API {
  final String domain = GlobalVariables.domain;
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  static bool isReissuing = false;
  int _retry = 0;
  int _reissueWait = 0;
  int _backoffDelay = 2;
  int _reissueBackoffDelay = 2;

  // 401 unauthorized 발생시 토큰 재발급 및 API 호출 재시도
  Future<Response> api({BuildContext? context, required Future<Response> Function(String? accessToken) func}) async {

    while (_reissueWait < 4) {
      _reissueWait ++;

      if (isReissuing) {
        await Future.delayed(Duration(seconds: _reissueBackoffDelay));
        _reissueBackoffDelay *= 2;

      } else {
        return storage.read(key: 'accessToken').then((accessToken) {
          return func(accessToken).then((response) async {
            debugPrint('''
      
            /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/
            
            API: ${response.request?.method} ${response.request?.url}
            StatusCode: ${response.statusCode}
            Content: ${response.body}
            
            /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/
            
            ''');

            if (response.statusCode == 401) {
              return _reissueToken().then((result) async {
                if (result) {
                  // 토큰 갱신 성공시 API 호출 재시도 및 토큰 재발급 관련 변수 초기화
                  _resetReissueState();
                  return await api(func: (accessToken) => func(accessToken), context: context);

                } else {
                  // 토큰 갱신 실패시 만료된 기존 토큰 제거
                  await storage.deleteAll();
                  throw Exception('Error: Token Expired');

                }
              });

            } else if (response.statusCode ~/ 100 == 2) {
              return response;

            } else if (context != null) {
              // optional 값인 context 존재시 응답 결과에 따른 토스트 팝업 제공
              _failureNotifier(response: response, context: context);

            }
            throw Exception("API call failed");
          });
        });
      }
    }
    throw Exception("Token reissue wait timeout");
  }

  // 토큰 재발급 관련 변수 초기화
  void _resetReissueState() {
    isReissuing = false;
    _reissueWait = 0;
    _reissueBackoffDelay = 2;
  }

  // 토큰 재발급
  Future<bool> _reissueToken() async {
    isReissuing = true;
    _retry ++;

    if (_retry > 1) {
      await Future.delayed(Duration(seconds: _backoffDelay));
      _backoffDelay *= 2;
    }

    if (_retry < 3) {
      return AuthRepository().reissueToken();

    } else {
      _retry = 0;
      _backoffDelay = 2;
      throw Exception('Error: Token reissue failure');

    }
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