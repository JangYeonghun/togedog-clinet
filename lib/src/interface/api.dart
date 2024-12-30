import 'dart:math';
import 'package:dog/src/config/global_variables.dart';
import 'package:dog/src/exception/api_exception.dart';
import 'package:dog/src/exception/token_reissue_exception.dart';
import 'package:dog/src/repository/token_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class API {
  final String domain = GlobalVariables.domain;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final TokenRepository _tokenRepository = TokenRepository();

  static bool isGlobalReissuing = false;
  static const int _maxBackoffDelay = 800;

  Future<Response> api({required Future<Response> Function(String? accessToken) func}) async {
    int retry = 0;
    late final Response response;

    while (retry < 4) {
      retry++;

      if (retry > 4) throw TokenReissueException('Token reissue timeout');

      if (isGlobalReissuing) {
        await _exponentialBackoff(retry, _maxBackoffDelay);
        continue;
      }

      try {
        response = await _callApi(func: func);
        break;
      } on ApiException catch(e) {

        if (e.response.statusCode == 401) {
          if (await _reissueToken()) response = await _callApi(func: func);
          break;
        }

        response = e.response;
        break;

      }
    }

    return response;
  }

  Future<Response> _callApi({required Future<Response> Function(String? accessToken) func}) async {
    final String? accessToken = await _storage.read(key: 'accessToken');
    final Response response = await func(accessToken);

    _logApi(response: response);

    if (response.statusCode ~/ 100 == 2) return response;

    throw ApiException('API call failure', response);
  }

  Future<bool> _reissueToken() async {
    isGlobalReissuing = true;
    int retry = 0;
    late final bool succeed;

    while (retry < 4) {
      retry++;

      if (retry > 4) {
        throw TokenReissueException('Access Token reissue failure');
      }

      if (await _tokenRepository.reissueToken()) {
        succeed = true;
        break;
      }

      await _exponentialBackoff(retry, _maxBackoffDelay);
    }

    return succeed;
  }

  Future<void> _exponentialBackoff(int retryCount, int maxDelay) async {
    await Future.delayed(Duration(milliseconds: min(200 * pow(2, retryCount).toInt(), maxDelay)));
  }

  void _logApi({required Response response}) {
    debugPrint('''

        /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/
        
        API: ${response.request?.method} ${response.request?.url}
        StatusCode: ${response.statusCode}
        Content: ${response.body}
        
        /=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/
        
        ''');
  }
}