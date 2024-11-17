import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'swipe/swipe_card.dart';

class StreamSwipePage extends StatefulWidget {
  const StreamSwipePage({super.key});

  @override
  State<StreamSwipePage> createState() => _StreamSwipePageState();
}

class _StreamSwipePageState extends State<StreamSwipePage> {
  final _supabase = Supabase.instance.client;
  List<Map<String, String>>? _fetchedCards; // To store fetched cards

  @override
  void initState() {
    super.initState();
    _loadCards(); // Fetch data once
  }

  Future<void> _loadCards() async {
    final cards = await fetchMovies();
    setState(() {
      _fetchedCards = cards; // Store fetched cards
    });
  }

  Future<List<Map<String, String>>> fetchMovies() async {
    try {
      final response = await _supabase.functions.invoke('get-movies');

      final data = response.data as Map<String, dynamic>;
      final results = data['movies']['results'] as List<dynamic>;

      return results.map((movie) {
        final movieMap = movie as Map<String, dynamic>;
        return {
          "text": movieMap['title']?.toString() ?? "No title available",
          "imageUrl": movieMap['poster_path'] != null
              ? "https://image.tmdb.org/t/p/w500${movieMap['poster_path']}"
              : "https://placehold.co/500",
        };
      }).toList().cast<Map<String, String>>();
    } catch (e) {
      debugPrint('Exception calling Edge Function: $e');
      return [];
    }
  }

  void removeTopCard() {
    setState(() {
      _fetchedCards?.removeAt(0);
    });
  }

  void showCustomSnackBar(BuildContext context, String message) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    // Dismiss any currently visible SnackBar
    scaffoldMessenger.hideCurrentSnackBar();

    // Show the new SnackBar
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3), // Adjust the duration as needed
      ),
    );
  }

  void onSwipeRight() {
    showCustomSnackBar(context, 'Swiped Right!');
    removeTopCard();
  }

  void onSwipeLeft() {
    showCustomSnackBar(context, 'Swiped Left!');
    removeTopCard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("StreamSwipe"),
      ),
      body: _fetchedCards == null
          ? const Center(child: CircularProgressIndicator())
          : _fetchedCards!.isEmpty
          ? const Center(child: Text("No more cards!"))
          : Center(
        child: SizedBox(
          height: 500,
          width: 350,
          child: Stack(
            children: _fetchedCards!
                .asMap()
                .entries
                .map((entry) {
              int index = entry.key;
              Map<String, String> cardData = entry.value;
              return Positioned.fill(
                child: SwipeCardWidget(
                  text: cardData["text"]!,
                  imageUrl: cardData["imageUrl"]!,
                  onSwipeRight: () {
                    if (index == 0) {
                      onSwipeRight();
                    }
                  },
                  onSwipeLeft: () {
                    if (index == 0) {
                      onSwipeLeft();
                    }
                  },
                ),
              );
            }).toList().reversed.toList(),
          ),
        ),
      ),
    );
  }
}