import 'dart:convert';

import 'package:dog/src/util/toast_popup_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

Future<Response> api({
  required BuildContext context,
  required Response response
}) async {

  debugPrint('응답코드: ${response.statusCode}');
  debugPrint('응답: ${response.body}');

  switch (response.statusCode ~/ 100) {
    case 2:
      return response;
    case 5:
      ToastPopupUtil.error(context: context, content: '서버와의 통신에 실패했습니다.');
      throw Exception('Server Connection Error: ${response.statusCode}');
    case 4:
      ToastPopupUtil.error(context: context, content: '문제가 발생하였습니다.');
      throw Exception('Error: ${response.statusCode}');
    default:
      ToastPopupUtil.error(context: context, content: '문제가 발생하였습니다.');
      throw Exception('Error: ${response.statusCode}');
  }

}