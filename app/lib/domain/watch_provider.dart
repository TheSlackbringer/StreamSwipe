class WatchProvider {
  final int providerId; // Matches provider_id in the table
  final DateTime createdAt;

  WatchProvider({
    required this.providerId,
    required this.createdAt,
  });

  factory WatchProvider.fromJson(Map<String, dynamic> json) {
    return WatchProvider(
      providerId: json['provider_id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'provider_id': providerId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
