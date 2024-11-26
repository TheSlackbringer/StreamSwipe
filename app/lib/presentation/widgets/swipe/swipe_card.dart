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
  Offset startDragOffset = Offset.zero;
  bool showText = false;
  bool isSwipingAway = false; // Tracks if the card is swiping away
  late AnimationController _controller;
  late Animation<Offset> _resetAnimation;
  late Animation<double> _fadeAnimation;
  double cardOpacity = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _resetAnimation = Tween<Offset>(begin: Offset.zero, end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut))
      ..addListener(() {
        setState(() {
          cardOffset = _resetAnimation.value;
        });
      });

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut))
      ..addListener(() {
        if (isSwipingAway) {
          setState(() {
            cardOpacity = _fadeAnimation.value;
          });
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleTextVisibility() {
    setState(() {
      showText = !showText;
    });
  }

  void onPanStart(DragStartDetails details) {
    setState(() {
      startDragOffset = details.globalPosition;
    });
  }

  void onPanUpdate(DragUpdateDetails details) {
    setState(() {
      cardOffset = details.globalPosition - startDragOffset;
    });
  }

  void onPanEnd(DragEndDetails details) {
    if (cardOffset.dx > 150) {
      _animateCardOffScreen(1, widget.onSwipeRight); // Swipe right
    } else if (cardOffset.dx < -150) {
      _animateCardOffScreen(-1, widget.onSwipeLeft); // Swipe left
    } else {
      _animateCardBack(); // Reset card to center
    }
  }

  void _animateCardOffScreen(int direction, VoidCallback onSwipe) {
    setState(() {
      isSwipingAway = true; // Mark as swiping away
    });

    _resetAnimation = Tween<Offset>(
      begin: cardOffset,
      end: Offset(cardOffset.dx + (direction * 300), cardOffset.dy),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.reset();
    _controller.forward().whenComplete(() {
      onSwipe(); // Trigger the swipe callback
      setState(() {
        cardOffset = Offset.zero;
        cardOpacity = 1.0; // Reset opacity for the next card
        isSwipingAway = false; // Reset swiping state
      });
    });
  }

  void _animateCardBack() {
    setState(() {
      isSwipingAway = false; // Ensure fade-out is disabled
    });

    _resetAnimation = Tween<Offset>(begin: cardOffset, end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.reset();
    _controller.forward().whenComplete(() {
      setState(() {
        cardOpacity = 1.0; // Ensure card stays fully visible
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate rotation angle based on horizontal offset
    final rotationAngle = cardOffset.dx / screenWidth * 0.4;

    return GestureDetector(
      onPanStart: onPanStart,
      onPanUpdate: onPanUpdate,
      onPanEnd: onPanEnd,
      child: Opacity(
        opacity: cardOpacity,
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
          bottom: 10,
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
      alignment: Alignment.center,
      child: TextOverlay(
        title: widget.title,
        description: widget.description,
        fadeAnimation: _controller,
        slideAnimation: _resetAnimation,
        onClose: toggleTextVisibility,
      ),
    );
  }
}
