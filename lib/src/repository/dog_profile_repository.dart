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
      func: (accessToken) async {
        MultipartRequest request = MultipartRequest(
            'POST',
            Uri.https(domain, 'api/v1/dog')
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

        StreamedResponse streamedResponse = await request.send();

        final Response response = await Response.fromStream(streamedResponse);

        return response;
      }
    );
  }

  Future<Response> update({
    required BuildContext? context,
    required DogProfileRegisterDTO dto
  }) async {
    return api(
        context: context,
        func: (accessToken) async {
          MultipartRequest request = MultipartRequest(
              'PATCH',
              Uri.https(domain, 'api/v1/dog')
          )
            ..headers.addAll({
              "Content-Type": "multipart/form-data",
              'Authorization': 'Bearer $accessToken'
            })
            ..fields['request'] = jsonEncode({
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
            });

          if (dto.file != null) {

            request.files.add(await MultipartFile.fromPath(
                'profileImage',
                dto.file!.path,
                filename: dto.file!.path.split('/').last
            ));
          }

          StreamedResponse streamedResponse = await request.send();

          final Response response = await Response.fromStream(streamedResponse);

          return response;
        }
    );
  }

  Future<Response> getList({
    required BuildContext? context
  }) {
    return api(
      context: context,
      func: (accessToken) => get(
          Uri.https(domain, '/api/v1/dog'),
          headers: <String, String>{
            'Content-type' : 'application/json',
            'Authorization' : 'Bearer $accessToken'
          }
      )
    );
  }

  Future<Response> selectWithId({
    required int dogId
  }) async {
    return api(
      func: (accessToken) => get(
          Uri.https(domain, '/api/v1/dog/$dogId'),
          headers: <String, String>{
            'Content-type' : 'application/json',
            'Authorization' : 'Bearer $accessToken'
          }
      )
    );
  }

  Future<Response> remove({
    required BuildContext? context,
    required int dogId
  }) {
    return api(
      context: context,
      func: (accessToken) => delete(
          Uri.https(domain, '/api/v1/dog/$dogId'),
          headers: <String, String>{
            'Content-type' : 'application/json',
            'Authorization' : 'Bearer $accessToken'
          }
      )
    );
  }

  Future<Response> getRandomDogs({
    required BuildContext? context,
    required int page,
    required int size
  }) {
    return api(
        context: context,
        func: (accessToken) => get(
            Uri.https(domain, '/api/v1/dog/random', {
              'page' : page.toString(),
              'size' : size.toString()
            }),
            headers: <String, String>{
              'Content-type' : 'application/json',
              'Authorization' : 'Bearer $accessToken'
            },
        )
    );
  }
}