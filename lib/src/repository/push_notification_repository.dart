import 'package:dog/src/interface/api.dart';
import 'package:http/http.dart';

class PushNotificationRepository extends API {
  Future<Response> unrecievedNotifications({required String lastTime}) {
    return api(
        func: (accessToken) => get(
            Uri.https(domain, '/api/v1/chat/get-unreceived-notification', {
              'lastTime' : lastTime
            }),
            headers: <String, String>{
              'Content-type' : 'application/json',
              'Authorization' : 'Bearer $accessToken'
            }
        )
    );
  }
}