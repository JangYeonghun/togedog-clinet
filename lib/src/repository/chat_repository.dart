import 'package:dog/src/interface/api.dart';
import 'package:image_picker/image_picker.dart';
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

  Future<Response> createRoom({
    required int receiverId
  }) {
    return api(
        func: (accessToken) => post(
            Uri.https(domain, '/api/v1/chat/get-or-create', {
              'receiver' : receiverId.toString(),
              'roomTitle' : '테스트'
            }),
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

  Future<Response> unreadMessage({required int roomId, required String lastTime}) {
    return api(
      func: (accessToken) => get(
        Uri.https(domain, '/api/v1/chat/get-unreceived-messages', {
          'roomId' : roomId.toString(),
          'lastTime' : lastTime
        }),
        headers: <String, String>{
          'Content-type' : 'application/json',
          'Authorization' : 'Bearer $accessToken'
        }
      )
    );
  }


  Future<Response> uploadImage({
    required XFile image
  }) {
    return api(func: (accessToken) async {
          MultipartRequest request = MultipartRequest(
              'POST',
              Uri.https(domain, 'api/v1/chat/get-imageUrl')
          )
            ..headers.addAll({
              "Content-Type": "multipart/form-data",
              'Authorization': 'Bearer $accessToken'
            });

          request.files.add(await MultipartFile.fromPath(
              'image',
              image.path,
              filename: image.path.split('/').last
          ));

          StreamedResponse streamedResponse = await request.send();

          final Response response = await Response.fromStream(streamedResponse);

          return response;
        }
    );
  }
}