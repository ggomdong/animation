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
    with SingleTickerProviderStateMixin {
  late final size = MediaQuery.of(context).size;
  late final dropZone = size.width + 100;
  late final AnimationController _position = AnimationController(
    vsync: this,
    duration: Duration(seconds: 1),
    lowerBound: dropZone * -1,
    upperBound: dropZone,
    value: 0.0,
  );

  final baseColor = Colors.lightBlue.shade200;
  final reviewColor = Colors.orange.shade500;
  final memorizeColor = Colors.lightGreen.shade200;

  late Color currentColor;

  late final Tween<double> _rotation = Tween(begin: -15, end: 15);

  late final Tween<double> _scale = Tween(begin: 0.8, end: 1.0);

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _position.value += details.delta.dx;
    print(_position.value);
    if (_position.value < 0) {
      setState(() {
        currentColor = reviewColor;
      });
    } else if (_position.value == 0) {
      setState(() {
        currentColor = baseColor;
      });
    }
  }

  void _whenComplete() {
    _position.value = 0;
    setState(() {
      _index = _index == wordBook.length - 1 ? 1 : _index + 1;
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
  }

  @override
  void initState() {
    super.initState();
    currentColor = baseColor;
  }

  @override
  void dispose() {
    _position.dispose();
    super.dispose();
  }

  int _index = 0;

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
                top: 100,
                child: Transform.scale(
                  scale: min(scale, 1.0),
                  child: Card(
                    index: _index == wordBook.length - 1 ? 1 : _index + 1,
                  ),
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
                      child: Card(index: _index),
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
          child: CustomPaint(
            size: Size(size.width - 80, 20),
            painter: ProgressBar(progressValue: _index.toDouble()),
          ),
        ),
      ),
    );
  }
}

class Card extends StatelessWidget {
  final int index;

  const Card({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: size.width * 0.8,
        height: size.height * 0.5,
        child: Center(
          child: Text(
            wordBook.entries.elementAt(index).key,
            style: TextStyle(fontSize: 32),
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
    // track

    final trackPaint =
        Paint()
          ..color = Colors.grey.shade300
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
          ..color = Colors.grey.shade500
          ..style = PaintingStyle.fill;

    final progressRRect = RRect.fromLTRBR(
      0,
      0,
      progressValue,
      size.height,
      const Radius.circular(10),
    );

    canvas.drawRRect(progressRRect, progressPaint);

    // thumb

    canvas.drawCircle(
      Offset(progressValue, size.height / 2),
      10,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant ProgressBar oldDelegate) {
    return false;
  }
}
