import 'package:dog/src/config/sqlite_config.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteChatRepository {
  Future<void> selectChat({
    required int roomId
  }) async {
    Database conn = await SQLiteConfig().database;
    String query = '''
      SELECT
        *
      FROM
        tb_chat
      WHERE
        roomId = $roomId
      ORDER BY
        timeStamp
      ASC
      ''';
    await conn.rawQuery(query);
  }

  Future<void> saveChat({
    required int roomId,
    required String chat,
  }) async {

  }

}