import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Define custom colors.
const Color color1 = Color(0xFF3FD2C7);
const Color color2 = Color(0xFF99DDFF);
const Color color3 = Color(0xFF00458B);

/// Animated ChatBot widget with bouncing and glowing effects.
class ChatBotAnimation extends StatefulWidget {
  const ChatBotAnimation({super.key});

  @override
  _ChatBotAnimationState createState() => _ChatBotAnimationState();
}

class _ChatBotAnimationState extends State<ChatBotAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _positionAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _positionAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.02),
      end: const Offset(0.0, -0.02),
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
      position: _positionAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: SvgPicture.asset(
                "assets/chatbot.svg", // ✅ Use your chatbot SVG image
                height: 80,
                colorFilter: const ColorFilter.mode(
                  Colors.white, // Adjust color if needed
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// ✅ Updated GradientBackground with showChatbot flag
class GradientBackground extends StatelessWidget {
  final Widget child;
  final bool showChatbot; // ✅ New parameter to control chatbot visibility

  const GradientBackground({super.key, required this.child, this.showChatbot = false});

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
          if (showChatbot) const ChatBotAnimation(), // ✅ Only show on dashboard
        ],
      ),
    );
  }
}
