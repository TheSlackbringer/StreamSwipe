import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegionRepository {
  static const _regionMapKey = 'regionMap';
  final supabase = Supabase.instance.client;
  final SharedPreferencesAsync prefs = SharedPreferencesAsync();


  /// Save the region map to local storage
  Future<void> saveRegionMap(Map<String, String> regionMap) async {
    await prefs.setString(_regionMapKey, jsonEncode(regionMap));
  }

  /// Get the cached region map from local storage
  Future<Map<String, String>> getRegionMap() async {
    final mapString = await prefs.getString(_regionMapKey);

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

  /// Get the inverted region map (code to country name)
  Future<Map<String, String>> getInvertedRegionMap() async {
    final regionMap = await ensureRegionMap();
    // Invert the map: code as key, country name as value
    final invertedMap = { for (var entry in regionMap.entries) entry.value : entry.key };
    return invertedMap;
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
