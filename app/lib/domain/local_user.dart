import '../infrastructure/repositories/region_repository.dart';

class LocalUser {
   String country;
   List<String> watchProviders;

  LocalUser({
    required this.country,
    required this.watchProviders,
  });

  /// Convert the user to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'country': country,
      'watchProviders': watchProviders,
    };
  }

  /// Create a user object from JSON
  factory LocalUser.fromJson(Map<String, dynamic> json) {
    return LocalUser(
      country: json['country'],
      watchProviders: List<String>.from(json['watchProviders']),
    );
  }
}