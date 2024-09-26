import 'package:dog/src/dto/time_of_day_dto.dart';

class WalkBoardDTO {
  final String title;
  final List<String> tag;
  final String pickupLocation1;
  final double mapX;
  final double mapY;
  final List<int> dogIds;
  final String pickUpDay;
  final String startTime;
  final String endTime;
  final String feeType;
  final int fee;
  final String phoneNumber;

  WalkBoardDTO({
    required this.title,
    required this.tag,
    required this.pickupLocation1,
    required this.mapX,
    required this.mapY,
    required this.dogIds,
    required this.pickUpDay,
    required this.startTime,
    required this.endTime,
    required this.feeType,
    required this.fee,
    required this.phoneNumber,
  });

  factory WalkBoardDTO.fromJson(Map<String, dynamic> json) {
    return WalkBoardDTO(
      title: json['title'],
      tag: List<String>.from(json['tag']),
      pickupLocation1: json['pickupLocation1'],
      mapX: json['mapX'],
      mapY: json['mapY'],
      dogIds: json['dogIds'],
      pickUpDay: json['pickUpDay'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      feeType: json['feeType'],
      fee: json['fee'],
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'tag': tag,
      'pickupLocation1': pickupLocation1,
      'mapX': mapX,
      'mapY': mapY,
      'dogIds': dogIds,
      'pickUpDay': pickUpDay,
      'startTime': startTime,
      'endTime': endTime,
      'feeType': feeType,
      'fee': fee,
      'phoneNumber': phoneNumber,
    };
  }
}