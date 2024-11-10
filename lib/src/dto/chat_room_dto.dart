class ChatRoomDto {
  final int roomId;
  final String title;
  final String lastMessage;
  final int unreceivedMessageCount;
  final String lastTime;
  final String senderImage;

  const ChatRoomDto({
    required this.roomId,
    required this.title,
    required this.lastMessage,
    required this.unreceivedMessageCount,
    required this.lastTime,
    required this.senderImage
  });

  ChatRoomDto.fromJson(Map<String, dynamic> map) :
    roomId = map['roomId'] ?? 0,
    title = map['title'] ?? '',
    lastMessage = map['lastMessage'] ?? '',
    unreceivedMessageCount = map['unreceivedMessageCount'] ?? 0,
    lastTime = map['lastTime'] ?? '',
    senderImage = map['senderImage'] ?? '';
}