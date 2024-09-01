class DogProfileDTO {
  final int dogId;
  final String name;
  final String dogType;
  final String breed;
  final bool dogGender;
  final bool neutered;
  final int weight;
  final String region;
  final String notes;
  final String dogImage;
  final List<String> dogPersonalityTags;
  final bool vaccine;
  final int age;
  
  const DogProfileDTO({
    required this.dogId,
    required this.name,
    required this.dogType,
    required this.breed,
    required this.dogGender,
    required this.neutered,
    required this.weight,
    required this.region,
    required this.notes,
    required this.dogImage,
    required this.dogPersonalityTags,
    required this.vaccine,
    required this.age
  });

  const DogProfileDTO.fromEmpty() :
        dogId = 0,
        name = '',
        dogType = '',
        breed = '',
        dogGender = false,
        neutered = false,
        weight = 0,
        region = '',
        notes = '',
        dogImage = '',
        dogPersonalityTags = const [],
        vaccine = false,
        age = 0;

  DogProfileDTO.fromJson(Map<String, dynamic> map) :
      dogId = map['dogId'] ?? 0,
      name = map['name'] ?? '',
      dogType = map['dogType'] ?? '',
      breed = map['breed'] ?? '',
      dogGender = map['dogGender'] ?? false,
      neutered = map['neutered'] ?? false,
      weight = map['weight'] ?? 0,
      region = map['region'] ?? '',
      notes = map['notes'] ?? '',
      dogImage = map['dogImage'] ?? '',
      dogPersonalityTags = List<String>.from(map['dogPersonalityTags'] ?? []),
      vaccine = map['vaccine'] ?? false,
      age = map['age'] ?? 0;
}