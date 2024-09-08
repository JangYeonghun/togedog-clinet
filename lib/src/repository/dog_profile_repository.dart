import 'dart:convert';

import 'package:dog/src/dto/dog_profile_register_dto.dart';
import 'package:dog/src/interface/api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class DogProfileRepository extends API {

  Future<Response> register({
    required BuildContext? context,
    required DogProfileRegisterDTO dto
  }) {
    return api(
      context: context,
      func: () {
        return storage.read(key: 'accessToken').then((accessToken) async {
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
        });
      }
    );
  }

  Future<Response> update({
    required BuildContext? context,
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

  Future<Response> getList({
    required BuildContext? context
  }) {
    return api(
      context: context,
      func: () {
        return storage.read(key: 'accessToken').then((accessToken) {
          return get(
              Uri.http('$domain:$port', '/api/v1/dog'),
              headers: <String, String>{
                'Content-type' : 'application/json',
                'Authorization' : 'Bearer $accessToken'
              }
          );
        });
      }
    );
  }

  Future<Response> selectWithId({
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

  Future<Response> remove({
    required BuildContext? context,
    required int dogId
  }) {
    return api(
      context: context,
      func: () {
        return storage.read(key: 'accessToken').then((accessToken) {
          return delete(
            Uri.http('$domain:$port', '/api/v1/dog/$dogId'),
            headers: <String, String>{
              'Content-type' : 'application/json',
              'Authorization' : 'Bearer $accessToken'
            }
          );
        });
      }
    );
  }
}