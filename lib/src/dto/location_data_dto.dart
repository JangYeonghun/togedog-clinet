class LocationDataDTO {
  final double latitude;
  final double longitude;
  final String address;

  const LocationDataDTO({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  // 빈 데이터를 위한 생성자
  LocationDataDTO.fromEmpty()
      : latitude = 0.0,
        longitude = 0.0,
        address = '';

  // 비어 있는지 확인하는 메소드
  bool isEmpty() {
    return latitude == 0.0 && longitude == 0.0 && address.isEmpty;
  }
}
