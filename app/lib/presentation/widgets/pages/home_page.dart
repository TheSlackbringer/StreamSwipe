import 'package:flutter/material.dart';
import 'package:stream_swipe/infrastructure/repositories/region_repository.dart';
import '../../../domain/profile.dart';
import '../../../infrastructure/repositories/profile_repository.dart';
import '../../dependency_injection.dart'; // If using dependency injection
import 'package:supabase_flutter/supabase_flutter.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ProfileRepository _profileRepository = getIt<ProfileRepository>();
  final RegionRepository _regionRepository = getIt<RegionRepository>();
  Profile? _profile;

  @override
  void initState() {
    super.initState();
    // Delay the initialization until after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeProfile();
    });
  }

  Future<void> _initializeProfile() async {
    try {
      // Get the logged-in user ID from Supabase
      final user = Supabase.instance.client.auth.currentUser;

      if (user == null) {
        // Handle the case where the user is not logged in
        print("No logged-in user found.");
        return;
      }

      // Fetch the profile using the repository
      Profile? profile = await _profileRepository.getProfile(user.id);

      if (profile == null || profile.country == null || profile.country!.isEmpty) {        // If no profile is found, create a default profile
        Locale deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
        String? countryCode = deviceLocale.countryCode ?? 'US';

        Map<String, String> invertedRegionMap = await _regionRepository.getInvertedRegionMap();

        // Get the country name from the country code
        String countryName = invertedRegionMap[countryCode.toUpperCase()] ?? 'United States';

        profile = Profile(
          id: user.id,
          fullName: user.email, // Use email as the default name if fullName is not available
          country: countryName,
          createdAt: DateTime.now());

        // Optionally save the profile to the database (implement this in your repository)
        await _profileRepository.saveProfile(profile);
      }

      // Update the state with the profile
      if (mounted) {
        setState(() {
          _profile = profile;
        });
      }
    } catch (e) {
      print("Error initializing profile: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show a loading indicator while the profile is being initialized
    if (_profile == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Proceed with the rest of your UI now that the profile is initialized
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Text('Hi, user from ${_profile!.country ?? 'Unknown'}'),
      ),
    );
  }
}
