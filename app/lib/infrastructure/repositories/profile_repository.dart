import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/profile.dart';
import '../../domain/watch_provider.dart';
import '../supabase_table.dart';

class ProfileRepository {
  final Supabase _supabase;
  final ProfileTable _profileTable;
  //final WatchProvidersTable _watchProvidersTable;


  const ProfileRepository(this._supabase, this._profileTable);

  /// Fetch a single user profile by ID
  Future<Profile?> getProfile(String userId) async {
    try {
      final response = await _supabase.client
          .from(_profileTable.tableName)
          .select()
          .eq(_profileTable.idColumn, userId)
          .single();
      // Map response to Profile model
      return Profile.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      // Handle errors (e.g., network issues, parsing issues)
      print("Error fetching profile for user ID $userId: $e");
      return null;
    }
  }


  Future<void> saveProfile(Profile profile) async {
    try {
      // Upsert the profile (insert if it doesn't exist, update if it does)
       await _supabase.client
          .from(_profileTable.tableName)
          .update({
        _profileTable.fullNameColumn: profile.fullName,
        _profileTable.countryColumn: profile.country,
      })
          .eq(_profileTable.idColumn, profile.id);

    } catch (e) {
      print("Error saving profile: $e");
      throw Exception("Error saving profile.");
    }
  }

  /*Future<Profile?> getProfileWithWatchProviders(String userId) async {
    try {
      // Fetch profile with related watch providers
      final response = await _supabase.client
          .from(_profileTable.tableName)
          .select('''
            ${_profileTable.idColumn},
            ${_profileTable.fullNameColumn},
            ${_profileTable.countryColumn},
            ${_watchProvidersTable.tableName} (
              ${_watchProvidersTable.providerIdColumn}
            )
          ''')
          .eq(_profileTable.idColumn, userId)
          .single();

      // Parse the watch providers if present
      final watchProvidersData =
          response[_watchProvidersTable.tableName] as List<dynamic>? ?? [];
      final watchProviders = watchProvidersData
          .map((wp) => WatchProvider.fromJson(wp as Map<String, dynamic>))
          .toList();

      // Return the Profile object with or without watch providers
      return Profile.fromJson(response as Map<String, dynamic>, watchProviders: watchProviders);
    } catch (e) {
      print("Error fetching profile with watch providers for user ID $userId: $e");
      return null;
    }
  }*/
}
