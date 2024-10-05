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

  Future<Response> createRoom() {
    return api(
        func: (accessToken) => get(
            Uri.https(domain, 'api/v1/chat'),
            headers: <String, String>{
              'Content-type' : 'application/json',
              'Authorization' : 'Bearer $accessToken'
            }
        )
    );
  }

  Future<Response> chatList() {
    return api(
        func: (accessToken) => get(
            Uri.https(domain, 'api/v1/chat/chatroom-list'),
            headers: <String, String>{
              'Content-type' : 'application/json',
              'Authorization' : 'Bearer $accessToken'
            }
        )
    );
  }

}