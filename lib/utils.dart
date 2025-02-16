import 'package:flutter/material.dart';

// Define your custom colors.
const Color color1 = Color(0xFF3FD2C7);
const Color color2 = Color(0xFF99DDFF);
const Color color3 = Color(0xFF00458B);

/// Animated ChatBot icon widget.
class ChatBotAnimation extends StatefulWidget {
  const ChatBotAnimation({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChatBotAnimationState createState() => _ChatBotAnimationState();
}

class _ChatBotAnimationState extends State<ChatBotAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<Offset>(
      begin: const Offset(-0.05, 0.0),
      end: const Offset(0.05, 0.0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Icon(
            Icons.chat_bubble_outline,
            size: 60,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
      ),
    );
  }
}

/// A common background widget with a gradient and chat bot animation.
class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [color1, color2, color3],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          child,
          const ChatBotAnimation(),
        ],
      ),
    );
  }
}
