import 'package:dog/src/dto/my_walk_dog_info_dto.dart';

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
  final List<MyWalkDogInfoDTO> dogs;
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
    required this.dogs,
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
      dogs: (json['dogs'] as List<dynamic>?)
          ?.map((item) => MyWalkDogInfoDTO.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      completeStatus: json['completeStatus'] ?? '',
    );
  }
}