class AgentStats {
  final int totalRequests;
  final int pendingCount;
  final int acceptedCount;
  final int rejectedCount;
  final List<StatItem> stats;

  AgentStats({
    required this.totalRequests,
    required this.pendingCount,
    required this.acceptedCount,
    required this.rejectedCount,
    required this.stats,
  });

  factory AgentStats.fromJson(Map<String, dynamic> json) {
    return AgentStats(
      totalRequests: json['total_requests'] ?? 0,
      pendingCount: json['pending_count'] ?? 0,
      acceptedCount: json['accepted_count'] ?? 0,
      rejectedCount: json['rejected_count'] ?? 0,
      stats:
          (json['stats'] as List?)?.map((i) => StatItem.fromJson(i)).toList() ??
          [],
    );
  }

  factory AgentStats.empty() {
    return AgentStats(
      totalRequests: 0,
      pendingCount: 0,
      acceptedCount: 0,
      rejectedCount: 0,
      stats: [],
    );
  }
}

class StatItem {
  final String status;
  final int count;

  StatItem({required this.status, required this.count});

  factory StatItem.fromJson(Map<String, dynamic> json) {
    return StatItem(status: json['status'] ?? '', count: json['count'] ?? 0);
  }
}
