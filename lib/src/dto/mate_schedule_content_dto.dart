import 'package:dog/src/dto/my_walk_dog_info_dto.dart';

class MateScheduleContentDTO {
  final int boardId;
  final int userId;
  final String title;
  final String pickUpDay;
  final String statTime;
  final String endTime;
  final String pickupLocation1;
  final List<String> walkingPlaceTag;
  final String feeType;
  final List<MyWalkDogInfoDTO> dogs;
  final String fee;
  final String completeStatus;


  MateScheduleContentDTO({
    required this.boardId,
    required this.userId,
    required this.title,
    required this.pickUpDay,
    required this.statTime,
    required this.endTime,
    required this.pickupLocation1,
    required this.walkingPlaceTag,
    required this.feeType,
    required this.dogs,
    required this.fee,
    required this.completeStatus,
  });

  factory MateScheduleContentDTO.fromJson(Map<String, dynamic> json) {
    return MateScheduleContentDTO(
      boardId: json['boardId'] ?? 0,
      userId: json['userId'] ?? 0,
      title: json['title'] ?? '',
      pickUpDay: json['pickUpDay'] ?? '',
      statTime: json['statTime'] ?? '',
      endTime: json['endTime'] ?? '',
      pickupLocation1: json['pickupLocation1'] ?? '',
      walkingPlaceTag: List<String>.from(json['walkingPlaceTag'] ?? []),
      feeType: json['feeType'] ?? '',
      dogs: (json['dogs'] as List<dynamic>?)
          ?.map((item) => MyWalkDogInfoDTO.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      fee: json['fee'] ?? '',
      completeStatus: json['completeStatus'] ?? '',
    );
  }
}