import 'package:flutter/material.dart';
import 'sub-widgets/card_image.dart';
import 'sub-widgets/text_overlay.dart';

class SwipeCardWidget extends StatefulWidget {
  final String title;
  final String description;
  final String? rating;
  final String imageUrl;
  final String? year;
  final VoidCallback onSwipeRight;
  final VoidCallback onSwipeLeft;

  const SwipeCardWidget({
    Key? key,
    required this.title,
    required this.description,
    required this.rating,
    required this.imageUrl,
    required this.year,
    required this.onSwipeRight,
    required this.onSwipeLeft,
  }) : super(key: key);

  @override
  _SwipeCardWidgetState createState() => _SwipeCardWidgetState();
}

class _SwipeCardWidgetState extends State<SwipeCardWidget>
    with SingleTickerProviderStateMixin {
  Offset cardOffset = Offset.zero;
  Offset startDragOffset = Offset.zero; // Track the start of the drag
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
        _controller.forward(); // Show overlay
      } else {
        _controller.reverse(); // Hide overlay
      }
    });
  }

  void onPanStart(DragStartDetails details) {
    setState(() {
      startDragOffset = details.globalPosition; // Record the drag start position
    });
  }

  void onPanUpdate(DragUpdateDetails details) {
    setState(() {
      // Calculate the new offset based on the drag delta
      cardOffset = details.globalPosition - startDragOffset;
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
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate rotation angle based on horizontal offset
    final rotationAngle = cardOffset.dx / screenWidth * 0.4; // Adjust multiplier for effect

    return GestureDetector(
      onPanStart: onPanStart,
      onPanUpdate: onPanUpdate,
      onPanEnd: onPanEnd,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.hardEdge,
        children: [
          // Apply the same transformations to the card and the overlay
          Transform.translate(
            offset: cardOffset,
            child: Transform.rotate(
              angle: rotationAngle,
              child: _buildCard(),
            ),
          ),
          if (showText)
            Transform.translate(
              offset: cardOffset,
              child: Transform.rotate(
                angle: rotationAngle,
                child: _buildTextOverlay(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCard() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CardImage(
          imageUrl: widget.imageUrl,
          title: widget.title,
          rating: widget.rating,
          year: widget.year,
        ),
        Positioned(
          bottom: 10, // Position at the bottom of the card
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
      ],
    );
  }

  Widget _buildTextOverlay() {
    return Align(
      alignment: Alignment.center, // Center the overlay on the card
      child: TextOverlay(
        title: widget.title,
        description: widget.description,
        fadeAnimation: _fadeAnimation,
        slideAnimation: _slideAnimation,
        onClose: toggleTextVisibility, // Close when the overlay is dismissed
      ),
    );
  }
}
