class ChatRoomDto {
  final int roomId;
  final String content;
  final String lastTime;
  final String nickname;

  const ChatRoomDto({
    required this.roomId,
    required this.content,
    required this.lastTime,
    required this.nickname
  });

  ChatRoomDto.fromJson(Map<String, dynamic> map) :
    roomId = map['roomId'] ?? 0,
    content = map['content'] ?? '',
    lastTime = map['lastTime'] ?? '',
    nickname = map['nickname'] ?? '';
}