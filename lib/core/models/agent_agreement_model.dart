class AgentAgreement {
  final int id;
  final String sellerName;
  final String sellingRequestPropertyLocation;
  final String sellingRequestAskingPrice;
  final String sellingAgreementFile;
  final String agreementStatus;
  final String createdAt;

  AgentAgreement({
    required this.id,
    required this.sellerName,
    required this.sellingRequestPropertyLocation,
    required this.sellingRequestAskingPrice,
    required this.sellingAgreementFile,
    required this.agreementStatus,
    required this.createdAt,
  });

  factory AgentAgreement.fromJson(Map<String, dynamic> json) {
    return AgentAgreement(
      id: json['id'] ?? 0,
      sellerName: json['seller_name'] ?? '',
      sellingRequestPropertyLocation:
          json['selling_request_property_location'] ?? '',
      sellingRequestAskingPrice: json['selling_request_asking_price'] ?? '',
      sellingAgreementFile: json['selling_agreement_file'] ?? '',
      agreementStatus: json['agreement_status'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}

class AgentAgreementResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<AgentAgreement> results;

  AgentAgreementResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory AgentAgreementResponse.fromJson(Map<String, dynamic> json) {
    return AgentAgreementResponse(
      count: json['count'] ?? 0,
      next: json['next'],
      previous: json['previous'],
      results:
          (json['agreements'] as List?)
              ?.map((item) => AgentAgreement.fromJson(item))
              .toList() ??
          [],
    );
  }
}
