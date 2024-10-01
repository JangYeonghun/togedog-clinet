import 'package:dog/src/config/global_variables.dart';
import 'package:dog/src/repository/auth_repository.dart';
import 'package:dog/src/util/api_error_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class API {
  final String domain = GlobalVariables.domain;

  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final AuthRepository authRepository = AuthRepository();
  final APIErrorNotifier apiErrorNotifier = APIErrorNotifier();

  static bool isReissuing = false;

  int _retry = 0;
  int _reissueWait = 0;
  int _backoffDelay = 200;
  int _reissueBackoffDelay = 200;

  // 401 unauthorized 발생시 토큰 재발급 및 API 호출 재시도
  Future<Response> api({BuildContext? context, required Future<Response> Function(String? accessToken) func}) async {

    while (_reissueWait < 4) {
      _reissueWait ++;

      if (isReissuing) {
        await Future.delayed(Duration(milliseconds: _reissueBackoffDelay));
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

            if (response.statusCode ~/ 100 == 2) {
              return response;
            }

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

            }

            // optional 값인 context 존재시 응답 결과에 따른 토스트 팝업 제공
            if (context != null) {
              apiErrorNotifier.notify(response: response, context: context);

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
    _reissueBackoffDelay = 200;
  }

  // 토큰 재발급
  Future<bool> _reissueToken() async {
    isReissuing = true;
    _retry ++;

    if (_retry > 1) {
      await Future.delayed(Duration(milliseconds: _backoffDelay));
      _backoffDelay *= 2;
    }

    if (_retry < 3) {
      return authRepository.reissueToken();

    } else {
      _retry = 0;
      _backoffDelay = 200;
      throw Exception('Error: Token reissue failure');

    }
  }
}