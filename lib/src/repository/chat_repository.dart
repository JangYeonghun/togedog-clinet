import 'package:dog/src/interface/api.dart';
import 'package:http/http.dart';

class ChatRepository extends API {

  Future<Response> postFCMToken({required String? token}) {
    return api(
      func: (accessToken) => post(
        Uri.https(domain, 'api/v1/fcm/create'),
        headers: <String, String>{
          'Content-type' : 'application/json',
          'Authorization' : 'Bearer $accessToken'
        },
        body: token
      )
    );
  }

}