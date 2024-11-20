import 'package:flutter/material.dart';
import 'rating_stars.dart';

class CardImage extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String? rating;
  final String? year;

  const CardImage({
    required this.imageUrl,
    required this.title,
    required this.rating,
    required this.year,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Parse the rating, ensuring it stays in the range 0.0 to 10.0
    double? numericRating = double.tryParse(rating ?? '0')?.clamp(0.0, 10.0);
    double scaledRating = (numericRating ?? 0.0) / 2; // Convert to 5-star scale

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          // Gradient background for text visibility
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.30,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(15)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(1), // Stronger black at the bottom
                    ],
                    stops: [0.0, 0.5, 1.0], // Gradual transition with a strong black finish
                  ),
                ),
              ),
            ),
          ),
          // Movie year
          Positioned(
            bottom: 80,
            left: 16,
            child: Text(
              year != null ? '($year)' : '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                shadows: [Shadow(color: Colors.black, blurRadius: 4)],
              ),
            ),
          ),
          // Movie title
          Positioned(
            bottom: 55,
            left: 16,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                shadows: [Shadow(color: Colors.black, blurRadius: 4)],
              ),
            ),
          ),
          // Star rating
          Positioned(
            bottom: 40,
            left: 16,
            child: RatingStars(rating: scaledRating), // Use the custom RatingStars widget
          ),
        ],
      ),
    );
  }
}
