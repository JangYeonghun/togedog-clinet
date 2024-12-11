import 'dart:convert';

import 'package:dog/src/dto/walk_board_dto.dart';
import 'package:dog/src/interface/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

class WalkingRepository extends API {

  Future<Response> register({
    required BuildContext? context,
    required WalkBoardDTO dto
  }) {
    return api(
      func: (accessToken) async {
        Uri url = Uri.https(domain, 'api/v1/board');
        final response = await post(
          url,
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $accessToken'
          },
          body: jsonEncode(dto.toJson()),
        );

        return response;
      }
    );
  }
}