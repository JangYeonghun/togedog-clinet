class ChatMessageDTO {
  final int userId;
  final String content;
  final String imgUrl;
  final String timestamp;

  const ChatMessageDTO({
    required this.userId,
    required this.content,
    required this.imgUrl,
    required this.timestamp
  });

  ChatMessageDTO.fromJson(Map<String, dynamic> map) :
    userId = map['userId'],
    content = map['content'],
    imgUrl = map['image'],
    timestamp = map['lastTime'];
}