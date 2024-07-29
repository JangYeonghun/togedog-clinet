class DogProfileDTO {
  final String name;
  final String breed;
  final bool vaccine;
  final bool dogGender;
  final bool neutered;
  final double weight;
  final String region;
  final String notes;
  final List<String> tags;
  final int age;
  
  const DogProfileDTO({
    required this.name,
    required this.breed,
    required this.vaccine,
    required this.dogGender,
    required this.neutered,
    required this.weight,
    required this.region,
    required this.notes,
    required this.tags,
    required this.age
  });

  DogProfileDTO.fromEmpty() :
        name = '',
        breed = '',
        vaccine = false,
        dogGender = false,
        neutered = false,
        weight = 0.0,
        region = '',
        notes = '',
        tags = [],
        age = 0;

  DogProfileDTO.fromJson(Map<String, dynamic> map) :
      name = map['name'] ?? '',
      breed = map['breed'] ?? '',
      vaccine = map['vaccine'] ?? false,
      dogGender = map['dogGender'] ?? false,
      neutered = map['neutered'] ?? false,
      weight = map['weight'] ?? 0.0,
      region = map['region'] ?? '',
      notes = map['notes'] ?? '',
      tags = map['tags'] ?? [],
      age = map['age'] ?? 0;
}