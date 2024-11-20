import 'package:flutter/material.dart';
import '../../../domain/local_user.dart';
import '../../../infrastructure/repositories/local_user_repository.dart';
import '../../../infrastructure/repositories/region_repository.dart';
import '../../dependency_injection.dart'; // If using dependency injection

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final LocalUserRepository _localUserRepository = getIt<LocalUserRepository>();
  final RegionRepository _regionRepository = getIt<RegionRepository>();
  LocalUser? _user;

  @override
  void initState() {
    super.initState();
    // Delay the initialization until after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeUser();
    });
  }

  Future<void> _initializeUser() async {
    // First, check if the user already exists
    LocalUser? user = await _localUserRepository.getUser();

    if (user == null) {
      // Get the device's locale
      Locale deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
      String? countryCode = deviceLocale.countryCode ?? 'US';

      Map<String, String> invertedRegionMap = await _regionRepository.getInvertedRegionMap();

      // Get the country name from the country code
      String countryName = invertedRegionMap[countryCode.toUpperCase()] ?? 'United States';

      user = LocalUser(
        country: countryName,
        watchProviders: [],
      );

      // Save the user
      await _localUserRepository.saveUser(user);
    }

    if (mounted) {
      setState(() {
        _user = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show a loading indicator while the user is being initialized
    if (_user == null) {
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

    // Proceed with the rest of your UI now that the user is initialized
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Text('Hi, user from ${_user!.country}'),
      ),
    );
  }
}
