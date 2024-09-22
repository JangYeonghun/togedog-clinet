import 'package:image_picker/image_picker.dart';

class UserProfileRegisterDto {
  final String nickname;
  final String userGender;
  final String phoneNumber;
  final int accommodatableDogsCount;
  final String career;
  final Map<String, dynamic> preferredDetails;
  final String region;
  final XFile? profileImage;
  
  const UserProfileRegisterDto({
    required this.nickname,
    required this.userGender,
    required this.phoneNumber,
    required this.accommodatableDogsCount,
    required this.career,
    required this.preferredDetails,
    required this.region,
    required this.profileImage
  });
}