import 'package:dog/src/interface/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';

class MyWalkRepository extends API {

  Future<Response> ownerScheduleList({
    required BuildContext context,
    required int page,
    required int size
  }) {
    return api(
      func: (accessToken) => get(
          Uri.https(domain, '/api/v1/owner/mySchedule', {
            'page': page.toString(),
            'size': size.toString()
          }),
          headers: <String, String> {
            'Content-type': 'application/json',
            'Authorization': 'Bearer $accessToken'
          }
      )
    );
  }

  Future<Response> myWalkList({
    required BuildContext context,
    required int page,
    required int size
  }) {
    return api(
      func: (accessToken) => get(
          Uri.https(domain, '/api/v1/owner/myWalking', {
            'page': page.toString(),
            'size': size.toString()
          }),
          headers: <String, String> {
            'Content-type': 'application/json',
            'Authorization': 'Bearer $accessToken'
          }
      )
    );
  }

  Future<Response> mateScheduleList({
    required BuildContext context,
    required int page,
    required int size
  }) {
    return api(
        func: (accessToken) => get(
            Uri.https(domain, '/api/v1/mate/mySchedule', {
              'page': page.toString(),
              'size': size.toString()
            }),
            headers: <String, String> {
              'Content-type': 'application/json',
              'Authorization': 'Bearer $accessToken'
            }
        )
    );
  }

  Future<Response> matchMate({
    required BuildContext context,
    required String name
  }) {
    return api(
        func: (accessToken) => get(
          Uri.https(domain, '/api/v1/mate/keyword/$name'),
          headers: <String, String> {
            'Content-type': 'application/json',
            'Authorization': 'Bearer $accessToken'
          }
        )
    );
  }
}