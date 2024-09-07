class UserProfileDTO {
  final String nickname;
  final String gender;
  final int age;
  final String birth;
  final Map<String, Map<String, List<String>>> preferred;
  final String region;
  final String profileImage;
  final int accommodatableDogsCount;
  final String career;
  final String preferredRegion;

  const UserProfileDTO({
    required this.nickname,
    required this.gender,
    required this.age,
    required this.birth,
    required this.preferred,
    required this.region,
    required this.profileImage,
    required this.accommodatableDogsCount,
    required this.career,
    required this.preferredRegion
  });

  UserProfileDTO.fromJson(Map<String, dynamic> map) :
      nickname = map['nickname'] ?? '',
      gender = map['gender'] ?? '',
      age = map['age'] ?? 0,
      birth = map['birth'] ?? '',
      preferred = map['preferred'] ?? {},
      region = map['region'] ?? '',
      profileImage = map['profileImage'] ?? '',
      accommodatableDogsCount = map['accommodatableDogsCount'] ?? '',
      career = map['career'] ?? '',
      preferredRegion = map['preferredRegion'] = '';
}