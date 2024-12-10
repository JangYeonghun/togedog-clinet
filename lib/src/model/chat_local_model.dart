class ChatLocalModel {
  final int roomId;
  final int userId;
  final String content;
  final String image;
  final String timeStamp;

  const ChatLocalModel({
    required this.roomId,
    required this.userId,
    required this.content,
    required this.image,
    required this.timeStamp
  });

  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'userId': userId,
      'content': content,
      'image': image,
      'timeStamp': timeStamp,
    };
  }
}