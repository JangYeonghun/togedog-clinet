class SortInfoDTO {
  final bool sorted;
  final bool unsorted;
  final bool empty;

  SortInfoDTO({required this.sorted, required this.unsorted, required this.empty});

  factory SortInfoDTO.fromJson(Map<String, dynamic> json) {
    return SortInfoDTO(
      sorted: json['sorted'] ?? false,
      unsorted: json['unsorted'] ?? false,
      empty: json['empty'] ?? false,
    );
  }
}

class PageableInfo {
  final SortInfoDTO sort;
  final bool paged;
  final int pageNumber;
  final int pageSize;
  final bool unpaged;
  final int offset;

  PageableInfo({
    required this.sort,
    required this.paged,
    required this.pageNumber,
    required this.pageSize,
    required this.unpaged,
    required this.offset,
  });

  factory PageableInfo.fromJson(Map<String, dynamic> json) {
    return PageableInfo(
      sort: SortInfoDTO.fromJson(json['sort'] ?? {}),
      paged: json['paged'] ?? false,
      pageNumber: json['pageNumber'] ?? 0,
      pageSize: json['pageSize'] ?? 0,
      unpaged: json['unpaged'] ?? false,
      offset: json['offset'] ?? 0,
    );
  }
}
