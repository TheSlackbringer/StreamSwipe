import 'watch_provider.dart';

class Profile {
  final String id; // user_id
   String? fullName;
   String? country;
  final DateTime? createdAt; // Optional DateTime
   List<WatchProvider> watchProviders; // Optional field with a default empty list

  Profile({
    required this.id,
    this.fullName,
    this.country,
    this.createdAt,
    this.watchProviders = const [], // Default to an empty list
  });

  factory Profile.fromJson(Map<String, dynamic> json, {List<WatchProvider>? watchProviders}) {
    return Profile(
      id: json['id'] as String,
      fullName: json['full_name'] as String?,
      country: json['country'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null, // Handle null for createdAt
      watchProviders: watchProviders ?? [], // Use provided list or default to empty
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'country': country,
      'created_at': createdAt?.toIso8601String(), // Handle nullable DateTime
    };
  }
}
