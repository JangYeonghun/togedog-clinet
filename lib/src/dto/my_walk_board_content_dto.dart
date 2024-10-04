class MyWalkBoardContentDTO {
  final int boardId;
  final int userId;
  final String title;
  final String pickUpDay;
  final String fee;
  final String startTime;
  final String endTime;
  final String pickupLocation1;
  final List<String> walkingPlaceTag;
  final String feeType;
  final String name;
  final int age;
  final String breed;
  final String dogType;
  final String dogGender;
  final String dogProfileImage;
  final String completeStatus;

  MyWalkBoardContentDTO({
    required this.boardId,
    required this.userId,
    required this.title,
    required this.pickUpDay,
    required this.fee,
    required this.startTime,
    required this.endTime,
    required this.pickupLocation1,
    required this.walkingPlaceTag,
    required this.feeType,
    required this.name,
    required this.age,
    required this.breed,
    required this.dogType,
    required this.dogGender,
    required this.dogProfileImage,
    required this.completeStatus,
  });

  factory MyWalkBoardContentDTO.fromJson(Map<String, dynamic> json) {
    return MyWalkBoardContentDTO(
      boardId: json['boardId'] ?? 0,
      userId: json['userId'] ?? 0,
      title: json['title'] ?? '',
      pickUpDay: json['pickUpDay'] ?? '',
      fee: json['fee'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      pickupLocation1: json['pickupLocation1'] ?? '',
      walkingPlaceTag: List<String>.from(json['walkingPlaceTag'] ?? []),
      feeType: json['feeType'] ?? '',
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      breed: json['breed'] ?? '',
      dogType: json['dogType'] ?? '',
      dogGender: json['dogGender'] ?? '',
      dogProfileImage: json['dogProfileImage'] ?? '',
      completeStatus: json['completeStatus'] ?? '',
    );
  }
}