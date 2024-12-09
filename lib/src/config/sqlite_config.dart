import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteConfig {
  // 내부에서 사용하는 정적 인스턴스 변수
  static final SQLiteConfig instance = SQLiteConfig._instance();

  Database? _database;

  // 실제 생성자(외부에서 접근 불가)
  SQLiteConfig._instance() {
    _init();
  }

  // factory 생성자를 통해 인스턴스를 반환
  factory SQLiteConfig() => instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    await _init();
    return _database!;
  }

  Future<void> _init() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'local.db'),
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: _onConfigure,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    String createChatQuery = '''
      CREATE TABLE IF NOT EXISTS tb_chat (
        roomId INTEGER
        , userId INTEGER
        , content TEXT
        , image TEXT
        , timestamp TEXT
      );
     ''';
    await db.execute(createChatQuery);

    // 인덱스 추가
    await db.execute(
        'CREATE INDEX idx_tb_chat_roomId ON tb_chat (roomId);'
    );

  }

  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  static Future<void> _onConfigure(Database db) async {}
}