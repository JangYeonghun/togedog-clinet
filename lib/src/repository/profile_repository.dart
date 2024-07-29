import 'dart:convert';

import 'package:dog/src/dto/dog_profile_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class ProfileRepository {
  Future<Response> postDogProfile({
    required DogProfileDTO dto
  }) async {
    final String? accessToken = await const FlutterSecureStorage().read(key: 'accessToken');

    debugPrint("이이이이이잉");

    final Response response = await post(
      Uri.http('175.106.99.104:8080', 'api/v1/dog'),
      headers: <String, String>{
        'Content-type' : 'application/json',
        'Authorization' : 'Bearer $accessToken'
      },
      body: jsonEncode({
        "name": dto.name,
        "breed": dto.breed,
        "vaccine": dto.vaccine,
        "neutered": dto.neutered,
        "dogGender": dto.dogGender,
        "weight": dto.weight,
        "region": dto.region,
        "notes": dto.notes,
        "tags": dto.tags,
        "age": dto.age
      })
    );

    debugPrint("웨안댐?");

    debugPrint(response.body);
    return response;
  }
}