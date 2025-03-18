import 'dart:math';

import 'package:flutter/material.dart';

Map<String, String> wordBook = {
  "apple": "사과",
  "banana": "바나나",
  "computer": "컴퓨터",
  "developer": "개발자",
  "ocean": "대양",
  "mountain": "산",
  "universe": "우주",
  "journey": "여정",
  "happiness": "행복",
  "challenge": "도전",
};

class Assignment31 extends StatefulWidget {
  const Assignment31({super.key});

  @override
  State<Assignment31> createState() => _Assignment31State();
}

class _Assignment31State extends State<Assignment31>
    with TickerProviderStateMixin {
  late final size = MediaQuery.of(context).size;
  late final dropZone = size.width + 100;
  late final AnimationController _position = AnimationController(
    vsync: this,
    duration: Duration(seconds: 1),
    lowerBound: dropZone * -1,
    upperBound: dropZone,
    value: 0.0,
  );

  late final AnimationController _progressController = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 300),
  );

  late Animation<double> _progressAnimation = Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).animate(_curve);

  late final CurvedAnimation _curve = CurvedAnimation(
    parent: _progressController,
    curve: Curves.easeInOut,
  );

  void _animateProgress() {
    final newBegin = _progressAnimation.value;
    final newEnd = _index / (wordBook.length - 1);
    setState(() {
      _progressAnimation = Tween(begin: newBegin, end: newEnd).animate(_curve);
    });
    _progressController.forward(from: 0);
  }

  late final Tween<double> _rotation = Tween(begin: -15, end: 15);

  late final Tween<double> _scale = Tween(begin: 0.8, end: 1.0);

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _position.value += details.delta.dx;
    if (_position.value < 0) {
      setState(() {
        currentColor = reviewColor;
        message = "Need to review";
      });
    } else {
      setState(() {
        currentColor = memorizeColor;
        message = "I got it right";
      });
    }
  }

  void _whenComplete() {
    _position.value = 0;
    setState(() {
      _index = _index == wordBook.length - 1 ? 0 : _index + 1;
      _animateProgress();
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    final bound = size.width - 200;
    if (_position.value.abs() >= bound) {
      final factor = _position.value.isNegative ? -1 : 1;
      _position
          .animateTo((dropZone) * factor, curve: Curves.easeOut)
          .whenComplete(_whenComplete);
    } else {
      _position.animateTo(0, curve: Curves.easeOut);
    }
    setState(() {
      currentColor = baseColor;
      setState(() {
        message = "";
      });
    });
  }

  @override
  void initState() {
    super.initState();
    currentColor = baseColor;
  }

  @override
  void dispose() {
    _position.dispose();
    _progressController.dispose();
    super.dispose();
  }

  int _index = 0;
  String message = "";

  final baseColor = Colors.lightBlue.shade200;
  final reviewColor = Colors.orange.shade500;
  final memorizeColor = Colors.lightGreen.shade200;

  late Color currentColor;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: currentColor,
      appBar: AppBar(
        backgroundColor: currentColor,
        title: const Text('Assignment 31'),
      ),
      body: AnimatedBuilder(
        animation: _position,
        builder: (context, child) {
          final angle =
              _rotation.transform(
                (_position.value + size.width / 2) / size.width,
              ) *
              pi /
              180;
          final scale = _scale.transform(_position.value.abs() / size.width);
          return Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 50,
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Positioned(
                top: 100,
                child: Transform.scale(
                  scale: min(scale, 1.0),
                  child: Card(text: ""),
                ),
              ),
              Positioned(
                top: 100,
                child: GestureDetector(
                  onHorizontalDragUpdate: _onHorizontalDragUpdate,
                  onHorizontalDragEnd: _onHorizontalDragEnd,
                  child: Transform.translate(
                    offset: Offset(_position.value, 0),
                    child: Transform.rotate(
                      angle: angle,
                      child: FlipCard(index: _index),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomSheet: Container(
        color: currentColor,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: AnimatedBuilder(
            animation: _progressAnimation,
            builder:
                (context, child) => CustomPaint(
                  size: Size(size.width - 80, 20),
                  painter: ProgressBar(progressValue: _progressAnimation.value),
                ),
          ),
        ),
      ),
    );
  }
}

class FlipCard extends StatefulWidget {
  final int index;

  const FlipCard({super.key, required this.index});

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 300),
  );
  late Animation<double> _animation =
      _animation = Tween<double>(begin: 0, end: pi).animate(_controller);

  bool _isFront = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() {
      _isFront = !_isFront;
    });
  }

  @override
  Widget build(BuildContext context) {
    final entry = wordBook.entries.elementAt(widget.index);

    return GestureDetector(
      onTap: _flipCard,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          double angle = _animation.value;
          bool isFrontVisible = angle < pi / 2;

          return Transform(
            alignment: Alignment.center,
            transform:
                Matrix4.identity()
                  ..setEntry(3, 2, 0.002) // 3D 효과 추가
                  ..rotateY(angle),
            child:
                isFrontVisible
                    ? Card(text: entry.key) // 앞면
                    : Card(text: entry.value, isFlipped: true), // 뒷면
          );
        },
      ),
    );
  }
}

class Card extends StatelessWidget {
  final String text;
  final bool isFlipped;

  const Card({super.key, required this.text, this.isFlipped = false});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Transform(
      alignment: Alignment.center,
      transform: isFlipped ? Matrix4.rotationY(pi) : Matrix4.identity(),
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          width: size.width * 0.8,
          height: size.height * 0.5,
          child: Center(
            child: Text(
              text,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

class ProgressBar extends CustomPainter {
  final double progressValue;

  ProgressBar({required this.progressValue});

  @override
  void paint(Canvas canvas, Size size) {
    final progress = size.width * progressValue;

    final trackPaint =
        Paint()
          ..color = Colors.black12
          ..style = PaintingStyle.fill;

    final trackRRect = RRect.fromLTRBR(
      0,
      0,
      size.width,
      size.height,
      const Radius.circular(10),
    );

    canvas.drawRRect(trackRRect, trackPaint);

    // progress
    final progressPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

    final progressRRect = RRect.fromLTRBR(
      0,
      0,
      progress,
      size.height,
      const Radius.circular(10),
    );

    canvas.drawRRect(progressRRect, progressPaint);
  }

  @override
  bool shouldRepaint(covariant ProgressBar oldDelegate) {
    return oldDelegate.progressValue != progressValue;
  }
}
