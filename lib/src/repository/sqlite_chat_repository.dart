import 'package:dog/src/config/sqlite_config.dart';
import 'package:dog/src/dto/chat_message_dto.dart';
import 'package:dog/src/model/chat_local_model.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteChatRepository {

  Future<List<ChatMessageDTO>> selectChats({
    required int roomId,
  }) async {
    List<ChatMessageDTO> chatList = [];

    try {
      Database conn = await SQLiteConfig().database;
      String query = '''
    SELECT
      userId
      , IFNULL(content, '') AS content
      , IFNULL(image, '') AS image
      , timestamp
    FROM
      tb_chat
    WHERE
      roomId = ?
    ORDER BY
      timestamp DESC
    ''';

      List<Map<String, dynamic>> results = await conn.rawQuery(query, [roomId]);

      // UTC -> 로컬
      chatList = results.map((data) {
        String rawTimestamp = data['timestamp'] ?? '';
        DateTime parsedTimestamp;

        try {
          if (rawTimestamp.contains('Z')) {
            // ISO 8601 형식 UTC -> 로컬 시간으로 변환
            parsedTimestamp = DateTime.parse(rawTimestamp).toLocal();
          } else {
            // 일반 형식 처리
            parsedTimestamp = DateTime.parse(rawTimestamp);
          }
        } catch (e) {
          debugPrint('Timestamp parsing error: $e');
          parsedTimestamp = DateTime.now();
        }

        return ChatMessageDTO(
          userId: data['userId'] ?? 0,
          content: data['content'] ?? '',
          imgUrl: data['image'] ?? '',
          timestamp: parsedTimestamp.toString(),
        );
      }).toList();
    } catch (e) {
      debugPrint("selectChat() exception: $e");
    }

    return chatList;
  }


  // Future<void> selectLatestChat() {
  //
  // }

  Future<void> insertChat(ChatLocalModel model) async {
    try {
      Database conn = await SQLiteConfig().database;

      await conn.insert(
          'tb_chat',
          model.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace
      );
    } catch (e) {
      debugPrint("saveChat() exception: $e");
    }
  }

  Future<void> deleteChatRoom({
    required String roomId
  }) async {
    try {
      Database conn = await SQLiteConfig().database;

      await conn.delete(
          'tb_chat',
          where: 'roomId = ?',
          whereArgs: [roomId],
      );
    } catch (e) {
      debugPrint("deleteChatRoom() exception: $e");
    }
  }
}