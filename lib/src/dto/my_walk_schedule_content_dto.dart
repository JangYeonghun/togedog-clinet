class OwnerScheduleContentDTO {
  final int boardId;
  final String pickUpDay;
  final String statTime;
  final String endTime;
  final String fee;
  final String mateNickname;
  final String matePhotoUrl;
  final String feeType;
  final int mateId;
  final String matchStatus;

  OwnerScheduleContentDTO({
    required this.boardId,
    required this.pickUpDay,
    required this.statTime,
    required this.endTime,
    required this.fee,
    required this.mateNickname,
    required this.matePhotoUrl,
    required this.feeType,
    required this.mateId,
    required this.matchStatus,
  });

  factory OwnerScheduleContentDTO.fromJson(Map<String, dynamic> json) {
    return OwnerScheduleContentDTO(
        boardId: json['boardId'] ?? 0,
        pickUpDay: json['pickUpDay'] ?? '',
        statTime: json['statTime'] ?? '',
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