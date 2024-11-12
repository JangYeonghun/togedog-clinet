class MyWalkDogInfoDTO {
  final String name;
  final int age;
  final String breed;
  final String dogType;
  final String dogGender;
  final String dogProfileImage;

  MyWalkDogInfoDTO({
    required this.name,
    required this.age,
    required this.breed,
    required this.dogType,
    required this.dogGender,
    required this.dogProfileImage,
  });

  factory MyWalkDogInfoDTO.fromJson(Map<String, dynamic> json) {
    return MyWalkDogInfoDTO(
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      breed: json['breed'] ?? '',
      dogType: json['dogType'] ?? '',
      dogGender: json['dogGender'] ?? '',
      dogProfileImage: json['dogProfileImage'] ?? '',
    );
  }
}