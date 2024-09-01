import 'dart:convert';

import 'package:dog/src/config/global_variables.dart';
import 'package:dog/src/dto/dog_profile_register_dto.dart';
import 'package:dog/src/util/api_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class ProfileRepository {
  final String domain = GlobalVariables.domain;
  final int port = GlobalVariables.port;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<Response> postDogProfile({
    required BuildContext context,
    required DogProfileRegisterDTO dto
  }) async {
    final String? accessToken = await storage.read(key: 'accessToken');

    final Response response = await api(
        context: context,
        response: await post(
            Uri.http("$domain:$port", 'api/v1/dog'),
            headers: <String, String>{
              'Content-type' : 'application/json',
              'Authorization' : 'Bearer $accessToken'
            },
            body: jsonEncode({
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
        )
    );

    return response;
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
    final String? accessToken = await storage.read(key: 'accessToken');

    final Response response = await api(
        context: context,
        response: await get(
            Uri.http('$domain:$port', '/api/v1/dog'),
            headers: <String, String>{
              'Content-type' : 'application/json',
              'Authorization' : 'Bearer $accessToken'
            }
        )
    );

    return response;
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
    final String? accessToken = await storage.read(key: 'accessToken');

    final Response response = await api(
        context: context,
        response: await delete(
            Uri.http('$domain:$port', '/api/v1/dog/$dogId'),
            headers: <String, String>{
              'Content-type' : 'application/json',
              'Authorization' : 'Bearer $accessToken'
            }
        )
    );

    return response;
  }
}