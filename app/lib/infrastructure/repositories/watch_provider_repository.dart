import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/watch_provider.dart';
import '../supabase_table.dart';

class WatchProvidersRepository {
  final Supabase _supabase;
  final WatchProvidersTable _watchProvidersTable;

  const WatchProvidersRepository(this._supabase, this._watchProvidersTable);

  /// Save multiple watch providers for a user
  Future<void> saveWatchProviders(String userId, List<String> watchProviderIds) async {
    try {
      // Prepare the data for bulk insert
      final data = watchProviderIds.map((providerId) => {
        _watchProvidersTable.userIdColumn: userId,
        _watchProvidersTable.providerIdColumn: providerId
      }).toList();

      // Perform bulk insert
      await _supabase.client
          .from(_watchProvidersTable.tableName)
          .upsert(data);

    } catch (e) {
      print("Error saving watch providers: $e");
      throw Exception("Error saving watch providers.");
    }
  }

  Future<void> deleteWatchProviders(String userId) async {
    try {
      // Delete all watch providers for the given user ID
      final deleteResponse = await _supabase.client
          .from(_watchProvidersTable.tableName)
          .delete()
          .eq(_watchProvidersTable.userIdColumn, userId);

    } catch (e) {
      print("Error deleting watch providers: $e");
      throw Exception("Error deleting watch providers.");
    }
  }

  /// Fetch all watch providers for a user
  Future<List<WatchProvider>> getWatchProviders(String userId) async {
    try {
      final response = await _supabase.client
          .from(_watchProvidersTable.tableName)
          .select()
          .eq(_watchProvidersTable.userIdColumn, userId);

      final data = response as List<dynamic>;
      return data.map((json) => WatchProvider.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      print("Error fetching watch providers: $e");
      throw Exception("Error fetching watch providers.");
    }
  }
}
