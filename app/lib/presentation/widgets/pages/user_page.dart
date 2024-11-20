import 'package:flutter/material.dart';
import '../../../domain/local_user.dart';
import '../../../infrastructure/repositories/local_user_repository.dart';
import '../../../infrastructure/repositories/region_repository.dart';
import '../../dependency_injection.dart';

class UserSetupPage extends StatefulWidget {
  const UserSetupPage({Key? key}) : super(key: key);

  @override
  _UserSetupPageState createState() => _UserSetupPageState();
}

class _UserSetupPageState extends State<UserSetupPage> {
  final userRepository = getIt<LocalUserRepository>();
  final regionRepository = getIt<RegionRepository>();

  String? selectedCountry; // Currently selected country
  List<String> availableCountries = []; // List of countries for selection
  bool isLoading = true; // To show a loading state

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// Load available countries and user data
  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Ensure the region map is cached and fetch available countries
      final regionMap = await regionRepository.ensureRegionMap();
      availableCountries = regionMap.keys.toList();

      // Load the saved user (if any)
      final user = await userRepository.getUser();
      selectedCountry = user?.country;
    } catch (error) {
      // Handle error fetching the region map
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading regions: $error')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  /// Save the selected country to the user repository
  Future<void> _saveCountry() async {
    if (selectedCountry != null) {
      // Save the user
      final user = LocalUser(country: selectedCountry!, watchProviders: []);
      await userRepository.saveUser(user);

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
              items: availableCountries.map((country) {
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
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
