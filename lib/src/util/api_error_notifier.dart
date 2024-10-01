import 'package:dog/src/util/toast_popup_util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class APIErrorNotifier {
  // Http status code에 따른 토스트 팝업
  void notify({
    required Response response,
    required BuildContext context
  }) {

    final String errMsg;
    final String errLog;

    switch (response.statusCode ~/ 100) {
      case 5:
        errMsg = '서버와의 통신에 실패했습니다.';
        errLog = 'Server Connection Error: ${response.statusCode}';
        break;
      case 4:
        errMsg = '요청에 실패했습니다.';
        errLog = 'Request Error: ${response.statusCode}';
        break;
      default:
        errMsg = '알수없는 오류가 발생했습니다.';
        errLog = 'Unknown Error: ${response.statusCode}';
        break;
    }

    ToastPopupUtil.error(context: context, content: errMsg);
    throw Exception(errLog);
  }
}