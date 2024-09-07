import 'dart:convert';

import 'package:dog/src/config/global_variables.dart';
import 'package:dog/src/dto/dog_profile_register_dto.dart';
import 'package:dog/src/interface/api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ProfileRepository extends API {
  final String domain = GlobalVariables.domain;
  final int port = GlobalVariables.port;

  Future<Response> postDogProfile({
    required BuildContext context,
    required DogProfileRegisterDTO dto
  }) async {
    final String? accessToken = await storage.read(key: 'accessToken');

    return await api(
      func: () async {
        MultipartRequest request = MultipartRequest(
            'POST',
            Uri.http('$domain:$port', 'api/v1/dog')
        )
          ..headers.addAll({
            "Content-Type": "multipart/form-data",
            'Authorization': 'Bearer $accessToken'
          })
          ..fields['request'] = jsonEncode({
            'name' : dto.name,
            'breed' : dto.breed,
            'neutered' : dto.neutered,
            'dogGender' : dto.dogGender,
            'weight' : dto.weight,
            'region' : dto.region,
            'notes' : dto.notes,
            'tags' : dto.tags,
            'vaccine' : dto.vaccine,
            'age' : dto.age
          });

        if (dto.file != null) {

          request.files.add(await MultipartFile.fromPath(
              'profileImage',
              dto.file!.path,
              filename: dto.file!.path.split('/').last
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

  Future<Response> updateDogProfile({
    required DogProfileRegisterDTO dto
  }) async {
    final String? accessToken = await storage.read(key: 'accessToken');

    final Response response = await patch(
      Uri.http('$domain:$port', '/api/v1/dog'),
      headers: <String, String>{
        'Content-type' : 'application/json',
        'Authorization' : 'Bearer $accessToken'
      },
      body: jsonEncode({
        'id' : dto.id,
        'name' : dto.name,
        'breed' : dto.breed,
        'neutered' : dto.neutered,
        'dogGender' : dto.dogGender,
        'weight' : dto.weight,
        'region' : dto.region,
        'notes' : dto.notes,
        'tags' : dto.tags,
        'vaccine' : dto.vaccine,
        'age' : dto.age
      })
    );

    return response;
  }

  Future<Response> getDogProfileList({
    required BuildContext context
  }) async {
    return await storage.read(key: 'accessToken').then((accessToken) async {
      return await api(
          context: context,
          func: () => get(
              Uri.http('$domain:$port', '/api/v1/dog'),
              headers: <String, String>{
                'Content-type' : 'application/json',
                'Authorization' : 'Bearer $accessToken'
              }
          )
      );
    });
  }

  Future<Response> getDogProfile({
    required int dogId
  }) async {
    final String? accessToken = await storage.read(key: 'accessToken');

    final Response response = await get(
        Uri.http('$domain:$port', '/api/v1/dog/$dogId'),
        headers: <String, String>{
          'Content-type' : 'application/json',
          'Authorization' : 'Bearer $accessToken'
        }
    );

    return response;
  }

  Future<Response> deleteDogProfile({
    required BuildContext context,
    required int dogId
  }) async {
    return await storage.read(key: 'accessToken').then((accessToken) async {
      return await api(
          context: context,
          func: () => delete(
              Uri.http('$domain:$port', '/api/v1/dog/$dogId'),
              headers: <String, String>{
                'Content-type' : 'application/json',
                'Authorization' : 'Bearer $accessToken'
              }
          )
      );
    });
  }

  Future<Response> getUserProfile({
    required BuildContext context
  }) async {
    return await storage.read(key: 'accessToken').then((accessToken) async {
      return await api(
          context: context,
          func: () => get(
              Uri.http('$domain:$port', '/api/v1/mate'),
              headers: <String, String>{
                'Content-type' : 'application/json',
                'Authorization' : 'Bearer $accessToken'
              }
          )
      );
    });
  }
}