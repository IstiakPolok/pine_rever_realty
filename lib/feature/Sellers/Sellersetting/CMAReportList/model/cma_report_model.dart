class CMAReportFile {
  final int id;
  final String file;
  final String fileUrl;
  final String originalFilename;
  final String fileExtension;
  final double fileSizeMb;
  final DateTime createdAt;

  CMAReportFile({
    required this.id,
    required this.file,
    required this.fileUrl,
    required this.originalFilename,
    required this.fileExtension,
    required this.fileSizeMb,
    required this.createdAt,
  });

  factory CMAReportFile.fromJson(Map<String, dynamic> json) {
    return CMAReportFile(
      id: json['id'],
      file: json['file'],
      fileUrl: json['file_url'],
      originalFilename: json['original_filename'],
      fileExtension: json['file_extension'],
      fileSizeMb: (json['file_size_mb'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class CMAReport {
  final int id;
  final String documentType;
  final String title;
  final String? description;
  final String? fileUrl;
  final String fileExtension;
  final double fileSizeMb;
  final List<CMAReportFile> files;
  final String? cmaStatus;
  final String? cmaDocumentStatus;
  final String? sellingAgreementFile;
  final String? sellingAgreementUrl;
  final String? agreementStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int sellingRequestId;
  final String sellingRequestContactName;
  final String sellingRequestContactEmail;
  final String sellingRequestContactPhone;
  final String sellingRequestPropertyLocation;
  final String sellingRequestAskingPrice;
  final String sellingRequestStatus;
  final String sellingRequestStartDate;
  final String sellingRequestEndDate;
  final String sellingRequestReason;
  final int agentId;

  CMAReport({
    required this.id,
    required this.documentType,
    required this.title,
    required this.description,
    required this.fileUrl,
    required this.fileExtension,
    required this.fileSizeMb,
    required this.files,
    required this.cmaStatus,
    required this.cmaDocumentStatus,
    required this.sellingAgreementFile,
    required this.sellingAgreementUrl,
    required this.agreementStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.sellingRequestId,
    required this.sellingRequestContactName,
    required this.sellingRequestContactEmail,
    required this.sellingRequestContactPhone,
    required this.sellingRequestPropertyLocation,
    required this.sellingRequestAskingPrice,
    required this.sellingRequestStatus,
    required this.sellingRequestStartDate,
    required this.sellingRequestEndDate,
    required this.sellingRequestReason,
    required this.agentId,
  });

  factory CMAReport.fromJson(Map<String, dynamic> json) {
    return CMAReport(
      id: json['id'],
      documentType: json['document_type'],
      title: json['title'],
      description: json['description'],
      fileUrl: json['file_url'],
      fileExtension: json['file_extension'] ?? '',
      fileSizeMb: (json['file_size_mb'] as num?)?.toDouble() ?? 0.0,
      files:
          (json['files'] as List?)
              ?.map((e) => CMAReportFile.fromJson(e))
              .toList() ??
          [],
      cmaStatus: json['cma_status'],
      cmaDocumentStatus: json['cma_document_status'],
      sellingAgreementFile: json['selling_agreement_file'],
      sellingAgreementUrl: json['selling_agreement_url'],
      agreementStatus: json['agreement_status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      sellingRequestId: json['selling_request_id'],
      sellingRequestContactName: json['selling_request_contact_name'],
      sellingRequestContactEmail: json['selling_request_contact_email'],
      sellingRequestContactPhone: json['selling_request_contact_phone'],
      sellingRequestPropertyLocation: json['selling_request_property_location'],
      sellingRequestAskingPrice: json['selling_request_asking_price'],
      sellingRequestStatus: json['selling_request_status'],
      sellingRequestStartDate: json['selling_request_start_date'],
      sellingRequestEndDate: json['selling_request_end_date'],
      sellingRequestReason: json['selling_request_reason'],
      agentId: json['agent_id'],
    );
  }
}

class CMAReportListResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<CMAReport> results;

  CMAReportListResponse({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory CMAReportListResponse.fromJson(Map<String, dynamic> json) {
    return CMAReportListResponse(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List)
          .map((e) => CMAReport.fromJson(e))
          .toList(),
    );
  }
}
