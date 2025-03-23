import 'dart:ui';

import 'package:animation/models/album_model.dart';
import 'package:animation/screens/album/album_detail_screen.dart';
import 'package:animation/screens/album/widgets/album_navigator.dart';
import 'package:animation/screens/album/widgets/typing_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AlbumScreen extends StatefulWidget {
  const AlbumScreen({super.key});

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController(viewportFraction: 0.92);
  int _currentPage = 0;
  int _previousPage = -1;
  final ValueNotifier<double> _scroll = ValueNotifier(0.0);
  // 움직이는 정도를 나타내는 변수
  double _dragOffset = 0;
  // 최대 움직일 수 있는 값
  final double _maxDrag = 550.0;
  // 카드 접힘 유무
  bool _isCollapsed = false;

  // 버튼 클릭시 애니메이션 처리용
  late final AnimationController _collapseController = AnimationController(
    vsync: this,
    duration: 700.ms,
  );
  late Animation<double> _dragAnimation;

  // 타이틀 marquee 처리용
  late final AnimationController _marqueeController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 5),
  )..repeat();

  late final Animation<Offset> _marqueeTween = Tween(
    begin: const Offset(0.5, 0),
    end: const Offset(-1.0, 0),
  ).animate(_marqueeController);

  void _onPageChanged(int newPage) {
    setState(() {
      _previousPage = _currentPage;
      _currentPage = newPage;
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (_pageController.page == null) return;
      _scroll.value = _pageController.page!;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _collapseController.dispose();
    _marqueeController.dispose();
    super.dispose();
  }

  // 버튼으로 카드 접기/펴기
  void _onCollapseCard(bool collapse) {
    final begin = _dragOffset;
    final end = collapse ? _maxDrag : 0.0;

    _dragAnimation = Tween<double>(begin: begin, end: end).animate(
      CurvedAnimation(parent: _collapseController, curve: Curves.easeInOut),
    )..addListener(() {
      setState(() {
        _dragOffset = _dragAnimation.value;
      });
    });

    // 애니메이션 완료 후 _isCollapsed 를 변경하여, 앨범카드를 끝까지 유지
    void onCompleted(AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isCollapsed = collapse;
        });
        // 한번만 실행
        _collapseController.removeStatusListener(onCompleted);
      }
    }

    _collapseController.addStatusListener(onCompleted);

    _collapseController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: Duration(seconds: 1),
            child: Container(
              key: ValueKey(_currentPage),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/album_${_currentPage + 1}.jpg",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(color: Colors.black.withValues(alpha: 0.5)),
              ),
            ),
          ),
          PageView.builder(
            // 카드가 접힌 상태에서는 스크롤 안되게 처리
            physics: _isCollapsed ? NeverScrollableScrollPhysics() : null,
            onPageChanged: _onPageChanged,
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            itemCount: albums.length,
            itemBuilder: (context, index) {
              final currentPage = _currentPage == index;
              final album = albums[index];
              return Padding(
                padding: const EdgeInsets.only(top: 0),
                child: GestureDetector(
                  onVerticalDragUpdate: (details) {
                    setState(() {
                      _dragOffset += details.delta.dy;
                      _dragOffset = _dragOffset.clamp(0, _maxDrag);
                    });
                  },
                  onVerticalDragEnd: (details) {
                    setState(() {
                      if (_dragOffset > _maxDrag / 2) {
                        _isCollapsed = true;
                        _dragOffset = _maxDrag;
                      } else {
                        _isCollapsed = false;
                        _dragOffset = 0;
                      }
                    });
                  },
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      // Detail 영역
                      if (_dragOffset != 0)
                        AlbumDetailScreen(
                          maxDrag: _maxDrag,
                          dragOffset: _dragOffset,
                          album: album,
                          isCollapsed: _isCollapsed,
                          currentPage: _currentPage,
                        ),
                      // 상단 스크롤 버튼 영역
                      if (!_isCollapsed && _dragOffset == 0)
                        Positioned(
                          top: 50,
                          child: IconButton(
                            onPressed: () => _onCollapseCard(true),
                            icon: Icon(Icons.keyboard_double_arrow_up),
                            color: Colors.white,
                          ),
                        ),
                      // 배경 카드 영역
                      Positioned(
                        bottom: 0 - _dragOffset,
                        child: Container(
                          height: 600,
                          width: size.width * 0.85,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 200,
                              left: 20,
                              right: 20,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                album['title'].toString().length > 22
                                    ? ClipRect(
                                      child: SlideTransition(
                                        position: _marqueeTween,
                                        child: Text(
                                          album['title']!,
                                          maxLines: 1,
                                          overflow: TextOverflow.visible,
                                          softWrap: false,
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    )
                                    : Text(
                                      album['title'],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                SizedBox(height: 10),
                                Text(
                                  "${album['category']!} / ${album['release']!}",
                                ),
                                SizedBox(height: 20),
                                SingleChildScrollView(
                                  child: TypingText(
                                    text: album['intro']!,
                                    style: TextStyle(fontSize: 16),
                                    target: currentPage ? 1 : 0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Buy 버튼 영역
                      Positioned(
                        bottom: 20 - _dragOffset,
                        child: TextButton.icon(
                          onPressed: () {},
                          icon: Icon(
                            Icons.add_shopping_cart,
                            color: Colors.white,
                          ),
                          label: Text(
                            "Buy Now!",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.amber,
                            minimumSize: const Size(200, 50),
                          ),
                        ),
                      ),
                      // 앨범 카드 영역
                      Positioned(
                        top: 100 + _dragOffset * 1.5,
                        child: ValueListenableBuilder(
                          valueListenable: _scroll,
                          builder: (context, scroll, child) {
                            return Container(
                              height: 300,
                              width: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.4),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                    offset: Offset(0, 8),
                                  ),
                                ],
                                image: DecorationImage(
                                  image: AssetImage(
                                    "assets/images/album_${index + 1}.jpg",
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ).animate(
                              target: currentPage ? 1 : 0,
                              effects: [
                                if (currentPage && _dragOffset == 0)
                                  SlideEffect(
                                    begin:
                                        _currentPage > _previousPage
                                            ? const Offset(0.1, 0)
                                            : const Offset(-0.1, 0),
                                    end: Offset.zero,
                                    duration: 500.ms,
                                    curve: Curves.easeOut,
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                      // 하단 스크롤 버튼 영역
                      if (_isCollapsed)
                        Positioned(
                          bottom: 50,
                          child: IconButton(
                            onPressed: () => _onCollapseCard(false),
                            icon: Icon(Icons.keyboard_double_arrow_down),
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: AlbumNavigator(
        albums: albums,
        currentPage: _currentPage,
        onPageSelected: (index) {
          final distance = (_currentPage - index).abs();
          final duration = Duration(
            milliseconds: (300 + distance * 100).clamp(300, 1000),
          );
          _pageController.animateToPage(
            index,
            duration: duration,
            curve: Curves.easeOutCubic,
          );
        },
      ),
    );
  }
}
