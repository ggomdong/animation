import 'dart:async';

import 'package:flutter/material.dart';

class Assignment28 extends StatefulWidget {
  const Assignment28({super.key});

  @override
  State<Assignment28> createState() => _Assignment28State();
}

class _Assignment28State extends State<Assignment28> {
  bool _toRight = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(
      Duration(seconds: 1),
      (timer) => setState(() {
        _toRight = !_toRight;
      }),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _toRight ? Colors.white : Colors.black,
      appBar: AppBar(title: const Text('Assignment 28')),
      body: Center(
        child: Stack(
          children: [
            Container(
              height: 240,
              width: 240,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: _toRight ? BoxShape.circle : BoxShape.rectangle,
              ),
              child: AnimatedAlign(
                alignment: _toRight ? Alignment.topLeft : Alignment.topRight,
                duration: Duration(seconds: 1),
                child: Container(
                  height: 240,
                  width: 15,
                  decoration: BoxDecoration(
                    color: _toRight ? Colors.black : Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
