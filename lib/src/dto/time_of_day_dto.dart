import 'package:flutter/material.dart';

class TimeOfDayDTO {
  final int hour;
  final int minute;
  final int second;
  final int nano;

  TimeOfDayDTO({
    required this.hour,
    required this.minute,
    required this.second,
    required this.nano,
  });

  factory TimeOfDayDTO.fromJson(Map<String, dynamic> json) {
    return TimeOfDayDTO(
        hour: json['hour'] ?? 0,
        minute: json['minute'] ?? 0,
        second: json['second'] ?? 0,
        nano: json['nano'] ?? 0,
    );
  }
}