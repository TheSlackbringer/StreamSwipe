import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final double rating; // Rating on a scale of 0 to 5

  const RatingStars({
    Key? key,
    required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int fullStars = rating.floor();
    bool hasHalfStar = rating - fullStars >= 0.5;
    int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

    return Row(
      children: [
        for (int i = 0; i < fullStars; i++)
          const Icon(Icons.star, color: Colors.yellow, size: 16.8),
        if (hasHalfStar)
          const Icon(Icons.star_half, color: Colors.yellow, size: 16.8),
        for (int i = 0; i < emptyStars; i++)
          const Icon(Icons.star_border, color: Colors.yellow, size: 16.8),
      ],
    );
  }
}
