class UserProfileDTO {
  final int mateId;
  final String nickname;
  final String gender;
  final int age;
  final String birth;
  final Map<String, dynamic> preferred;
  final String region;
  final String profileImage;
  final int accommodatableDogsCount;
  final String career;

  const UserProfileDTO({
    required this.mateId,
    required this.nickname,
    required this.gender,
    required this.age,
    required this.birth,
    required this.preferred,
    required this.region,
    required this.profileImage,
    required this.accommodatableDogsCount,
    required this.career
  });

  UserProfileDTO.fromJson(Map<String, dynamic> map) :
      mateId = map['mateId'] ?? 0,
      nickname = map['nickname'] ?? '',
      gender = map['gender'] ?? '',
      age = map['age'] ?? 0,
      birth = map['birth'] ?? '',
      preferred = map['preferred'] ?? {},
      region = map['region'] ?? '',
      profileImage = map['profileImage'] ?? '',
      accommodatableDogsCount = map['accommodatableDogsCount'] ?? '',
      career = map['career'] ?? '';

  UserProfileDTO.fromEmpty() :
      mateId = 0,
      nickname = '',
      gender = '',
      age = 0,
      birth = '',
      preferred = {},
      region = '',
      profileImage = '',
      accommodatableDogsCount = 0,
      career = '';
}