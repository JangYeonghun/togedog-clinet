import 'dart:convert';

import 'package:dog/src/util/common_scaffold_util.dart';
import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
class WebSocketUtil extends StatefulWidget {
  final int roomId;
  const WebSocketUtil({super.key, required this.roomId});

  @override
  State<WebSocketUtil> createState() => _WebSocketUtilState();
}

class _WebSocketUtilState extends State<WebSocketUtil> {
  late final StompClient client;

  @override
  void initState() {
    connect();
    super.initState();
  }

  @override
  void dispose() {
    client.deactivate();
    super.dispose();
  }

  void connect() {
    client = StompClient(
        config: StompConfig.sockJS(
          url: "https://www.walktogedog.life/ws",
          onConnect: onConnectCallback,
          onWebSocketError: (dynamic error) => debugPrint('STOMP_ERR: $error'),
        )
    );
    debugPrint('Connecting...');
    client.activate();
  }

  void onConnectCallback(StompFrame connectFrame) {
    debugPrint('callback');
    debugPrint('Connection: ${client.connected}, ${client.isActive}');
    client.subscribe(
        destination: '/sub/chat/room/${widget.roomId}',
        callback: (stompFrame) {
          debugPrint('Message received');
          debugPrint(stompFrame.body);
        }
    );
  }

  void send() {
    final Map<String, dynamic> message = {
      'roomId': widget.roomId,
      'userId': 3,
      'content': 'test',
      'lastTime': DateTime.now().toIso8601String(),
      'image': ''
    };

    debugPrint('Send message');

    client.send(
      destination: '/pub/chat',
      body: jsonEncode(message)
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffoldUtil(
      body: Center(
        child: GestureDetector(
          onTap: () => send(),
          child: const Text(
            'SEND',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20
            ),
          )
        ),
      )
    );
  }
}
