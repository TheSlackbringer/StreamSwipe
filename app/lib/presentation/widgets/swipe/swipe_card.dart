import 'package:flutter/material.dart';

class SwipeCardWidget extends StatefulWidget {
  final String title;
  final String description;
  final String imageUrl;
  final VoidCallback onSwipeRight;
  final VoidCallback onSwipeLeft;

  const SwipeCardWidget({
    super.key,
    required this.title,
    required this.description,
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
      end: Offset.zero,
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
          if (showText) _buildOverlay(),
          _buildAboutButton(),
        ],
      ),
    );
  }

  Widget _buildCard() {
    return CardImage(imageUrl: widget.imageUrl);
  }

  Widget _buildAboutButton() {
    return Positioned(
      bottom: 10,
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

  Widget _buildOverlay() {
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

  const CardImage({required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
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