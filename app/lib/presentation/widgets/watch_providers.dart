import 'package:flutter/material.dart';
import 'package:stream_swipe/domain/local_user.dart';
import 'package:stream_swipe/infrastructure/services/watch_provider_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../infrastructure/repositories/local_user_repository.dart';
import '../../infrastructure/repositories/region_repository.dart';
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
  final WatchProviderService _watchProviderService = getIt<WatchProviderService>();

  final _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _availableProviders = [];
  final Set<String> _selectedProviders = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getProviders();
  }

  Future<void> getProviders() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final selectedCountry = widget.user.country;

      final providers = await _watchProviderService.fetchProviders(selectedCountry);

      setState(() {
        _availableProviders = providers;
      });
    } catch (e) {
      debugPrint('Error fetching providers: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
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
                    title: Row(
                      children: [
                        provider['logo_path'] != null
                            ? Image.network(
                          'https://image.tmdb.org/t/p/w92${provider['logo_path']}',
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        )
                            : const SizedBox(width: 40, height: 40), // Placeholder if no logo is available
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(provider['provider_name']),
                        ),
                      ],
                    ),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFA500), // Change this to your desired color
                foregroundColor: Colors.white, // Text color
              ),
              child: const Text("Save Providers"),
            ),
          ],
        ),
      ),
    );
  }
}