import 'package:flutter/material.dart';

class AnimatedStarRating extends StatefulWidget {
  final double score; // 0.0 ~ 5.0
  final double size;

  const AnimatedStarRating({super.key, required this.score, this.size = 30.0});

  @override
  State<AnimatedStarRating> createState() => _AnimatedStarRatingState();
}

class _AnimatedStarRatingState extends State<AnimatedStarRating>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _animations;
  AnimationController? _lastStarBounce;
  Animation<double>? _lastStarScale;

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(5, (_) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      );
    });

    _animations =
        _controllers.map((c) {
          return CurvedAnimation(parent: c, curve: Curves.easeOutBack);
        }).toList();

    // 마지막 별 효과
    _lastStarBounce = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _lastStarScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: 1.5,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.5,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_lastStarBounce!);

    _runAnimations();
  }

  Future<void> _runAnimations() async {
    for (int i = 0; i < 5; i++) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;
      _controllers[i].forward();
    }

    if (!mounted) return;
    // 5점일 때만 마지막 별 효과 실행
    if (widget.score >= 5.0) {
      _lastStarBounce!.forward();
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    _lastStarBounce?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final full = widget.score.floor();
    final half = (widget.score - full) >= 0.5;
    final empty = 5 - full - (half ? 1 : 0);

    final icons = <IconData>[
      for (int i = 0; i < full; i++) Icons.star_rounded,
      if (half) Icons.star_half_rounded,
      for (int i = 0; i < empty; i++) Icons.star_rounded,
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final icon = icons[index];
        final isFilled = index < full || (half && index == full);
        final isLast = index == 4 && widget.score >= 5.0;

        if (isLast) {
          return AnimatedBuilder(
            animation: _lastStarScale!,
            builder: (context, child) {
              final scale = _lastStarScale!.value;
              final glow = (scale - 1.0).clamp(0.0, 0.5);
              final angle = (scale - 1.0) * 0.2;

              return Transform.rotate(
                angle: angle,
                child: Transform.scale(
                  scale: scale,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withValues(alpha: glow),
                          blurRadius: 20 * glow,
                          spreadRadius: 4 * glow,
                        ),
                      ],
                    ),
                    child: child,
                  ),
                ),
              );
            },
            child: Icon(
              icon,
              color:
                  isFilled ? Colors.amber : Colors.grey.withValues(alpha: 0.4),
              size: widget.size,
            ),
          );
        }

        return ScaleTransition(
          scale: _animations[index],
          child: Icon(
            icon,
            color: isFilled ? Colors.amber : Colors.grey.withValues(alpha: 0.4),
            size: widget.size,
          ),
        );
      }),
    );
  }
}
