import 'package:flutter/material.dart';

class SwipeCardWidget extends StatefulWidget {
  final String text;
  final String imageUrl;
  final VoidCallback onSwipeRight;
  final VoidCallback onSwipeLeft;

  const SwipeCardWidget({
    Key? key,
    required this.text,
    required this.imageUrl,
    required this.onSwipeRight,
    required this.onSwipeLeft,
  }) : super(key: key);

  @override
  _SwipeCardWidgetState createState() => _SwipeCardWidgetState();
}

class _SwipeCardWidgetState extends State<SwipeCardWidget> {
  Offset cardOffset = Offset.zero;

  void onPanUpdate(DragUpdateDetails details) {
    setState(() {
      cardOffset += details.delta;
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: onPanUpdate,
      onPanEnd: onPanEnd,
      child: Transform.translate(
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
    );
  }
}