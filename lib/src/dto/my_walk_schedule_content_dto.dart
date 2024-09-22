class MyWalkScheduleContentDTO {
  final int boardId;
  final String pickUpDay;
  final String statrTime;
  final String endTime;
  final String fee;
  final String mateNickname;
  final String matePhotoUrl;
  final String feeType;
  final int mateId;
  final String matchStatus;

  MyWalkScheduleContentDTO({
    required this.boardId,
    required this.pickUpDay,
    required this.statrTime,
    required this.endTime,
    required this.fee,
    required this.mateNickname,
    required this.matePhotoUrl,
    required this.feeType,
    required this.mateId,
    required this.matchStatus,
  });

  factory MyWalkScheduleContentDTO.fromJson(Map<String, dynamic> json) {
    return MyWalkScheduleContentDTO(
        boardId: json['boardId'] ?? 0,
        pickUpDay: json['pickUpDay'] ?? '',
        statrTime: json['startTime'] ?? '',
        endTime: json['endTime'] ?? '',
        fee: json['fee'] ?? '',
        mateNickname: json['mateNickname'] ?? '',
        matePhotoUrl: json['matePhotoUrl'] ?? '',
        feeType: json['feeType'] ?? '',
        mateId: json['mateId'] ?? '',
        matchStatus: json['matchStatus'] ?? '',
    );
  }
}