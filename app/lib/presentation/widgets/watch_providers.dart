import 'package:flutter/material.dart';
import 'package:stream_swipe/domain/local_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../infrastructure/repositories/local_user_repository.dart';
import '../dependency_injection.dart';

class ProviderSelectionWidget extends StatefulWidget {
  final LocalUser user;
  final VoidCallback onProvidersSelected;

  const ProviderSelectionWidget({
    required this.user,
    required this.onProvidersSelected,
    super.key,
  });

  @override
  _ProviderSelectionWidgetState createState() => _ProviderSelectionWidgetState();
}

class _ProviderSelectionWidgetState extends State<ProviderSelectionWidget> {
  final _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _availableProviders = [];
  final Set<String> _selectedProviders = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProviders();
  }

  Future<void> _fetchProviders() async {
    try {
      final region = await widget.user.getIsoCode() ?? 'US'; // Provide a default value
      final response = await _supabase.functions.invoke(
        'get_watch_providers',
        queryParameters: {'region': region},
      );

      if (response.data != null) {
        final data = response.data as Map<String, dynamic>;
        setState(() {
          _availableProviders = List<Map<String, dynamic>>.from(data['providers']);
          _isLoading = false;
        });
      } else {
        // Handle the case where no data is returned
        setState(() {
          _isLoading = false;
        });
        debugPrint('No data received from Supabase Edge Function');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle the error, e.g., show an error message
      debugPrint('Error fetching providers: $e');
    }
  }

  Future<void> _saveSelectedProviders() async {
    final localUserRepo = getIt<LocalUserRepository>();

    // Update the user's watchProviders
    widget.user.watchProviders = _selectedProviders.toList();

    // Save the updated user
    await localUserRepo.saveUser(widget.user);

    // Notify the parent widget to refresh
    widget.onProvidersSelected();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose Your Streaming Providers"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Choose your streaming providers",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _availableProviders.length,
                itemBuilder: (context, index) {
                  final provider = _availableProviders[index];
                  return CheckboxListTile(
                    title: Text(provider['provider_name']),
                    value: _selectedProviders.contains(provider['provider_id'].toString()),
                    onChanged: (bool? selected) {
                      setState(() {
                        final providerId = provider['provider_id'].toString();
                        if (selected == true) {
                          _selectedProviders.add(providerId);
                        } else {
                          _selectedProviders.remove(providerId);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _selectedProviders.isEmpty
                  ? null
                  : () async {
                await _saveSelectedProviders();
              },
              child: const Text("Save Providers"),
            ),
          ],
        ),
      ),
    );
  }
}