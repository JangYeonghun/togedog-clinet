import 'package:dog/src/interface/api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class UserProfileRepository extends API {

  Future<Response> getProfile({
    required BuildContext context
  }) {
    return api(
      func: () {
        return storage.read(key: 'accessToken').then((accessToken) {
          return get(
            Uri.http('$domain:$port', '/api/v1/mate'),
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