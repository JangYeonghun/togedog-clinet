import 'package:dog/src/interface/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class MyWalkRepository extends API {

  Future<Response> myWalkScheduleList({
    required BuildContext context
  }) {
    return api(
      context: context,
      func: () {
        return storage.read(key: 'accessToken').then((accessToken) {
          return get(
              Uri.http('$domain:$port', '/api/v1/owner/mySchedule'),
              headers: <String, String> {
                'Content-type': 'application/json',
                'Authorization': 'Bearer $accessToken'
              }
          );
        });
      }
    );
  }

  Future<Response> myWalkList({
    required BuildContext context
  }) {
    return api(
      context: context,
      func: () {
        return storage.read(key: 'accessToken').then((accessToken) {
          return get(
            Uri.http('$domain:$port', '/api/v1/owner/myWalking'),
            headers: <String, String> {
              'Content-type': 'application/json',
              'Authorization': 'Bearer $accessToken'
            }
          );
        });
      }
    );
  }
}