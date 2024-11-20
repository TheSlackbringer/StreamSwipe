import 'package:flutter/material.dart';
import 'package:stream_swipe/domain/local_user.dart';
import 'package:stream_swipe/presentation/widgets/swipe/swipe_cards.dart';

import '../../../infrastructure/repositories/local_user_repository.dart';
import '../../dependency_injection.dart';
import '../watch_providers.dart';

class StreamSwipePage extends StatefulWidget {
  const StreamSwipePage({super.key});

  @override
  State<StreamSwipePage> createState() => _StreamSwipePageState();
}

class _StreamSwipePageState extends State<StreamSwipePage> {
  final LocalUserRepository _localUserRepository = getIt<LocalUserRepository>();
  LocalUser? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await _localUserRepository.getUser();

    if (mounted) {
      setState(() {
        _user = user;
      });
    }
  }

  void _onProvidersSelected() async {
    // Handle after providers are selected
    final updatedUser = await _localUserRepository.getUser();

    if (mounted) {
      setState(() {
        _user = updatedUser;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      // Show loading indicator while _user is null
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
    if (_user!.watchProviders.isEmpty) {
      // Show the ProviderSelectionWidget
      return ProviderSelectionWidget(
        user: _user!,
        onProvidersSelected: _onProvidersSelected,
      );
    }

    // Otherwise, show the main content
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("StreamSwipe"),
      ),
      body: SwipeCardsWidget(user: _user!),
    );
  }
}
