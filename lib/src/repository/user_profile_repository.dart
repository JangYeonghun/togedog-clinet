import 'dart:convert';

import 'package:dog/src/dto/user_profile_register_dto.dart';
import 'package:dog/src/interface/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';

class UserProfileRepository extends API {

  Future<Response> getProfile({
    required BuildContext? context
  }) {
    return api(
      context: context,
      func: (accessToken) => get(
          Uri.https(domain, '/api/v1/mate'),
          headers: <String, String> {
            'Content-type' : 'application/json',
            'Authorization' : 'Bearer $accessToken'
          }
      )
    );
  }

  Future<Response> remove({
    required BuildContext? context
  }) {
    return api(
        context: context,
        func: (accessToken) => delete(
            Uri.https(domain, '/api/v1/mate'),
            headers: <String, String> {
              'Content-type' : 'application/json',
              'Authorization' : 'Bearer $accessToken'
            }
        )
    );
  }

  Future<Response> update({
    required BuildContext? context,
    required UserProfileRegisterDto dto
  }) {
    return api(
        context: context,
        func: (accessToken) async {
          MultipartRequest request = MultipartRequest(
              'PATCH',
              Uri.https(domain, 'api/v1/mate')
          )
            ..headers.addAll({
              "Content-Type": "multipart/form-data",
              'Authorization': 'Bearer $accessToken'
            })
            ..fields['request'] = jsonEncode({
              'nickname' : dto.nickname,
              'userGender' : dto.userGender,
              'phoneNumber' : dto.phoneNumber,
              'accommodatableDogsCount' : dto.accommodatableDogsCount,
              'career' : dto.career,
              'preferredDetails' : dto.preferredDetails,
              'region' : dto.region
            });

          if (dto.profileImage != null) {

            request.files.add(await MultipartFile.fromPath(
                'profileImage',
                dto.profileImage!.path,
                filename: dto.profileImage!.path.split('/').last
            ));
          }

          debugPrint("필드: ${request.fields}");
          debugPrint("파일: ${request.files[0].contentType} ${request.files[0].field} ${request.files[0].filename}");
          debugPrint("헤더: ${request.headers}");
          debugPrint("주소: ${request.url}");
          debugPrint("메소드: ${request.method}");

          StreamedResponse streamedResponse = await request.send();

          final Response response = await Response.fromStream(streamedResponse);

          return response;
        }
    );
  }

  Future<Response> register({
    required BuildContext? context,
    required UserProfileRegisterDto dto
  }) {
    return api(
      context: context,
      func: (accessToken) async {
        MultipartRequest request = MultipartRequest(
            'POST',
            Uri.https(domain, 'api/v1/mate')
        )
          ..headers.addAll({
            "Content-Type": "multipart/form-data",
            'Authorization': 'Bearer $accessToken'
          })
          ..fields['request'] = jsonEncode({
            'nickname' : dto.nickname,
            'userGender' : dto.userGender,
            'phoneNumber' : dto.phoneNumber,
            'accommodatableDogsCount' : dto.accommodatableDogsCount,
            'career' : dto.career,
            'preferredDetails' : dto.preferredDetails,
            'region' : dto.region
          });

        if (dto.profileImage != null) {

          request.files.add(await MultipartFile.fromPath(
              'profileImage',
              dto.profileImage!.path,
              filename: dto.profileImage!.path.split('/').last
          ));
        }

        debugPrint("필드: ${request.fields}");
        debugPrint("파일: ${request.files[0].contentType} ${request.files[0].field} ${request.files[0].filename}");
        debugPrint("헤더: ${request.headers}");
        debugPrint("주소: ${request.url}");
        debugPrint("메소드: ${request.method}");

        StreamedResponse streamedResponse = await request.send();

        final Response response = await Response.fromStream(streamedResponse);

        return response;
      }
    );
  }

  Future<Response> checkNicknameDuplication({
    required BuildContext? context,
    required String nickname
  }) {
    return api(
      context: context,
      func: (accessToken) => get(
          Uri.https(domain, '/api/v1/mate/$nickname'),
          headers: <String, String> {
            'Content-type' : 'application/json',
            'Authorization' : 'Bearer $accessToken'
          }
      )
    );
  }
}