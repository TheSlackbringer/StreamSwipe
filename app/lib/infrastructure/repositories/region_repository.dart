import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegionRepository {
  static const _regionMapKey = 'regionMap';
  final supabase = Supabase.instance.client;

  // Singleton pattern for shared instance
  static final RegionRepository _instance = RegionRepository._internal();
  factory RegionRepository() => _instance;
  RegionRepository._internal();

  /// Save the region map to local storage
  Future<void> saveRegionMap(Map<String, String> regionMap) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_regionMapKey, jsonEncode(regionMap));
  }

  /// Get the cached region map from local storage
  Future<Map<String, String>> getRegionMap() async {
    final prefs = await SharedPreferences.getInstance();
    final mapString = prefs.getString(_regionMapKey);

    if (mapString != null) {
      return Map<String, String>.from(jsonDecode(mapString));
    }
    return {}; // Return empty map if not cached
  }

  /// Fetch the region map using Supabase Edge Function
  Future<Map<String, String>> getRegionMapFromSupabase() async {
    try {
      final response = await supabase.functions.invoke('get_regions');

      // Successful invocation
      if (response.data != null) {
        // Assuming the data returned is a map of country names to ISO codes
        return Map<String, String>.from(response.data);
      }
      // No data returned, throw exception
      throw Exception('No data received from Supabase Edge Function');
    } on FunctionException catch (e) {
      // Handle specific Supabase Function exceptions
      throw Exception(
        'Error invoking Supabase Edge Function: ${e.reasonPhrase}, Details: ${e.details}',
      );
    } catch (e) {
      // Handle general errors
      throw Exception('Unexpected error: $e');
    }
  }

  /// Ensure the region map is cached, fetching from Supabase if necessary
  Future<Map<String, String>> ensureRegionMap() async {
    final cachedRegionMap = await getRegionMap();

    if (cachedRegionMap.isNotEmpty) {
      return cachedRegionMap; // Return cached map if available
    }

    // Fetch from Supabase if cache is empty
    final fetchedRegionMap = await getRegionMapFromSupabase();
    await saveRegionMap(fetchedRegionMap);
    return fetchedRegionMap;
  }
}
