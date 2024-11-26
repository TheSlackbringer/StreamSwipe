import 'package:supabase_flutter/supabase_flutter.dart';

class SecretService {
  // Static method to fetch a secret using Supabase RPC
   Future<String?> getSecret(String secretName) async {
    final supabase = Supabase.instance.client;
    try {
      final response = await supabase.rpc('read_secret', params: {
        'secret_name': secretName,
      });

      if (response.error != null) {
        // Log or handle the error
        print('Error fetching secret: ${response.error!.message}');
        return null;
      }

    // Return the retrieved secret
    return response.data as String?;
    }catch (e) {
      // Handle general errors
      print('Error fetching secret: ${e}');
      throw Exception('Unexpected error: $e');
    }
  }
}
