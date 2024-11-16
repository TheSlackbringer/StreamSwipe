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
      "text": "A billionaire industrialist and genius inventor, Tony Stark (Robert Downey Jr.), is conducting weapons tests overseas, but terrorists kidnap him to force him to build a devastating weapon. Instead, he builds an armored suit and upends his captors. Returning to America, Stark refines the suit and uses it to combat crime and terrorism.",
      "imageUrl":
      'https://m.media-amazon.com/images/M/MV5BMTczNTI2ODUwOF5BMl5BanBnXkFtZTcwMTU0NTIzMw@@._V1_QL75_UX280_CR0,0,280,414_.jpg',
    },
    {
      "text": "With the world now aware that he is Iron Man, billionaire inventor Tony Stark (Robert Downey Jr.) faces pressure from all sides to share his technology with the military. He is reluctant to divulge the secrets of his armored suit, fearing the information will fall into the wrong hands. With Pepper Potts (Gwyneth Paltrow) and 'Rhodey' Rhodes (Don Cheadle) by his side, Tony must forge new alliances and confront a powerful new enemy.",
      "imageUrl":
      'https://m.media-amazon.com/images/M/MV5BYWYyOGQzOGYtMGQ1My00ZWYxLTgzZjktZWYzN2IwYjkxYzM0XkEyXkFqcGc@._V1_FMjpg_UX1200_.jpg',
    },
    {
      "text": "MEEEEEGET LANG TEXT When Tony Stark's world is torn apart by a formidable terrorist called the Mandarin, he starts an odyssey of rebuilding and retribution. When Tony Stark's world is torn apart by a formidable terrorist called the Mandarin, he starts an odyssey of rebuilding and retribution. When Tony Stark's world is torn apart by a formidable terrorist called the Mandarin, he starts an odyssey of rebuilding and retribution. When Tony Stark's world is torn apart by a formidable terrorist called the Mandarin, he starts an odyssey of rebuilding and retribution. When Tony Stark's world is torn apart by a formidable terrorist called the Mandarin, he starts an odyssey of rebuilding and retribution.",
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
        duration: const Duration(seconds: 3), // Adjust the duration as needed
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