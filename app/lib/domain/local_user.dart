import '../infrastructure/repositories/region_repository.dart';

class User {
  final String country;
  final List<String> watchProviders;

  User({
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
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      country: json['country'],
      watchProviders: List<String>.from(json['watchProviders']),
    );
  }

  /// Lookup ISO code from the region repository
  Future<String?> getIsoCode() async {
    final regionRepository = RegionRepository();
    final regionMap = await regionRepository.getRegionMap();
    return regionMap[country];
  }
}