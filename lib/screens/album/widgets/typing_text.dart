import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TypingText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Duration duration;
  final double target;

  const TypingText({
    super.key,
    required this.text,
    this.style,
    this.duration = const Duration(milliseconds: 1000),
    this.target = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Text('')
        .animate(target: target)
        .custom(
          duration: duration,
          curve: Curves.linear,
          builder: (context, value, child) {
            final int charCount =
                (text.length * value).clamp(0, text.length).toInt();
            return Text(
              text.substring(0, charCount),
              style:
                  style ?? const TextStyle(color: Colors.white, fontSize: 18),
            );
          },
        );
  }
}
