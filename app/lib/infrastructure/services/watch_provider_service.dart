import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../presentation/dependency_injection.dart';
import '../repositories/region_repository.dart';

class WatchProviderService {
  final RegionRepository _regionRepository = getIt<RegionRepository>();
  final _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchProviders(String selectedCountry) async {
    try {
      final regionCode = await _regionRepository.getIsoCode(selectedCountry);

      final response = await _supabase.functions.invoke(
        'get_watch_providers',
        queryParameters: {'region': regionCode},
      );

      if (response.data != null) {
        final data = response.data as Map<String, dynamic>;
        return List<Map<String, dynamic>>.from(data['providers']);
      } else {
        debugPrint('No data received from Supabase Edge Function');
        return [];
      }
    } catch (e) {
      debugPrint('Error fetching providers: $e');
      rethrow; // Re-throw the exception to handle it where the service is called
    }
  }
}
