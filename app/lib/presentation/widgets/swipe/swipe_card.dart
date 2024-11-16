import 'package:flutter/material.dart';

class SwipeCardWidget extends StatefulWidget {
  final String text;
  final String imageUrl;
  final VoidCallback onSwipeRight;
  final VoidCallback onSwipeLeft;

  const SwipeCardWidget({
    super.key,
    required this.text,
    required this.imageUrl,
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

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onPanUpdate(DragUpdateDetails details) {
    setState(() {
      // Update only the X-coordinate of the cardOffset
      cardOffset = Offset(cardOffset.dx + details.delta.dx, cardOffset.dy);
    });
  }

  void onPanEnd(DragEndDetails details) {
    if (cardOffset.dx > 150) {
      // Swiped to the right
      widget.onSwipeRight();
    } else if (cardOffset.dx < -150) {
      // Swiped to the left
      widget.onSwipeLeft();
    } else {
      // Reset position if swipe threshold not met
      setState(() {
        cardOffset = Offset.zero;
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: onPanUpdate,
      onPanEnd: onPanEnd,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Card Image
          Transform.translate(
            offset: cardOffset,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: NetworkImage(widget.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          
          // "About" Button - This is always present and moves with the card
          Positioned(
            bottom: 10,
            child: Transform.translate(
              offset: cardOffset,  // Button moves with the card
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
                    fontWeight: FontWeight.bold,  // Make the text bold
                  ),
                ),
              ),
            ),
          ),
  
          // Text Box (appears when `showText` is true)
          if (showText)
            Positioned.fill(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Transform.translate(
                    offset: cardOffset,  // Text box moves with the card
                    child: Stack(
                      children: [
                        // Text box background with padding
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              // Extra padding to avoid text behind the dismiss button
                              const SizedBox(height: 40),  // Adjust as needed
                              Expanded(
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: Text(
                                    widget.text,
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
                        // Dismiss Button
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                            onPressed: toggleTextVisibility,
                            icon: const Icon(Icons.close, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}