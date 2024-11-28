import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../infrastructure/repositories/region_repository.dart';
import '../../../infrastructure/repositories/watch_provider_repository.dart';
import '../../dependency_injection.dart';
import 'swipe_card.dart';
import '../../../domain/profile.dart';

class SwipeCardsWidget extends StatefulWidget {
  final Profile profile;

  const SwipeCardsWidget({required this.profile, super.key});

  @override
  _SwipeCardsWidgetState createState() => _SwipeCardsWidgetState();
}

class _SwipeCardsWidgetState extends State<SwipeCardsWidget> {
  final RegionRepository _regionRepository = getIt<RegionRepository>();
  final _supabase = Supabase.instance.client;
  List<Map<String, String>>? _fetchedCards;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    final cards = await fetchMovies();
    setState(() {
      _fetchedCards = cards;
    });
  }

  Future<List<Map<String, String>>> fetchMovies() async {
    try {
      final response = await _supabase.functions.invoke(
        'get_movies',
        queryParameters: {
          'watch_providers': widget.profile.watchProviders.map((p) => p.providerId).join('|'),
          'region': await _regionRepository.getIsoCode(widget.profile.country!) ?? 'US'
        },
      );


      final data = response.data as Map<String, dynamic>;
      final results = data['movies']['results'] as List<dynamic>;

      return results.map((movie) {
        final movieMap = movie as Map<String, dynamic>;
        return {
          "title": movieMap['title']?.toString() ?? "No title available",
          "voteAverage": movieMap['vote_average']?.toString() ?? "N/A",
          "releaseDate": movieMap['release_date']?.toString() ?? "N/A",
          "imageUrl": movieMap['poster_path'] != null
              ? "https://image.tmdb.org/t/p/w500${movieMap['poster_path']}"
              : "https://placehold.co/500/red/white",
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

    scaffoldMessenger.hideCurrentSnackBar();

    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
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
    return _fetchedCards == null
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
                title: cardData["title"]!,
                rating: cardData["voteAverage"],
                year: cardData["releaseDate"]?.substring(0, 4),
                description: "Placeholder text for description..",
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
          })
              .toList()
              .reversed
              .toList(),
        ),
      ),
    );
  }
}
