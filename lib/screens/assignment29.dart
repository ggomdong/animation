import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class Assignment29 extends StatefulWidget {
  const Assignment29({super.key});

  @override
  State<Assignment29> createState() => _Assignment29State();
}

class _Assignment29State extends State<Assignment29> {
  final List<Offset> _items = [];
  final Map<Offset, double> _opacityMap = {}; // 각 박스의 투명도 관리
  final int _totalItems = 25;
  int _currentIndex = 0;
  bool _isRestarting = false;

  // 우하단 → 좌상단 순서
  final List<Offset> _gridPositions = [
    Offset(4, 4),
    Offset(3, 4),
    Offset(2, 4),
    Offset(1, 4),
    Offset(0, 4),
    Offset(0, 3),
    Offset(1, 3),
    Offset(2, 3),
    Offset(3, 3),
    Offset(4, 3),
    Offset(4, 2),
    Offset(3, 2),
    Offset(2, 2),
    Offset(1, 2),
    Offset(0, 2),
    Offset(0, 1),
    Offset(1, 1),
    Offset(2, 1),
    Offset(3, 1),
    Offset(4, 1),
    Offset(4, 0),
    Offset(3, 0),
    Offset(2, 0),
    Offset(1, 0),
    Offset(0, 0),
  ];

  void _startAnimation() {
    _items.clear();
    _opacityMap.clear();
    _currentIndex = 0;
    _isRestarting = false;

    Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (mounted && _currentIndex < _totalItems) {
        Offset pos = _gridPositions[_currentIndex];

        setState(() {
          _items.add(pos);
          _opacityMap[pos] = 0.0; // 처음에는 완전 투명
        });

        _fadeIn(pos); // 0 → 1 애니메이션 시작

        _currentIndex++;

        // 마지막 박스가 나타나기 전에 다음 사이클 시작 (자연스럽게 연결)
        if (_currentIndex == _totalItems - 5) {
          _restartAnimation();
        }
      } else {
        timer.cancel();
      }
    });
  }

  void _fadeIn(Offset pos) {
    double opacity = 0.0;
    Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (opacity < 1.0) {
        setState(() {
          opacity = min(1.0, opacity + 0.1); // 1.0을 넘지 않도록 제한
          _opacityMap[pos] = opacity;
        });
      } else {
        timer.cancel();
        // 불투명 상태 1초 유지 후 사라짐
        Future.delayed(const Duration(milliseconds: 30), () {
          _fadeOut(pos);
        });
      }
    });
  }

  void _fadeOut(Offset pos) {
    double opacity = 1.0;
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (mounted && opacity > 0.0) {
        setState(() {
          opacity = max(0.0, opacity - 0.1); // 0.0 이하로 내려가지 않도록 제한
          _opacityMap[pos] = opacity;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _restartAnimation() {
    if (!_isRestarting) {
      _isRestarting = true;

      Future.delayed(const Duration(milliseconds: 900), () {
        _startAnimation();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double cellSize = 45; // 셀 크기
    double spacing = 40; // 간격 추가

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('Assignment 29')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SizedBox(
            width: (cellSize + spacing) * 5,
            height: (cellSize + spacing) * 5,
            child: Stack(
              children:
                  _items.map((pos) {
                    return Positioned(
                      left: pos.dx * (cellSize + spacing),
                      top: pos.dy * (cellSize + spacing),
                      child: Opacity(
                        opacity: _opacityMap[pos] ?? 0.0,
                        child: Container(
                          width: cellSize,
                          height: cellSize,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
