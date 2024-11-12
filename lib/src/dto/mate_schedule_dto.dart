import 'package:dog/src/dto/mate_schedule_content_dto.dart';
import 'package:dog/src/dto/sort_info_dto.dart';

class MateScheduleDTO {
  final int totalPages;
  final int totalElements;
  final SortInfoDTO sort;
  final bool first;
  final bool last;
  final int number;
  final int numberOfElements;
  final PageableInfo pageable;
  final int size;
  final List<MateScheduleContentDTO> content;
  final bool empty;

  MateScheduleDTO({
    required this.totalPages,
    required this.totalElements,
    required this.sort,
    required this.first,
    required this.last,
    required this.number,
    required this.numberOfElements,
    required this.pageable,
    required this.size,
    required this.content,
    required this.empty,
  });

  factory MateScheduleDTO.fromJson(Map<String, dynamic> json) {
    return MateScheduleDTO(
      totalPages: json['totalPages'] ?? 0,
      totalElements: json['totalElements'] ?? 0,
      sort: SortInfoDTO.fromJson(json['sort'] ?? {}),
      first: json['first'] ?? false,
      last: json['last'] ?? false,
      number: json['number'] ?? 0,
      numberOfElements: json['numberOfElements'] ?? 0,
      pageable: PageableInfo.fromJson(json['pageable'] ?? {}),
      size: json['size'] ?? 0,
      content: (json['content'] as List<dynamic>?)
          ?.map((item) => MateScheduleContentDTO.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      empty: json['empty'] ?? true,
    );
  }
}