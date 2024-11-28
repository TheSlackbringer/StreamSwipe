import 'package:flutter/material.dart';
import 'package:stream_swipe/domain/profile.dart';
import 'package:stream_swipe/presentation/widgets/swipe/swipe_cards.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../infrastructure/repositories/profile_repository.dart';
import '../../../infrastructure/repositories/watch_provider_repository.dart';
import '../../dependency_injection.dart';
import '../watch_providers.dart';

class StreamSwipePage extends StatefulWidget {
  const StreamSwipePage({super.key});

  @override
  State<StreamSwipePage> createState() => _StreamSwipePageState();
}

class _StreamSwipePageState extends State<StreamSwipePage> {
  final ProfileRepository _profileRepository = getIt<ProfileRepository>();
  final WatchProvidersRepository _watchProvidersRepository = getIt<WatchProvidersRepository>();

  Profile? _userProfile;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final currentUser = Supabase.instance.client.auth.currentUser;
      if (currentUser == null) {
        throw Exception("No logged-in user.");
      }

      // Fetch the user's profile
      final userProfile = await _profileRepository.getProfile(currentUser.id);

      // Fetch the user's watch providers
      if (userProfile != null) {
        final watchProviders =
        await _watchProvidersRepository.getWatchProviders(userProfile.id);
        userProfile.watchProviders = watchProviders;
      }

      if (mounted) {
        setState(() {
          _userProfile = userProfile;
        });
      }
    } catch (e) {
      print("Error loading user: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading user: $e")),
      );
    }
  }

  void _onProvidersSelected() async {
    // Reload the user after providers are selected
    await _loadUser();
  }

  @override
  Widget build(BuildContext context) {
    if (_userProfile == null) {
      // Show loading indicator while _userProfile is null
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("StreamSwipe"),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Check if user has selected watch providers
    if (_userProfile!.watchProviders.isEmpty) {
      // Show the ProviderSelectionWidget
      return ProviderSelectionWidget(
        profile: _userProfile!,
        onProvidersSelected: _onProvidersSelected,
      );
    }

    // Otherwise, show the main content
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("StreamSwipe"),
      ),
      body: SwipeCardsWidget(profile: _userProfile!),
    );
  }
}
