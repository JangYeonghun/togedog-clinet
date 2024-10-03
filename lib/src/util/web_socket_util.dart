import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebSocketUtil {
  final String url;

  const WebSocketUtil({required this.url});

  Future<void> connect() async {
    final channel = WebSocketChannel.connect(Uri.parse(url));

    await channel.ready;
    debugPrint('준비완료');

    channel.stream.listen((message) {
      debugPrint(message);
      channel.sink.add('received!');
      channel.sink.close(status.goingAway);
    });
  }
}