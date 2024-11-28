import 'package:flutter/material.dart';
import 'package:stream_swipe/infrastructure/repositories/watch_provider_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../domain/profile.dart';
import '../../../infrastructure/repositories/profile_repository.dart';
import '../../../infrastructure/repositories/region_repository.dart';
import '../../dependency_injection.dart';

class UserSetupPage extends StatefulWidget {
  const UserSetupPage({Key? key}) : super(key: key);

  @override
  _UserSetupPageState createState() => _UserSetupPageState();
}

class _UserSetupPageState extends State<UserSetupPage> {
  final ProfileRepository _profileRepository = getIt<ProfileRepository>();
  final WatchProvidersRepository _watchProvidersRepository = getIt<WatchProvidersRepository>();

  final RegionRepository _regionRepository = getIt<RegionRepository>();

  late Profile user; // The user profile available across the page
  String? selectedCountry; // Currently selected country
  List<String> availableCountries = []; // List of countries for selection
  bool isLoading = true; // To show a loading state

  @override
  void initState() {
    super.initState();
    _initializeUserSetup();
  }

  /// Initialize user setup by loading user data and regions
  Future<void> _initializeUserSetup() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Load the logged-in user's profile
      user = (await _profileRepository.getProfile(Supabase.instance.client.auth.currentUser!.id)!)!;

      // Load the available regions
      final regionMap = await _regionRepository.ensureRegionMap();
      availableCountries = regionMap.keys.toList();

      // Preselect the user's country if available
      selectedCountry = user.country;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  /// Save the selected country to the user's profile
  Future<void> _saveCountry() async {
    if (selectedCountry != null) {
      user.country = selectedCountry;

      // Save the updated profile
      await _profileRepository.saveProfile(user);
      await _watchProvidersRepository.deleteWatchProviders(user.id);



      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Country saved successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('User Setup')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Your Country',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedCountry,
              hint: const Text('Select your country'),
              items: (availableCountries..sort((a, b) => a.compareTo(b))).map((country) {
                return DropdownMenuItem(
                  value: country,
                  child: Text(country),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCountry = value;
                });
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: selectedCountry != null ? _saveCountry : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFA500), // Change this to your desired color
                foregroundColor: Colors.white, // Text color
              ),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
