import 'package:dog/src/dto/time_of_day_dto.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class WalkBoardDTO {
  final String title;
  final List<String> tag;
  final String pickupLocation1;
  final double mapX;
  final double mapY;
  final bool dogGender;
  final int dogId;
  final DateTime pickUpDay;
  final TimeOfDayDTO startTime;
  final TimeOfDayDTO endTime;
  final String feeType;
  final int fee;
  final String phoneNumber;

  WalkBoardDTO({
    required this.title,
    required this.tag,
    required this.pickupLocation1,
    required this.mapX,
    required this.mapY,
    required this.dogGender,
    required this.dogId,
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
      dogGender: json['dogGender'],
      dogId: json['dog_id'],
      pickUpDay: DateTime.parse(json['pickUpDay']),
      startTime: TimeOfDayDTO(
        hour: json['startTime']['hour'],
        minute: json['startTime']['minute'],
        second: json['startTime']['second'],
        nano: json['startTime']['nano'],
      ),
      endTime: TimeOfDayDTO(
        hour: json['endTime']['hour'],
        minute: json['endTime']['minute'],
        second: json['endTime']['second'],
        nano: json['endTime']['nano'],
      ),
      feeType: json['feeType'],
      fee: json['fee'],
      phoneNumber: json['phoneNumber'],
    );
  }
}