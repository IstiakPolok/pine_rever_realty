import 'agent_listing_model.dart';

class AgentListingResponse {
  final List<AgentListing> results;
  final int total;
  final int page;
  final int perPage;
  final int totalPages;

  AgentListingResponse({
    required this.results,
    required this.total,
    required this.page,
    required this.perPage,
    required this.totalPages,
  });

  factory AgentListingResponse.fromJson(Map<String, dynamic> json) {
    final results =
        (json['results'] as List<dynamic>?)
            ?.map((e) => AgentListing.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    return AgentListingResponse(
      results: results,
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      perPage: json['per_page'] ?? (json['perPage'] ?? 20),
      totalPages: json['total_pages'] ?? 1,
    );
  }
}
