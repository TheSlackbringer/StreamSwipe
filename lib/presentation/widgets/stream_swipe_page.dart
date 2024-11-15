import 'package:flutter/material.dart';

import 'swipe/swipe_card.dart';

class StreamSwipePage extends StatefulWidget {
  const StreamSwipePage({super.key});

  @override
  State<StreamSwipePage> createState() => _StreamSwipePageState();
}

class _StreamSwipePageState extends State<StreamSwipePage> {
  List<Map<String, String>> cards = [
    {
      "text": "Card 1",
      "imageUrl":
      'https://m.media-amazon.com/images/M/MV5BMTczNTI2ODUwOF5BMl5BanBnXkFtZTcwMTU0NTIzMw@@._V1_QL75_UX280_CR0,0,280,414_.jpg',
    },
    {
      "text": "Card 2",
      "imageUrl":
      'https://m.media-amazon.com/images/M/MV5BYWYyOGQzOGYtMGQ1My00ZWYxLTgzZjktZWYzN2IwYjkxYzM0XkEyXkFqcGc@._V1_FMjpg_UX1200_.jpg',
    },
    {
      "text": "Card 3",
      "imageUrl":
      "https://m.media-amazon.com/images/M/MV5BMjIzMzAzMjQyM15BMl5BanBnXkFtZTcwNzM2NjcyOQ@@._V1_FMjpg_UY2048_.jpg",
    },
  ];

  void showCustomSnackBar(BuildContext context, String message) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    // Dismiss any currently visible SnackBar
    scaffoldMessenger.hideCurrentSnackBar();

    // Show the new SnackBar
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3), // Adjust the duration as needed
      ),
    );
  }

  void removeTopCard() {
    setState(() {
      cards.removeAt(0);
    });
  }

  void onSwipeRight() {
    // Logic for right swipe
    showCustomSnackBar(context, 'Swiped Right!');
    removeTopCard();
  }

  void onSwipeLeft() {
    // Logic for left swipe
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
      body: Center(
        child: cards.isEmpty
            ? const Text("No more cards!")
            : SizedBox(
          height: 500,
          width: 350,
          child: Stack(
            children: cards
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
            })
                .toList()
                .reversed
                .toList(),
          ),
        ),
      ),
    );
  }
}