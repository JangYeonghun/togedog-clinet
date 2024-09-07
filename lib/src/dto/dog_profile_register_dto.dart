import 'package:image_picker/image_picker.dart';

class DogProfileRegisterDTO {
  final int? id;
  final String name;
  final String breed;
  final bool neutered;
  final bool dogGender;
  final double weight;
  final String region;
  final String notes;
  final List<String> tags;
  final bool vaccine;
  final int age;
  final XFile? file;

  const DogProfileRegisterDTO({
    this.id,
    required this.name,
    required this.breed,
    required this.neutered,
    required this.dogGender,
    required this.weight,
    required this.region,
    required this.notes,
    required this.tags,
    required this.vaccine,
    required this.age,
    required this.file
  });

  DogProfileRegisterDTO.fromEmpty() :
        id = 0,
        name = '',
        breed = '',
        neutered = false,
        dogGender = false,
        weight = 0.0,
        region = '',
        notes = '',
        tags = [],
        vaccine = false,
        age = 0,
        file = null;

  DogProfileRegisterDTO.fromJson(Map<String, dynamic> map) :
        id = map['id'] ?? 0,
        name = map['name'] ?? '',
        breed = map['breed'] ?? '',
        neutered = map['neutered'] ?? false,
        dogGender = map['dogGender'] ?? false,
        weight = map['weight'] ?? 0.0,
        region = map['region'] ?? '',
        notes = map['notes'] ?? '',
        tags = map['tags'] ?? [],
        vaccine = map['vaccine'] ?? false,
        age = map['age'] ?? 0,
        file = map['file'];
}