import 'package:flutter/material.dart';

class SwipeCardWidget extends StatefulWidget {
  final String title;
  final String description;
  final String? rating;
  final String imageUrl;
  final String? year; 
  final VoidCallback onSwipeRight;
  final VoidCallback onSwipeLeft;

  const SwipeCardWidget({
    super.key,
    required this.title,
    required this.description,
    required this.rating,
    required this.imageUrl,
    required this.year,
    required this.onSwipeRight,
    required this.onSwipeLeft,
  });

  @override
  _SwipeCardWidgetState createState() => _SwipeCardWidgetState();
}

class _SwipeCardWidgetState extends State<SwipeCardWidget>
    with SingleTickerProviderStateMixin {
  Offset cardOffset = Offset.zero;
  bool showText = false;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _fadeAnimation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleTextVisibility() {
    setState(() {
      showText = !showText;
      if (showText) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void onPanUpdate(DragUpdateDetails details) {
    setState(() {
      cardOffset = Offset(cardOffset.dx + details.delta.dx, cardOffset.dy);
    });
  }

  void onPanEnd(DragEndDetails details) {
    if (cardOffset.dx > 150) {
      widget.onSwipeRight();
    } else if (cardOffset.dx < -150) {
      widget.onSwipeLeft();
    } else {
      setState(() {
        cardOffset = Offset.zero;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: onPanUpdate,
      onPanEnd: onPanEnd,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.hardEdge,
        children: [
          Transform.translate(offset: cardOffset, child: _buildCard()),
          if (showText) _buildTextOverlay(),
          _buildAboutButton(),
        ],
      ),
    );
  }

  Widget _buildCard() {
    return CardImage(imageUrl: widget.imageUrl, title: widget.title, rating: widget.rating, year: widget.year,);
  }

  Widget _buildAboutButton() {
    return Positioned(
      bottom: 5,
      child: Transform.translate(
        offset: cardOffset,
        child: ElevatedButton(
          onPressed: toggleTextVisibility,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.withOpacity(0.9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            "About",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextOverlay() {
    return Transform.translate(
      offset: cardOffset,
      child: Positioned.fill(
        child: TextOverlay(
          title: widget.title,
          description: widget.description,
          fadeAnimation: _fadeAnimation,
          slideAnimation: _slideAnimation,
          onClose: toggleTextVisibility,
        ),
      ),
    );
  }
}

class CardImage extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String? rating;
  final String? year; // New year parameter

  const CardImage({
    required this.imageUrl,
    required this.title,
    required this.rating,
    required this.year, // New year parameter
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Parse the rating to a double and ensure it's within the 0.0 to 10.0 range
    double? numericRating = double.tryParse(rating ?? '0');
    numericRating = numericRating != null && numericRating > 10.0
        ? 10.0
        : numericRating ?? 0.0;

    // Convert the rating to a 5-star scale by dividing by 2
    double scaledRating = numericRating! / 2;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        alignment: Alignment.bottomLeft, // Align title and rating to the bottom left
        children: [
          // Fading shadow at the bottom (fade at top, solid black at bottom)
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.20, // Bottom 20% of the card
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(1), // Fade to black
                      Colors.black, // Solid black at the bottom
                    ],
                    stops: [0.0, 0.7, 1.0], // Fade quickly, then solid black
                  ),
                ),
              ),
            ),
          ),
          // Title at the bottom left of the card
          Positioned(
            bottom: 55, // Adjust to add space from the bottom
            left: 16, // Align to the left
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    blurRadius: 4,
                  ),
                ],
              ),
              textAlign: TextAlign.left,
            ),
          ),
          // Movie Year in parentheses above the title
          Positioned(
            bottom: 80, // Position above the title
            left: 16, // Align to the left
            child: Text(
              '($year)', // Display the year in parentheses
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14, // Smaller font size for the year
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    blurRadius: 4,
                  ),
                ],
              ),
              textAlign: TextAlign.left,
            ),
          ),
          // Movie Average Rating as stars below the title
          Positioned(
            bottom: 40, // Positioning the rating just below the title
            left: 16, // Align to the left
            child: Row(
              children: [
                _buildStarRating(scaledRating), // Use the scaled 5-star rating
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Method to build the star rating, ensuring a maximum of 5 stars
  Widget _buildStarRating(double rating) {
    int fullStars = rating.floor();
    bool hasHalfStar = rating - fullStars >= 0.5;
    int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

    return Row(
      children: [
        for (int i = 0; i < fullStars; i++)
          Icon(Icons.star, color: Colors.yellow, size: 16.8), // Reduced size
        if (hasHalfStar)
          Icon(Icons.star_half, color: Colors.yellow, size: 16.8), // Reduced size
        for (int i = 0; i < emptyStars; i++)
          Icon(Icons.star_border, color: Colors.yellow, size: 16.8), // Reduced size
      ],
    );
  }
}

class TextOverlay extends StatelessWidget {
  final String title;
  final String description;
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;
  final VoidCallback onClose;

  const TextOverlay({
    required this.title,
    required this.description,
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.onClose,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: FadeTransition(
        opacity: fadeAnimation,
        child: SlideTransition(
          position: slideAnimation,
          child: Stack(
            children: [
              // Background
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 40), // Space for close button
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Text(
                            description,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Close Button
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  onPressed: onClose,
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
