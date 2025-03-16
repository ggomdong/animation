import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Assignment30 extends StatefulWidget {
  const Assignment30({super.key});

  @override
  State<Assignment30> createState() => _Assignment30State();
}

class _Assignment30State extends State<Assignment30>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController =
      AnimationController(
          vsync: this,
          duration: Duration(seconds: _currentSeconds),
          lowerBound: 0,
          upperBound: 2.0,
        )
        ..addListener(() => _range.value = _animationController.value)
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            setState(() {
              if (_isRest) {
                _currentSeconds = workSeconds;
                _currentColor = workColor;
                if (_currentRound % 4 == 0) {
                  _currentRound = 1;
                  _goal = _goal + 1;
                } else {
                  _currentRound = _currentRound + 1;
                }
              } else {
                if (_currentRound % 4 == 0) {
                  _currentSeconds = longRestSeconds;
                  _currentColor = longRestColor;
                } else {
                  _currentSeconds = shortRestSeconds;
                  _currentColor = shortRestColor;
                }
              }
              _animationController.duration = Duration(
                seconds: _currentSeconds,
              );
              _isRest = !_isRest;
              _reset();
              _play();
            });
          }
        });

  // 작업시간과 휴식시간 정의
  final int workSeconds = 3;
  final int shortRestSeconds = 1;
  final int longRestSeconds = 2;
  // final int workSeconds = 25 * 60;
  // final int shortRestSeconds = 5 * 60;
  // final int longRestSeconds = 15 * 60;

  // 배경색상 정리
  final workColor = Colors.white;
  final shortRestColor = Colors.amber.shade200;
  final longRestColor = Colors.lightGreen.shade200;

  // 현재 라운드
  late int _currentRound;

  // 4라운드 완료시 1증가
  late int _goal;

  // 현재 타이머 시간
  late int _currentSeconds;

  // 현재 배경 색상
  late Color _currentColor;

  late bool _isRunning;
  late bool _isRest;

  // 초기화
  void initialize() {
    _currentRound = 1;
    _goal = 0;
    _currentSeconds = workSeconds;
    _currentColor = workColor;
    _isRunning = false;
    _isRest = false;
    _animationController.duration = Duration(seconds: _currentSeconds);
    setState(() {});
  }

  final ValueNotifier<double> _range = ValueNotifier(0.0);

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _play() {
    _isRunning = true;
    _animationController.forward();
    setState(() {});
  }

  void _pause() {
    _isRunning = false;
    _animationController.stop();
    setState(() {});
  }

  void _stop() {
    _animationController.stop();

    showCupertinoDialog(
      context: context,
      builder:
          (context) => CupertinoAlertDialog(
            title: const Text("정말 중단하시겠습니까?"),
            content: const Text("(주의)Goal 이 초기화됩니다."),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();
                  _play();
                },
                child: const Text("아니오"),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();
                  initialize();
                  _reset();
                },
                isDestructiveAction: true,
                child: const Text("예"),
              ),
            ],
          ),
    );
  }

  void _reset() {
    _isRunning = false;
    _animationController.reset();
    setState(() {});
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    return Scaffold(
      backgroundColor: _currentColor,
      appBar: AppBar(
        title: const Text('Assignment 30'),
        backgroundColor: _currentColor,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: 100,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.lightBlue,
                    ),
                    child: Text(
                      "Rounds",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    "$_currentRound",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: 100,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.cyan,
                    ),
                    child: Text(
                      "Goals",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    "$_goal",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 150),
            Stack(
              alignment: Alignment.topCenter,
              children: [
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: PomodoroPainter(
                        progress: _animationController.value,
                      ),
                      size: Size(300, 300),
                    );
                  },
                ),
                Positioned(
                  top: 30,
                  child: ValueListenableBuilder(
                    valueListenable: _range,
                    builder: (context, value, child) {
                      return Text(
                        formatTime(
                          _currentSeconds -
                              (value * _currentSeconds / 2).floor(),
                        ),
                        style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -3,
                          color: Colors.black,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _reset,
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade200,
                    ),
                    child: Icon(Icons.replay, color: Colors.grey.shade400),
                  ),
                ),
                SizedBox(width: 30),
                GestureDetector(
                  onTap: _isRunning ? _pause : _play,
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red.shade400,
                    ),
                    child: Icon(
                      _isRunning ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                SizedBox(width: 30),
                GestureDetector(
                  onTap: _stop,
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade200,
                    ),
                    child: Icon(Icons.stop, color: Colors.grey.shade400),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class PomodoroPainter extends CustomPainter {
  PomodoroPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 4);
    final radius = size.width / 2 - 10;
    final double strokeWidth = 23;

    final circlePaint =
        Paint()
          ..color = Colors.grey.shade200
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, circlePaint);

    final arcRect = Rect.fromCircle(center: center, radius: radius);

    final arcPaint =
        Paint()
          ..color = Colors.red.shade400
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = strokeWidth;

    canvas.drawArc(arcRect, -0.5 * pi, progress * pi, false, arcPaint);
  }

  @override
  bool shouldRepaint(covariant PomodoroPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
