import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AlbumNavigator extends StatelessWidget {
  final List<Map<String, dynamic>> albums;
  final int currentPage;
  final ValueChanged<int> onPageSelected;

  const AlbumNavigator({
    super.key,
    required this.albums,
    required this.currentPage,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    final controller = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final itemWidth = 56;
      final screenWidth = MediaQuery.of(context).size.width;
      final maxScrollExtent = (albums.length * itemWidth) - screenWidth;
      final centerOffset =
          ((currentPage) * itemWidth) - (screenWidth - itemWidth) / 2;
      final clampedOffset = centerOffset.clamp(0.0, maxScrollExtent);

      // 현재 스크롤 위치(controller)와 보정된 중앙 위치(clampedOffset)가 차이나면 이동
      if (controller.hasClients &&
          (controller.offset - clampedOffset).abs() > 1.0) {
        controller.animateTo(
          clampedOffset,
          duration: 300.ms,
          curve: Curves.easeOut,
        );
      }
    });

    return SizedBox(
      height: 100,
      child: ListView.builder(
        controller: controller,
        scrollDirection: Axis.horizontal,
        itemCount: albums.length,
        itemBuilder: (context, index) {
          final isSelected = index == currentPage;
          return GestureDetector(
            onTap: () => onPageSelected(index),
            child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                      width: isSelected ? 2 : 1,
                    ),
                    image: DecorationImage(
                      image: AssetImage("assets/images/album_${index + 1}.jpg"),
                      fit: BoxFit.contain,
                    ),
                  ),
                )
                .animate(target: isSelected ? 1 : 0)
                .scale(
                  begin: Offset(0.9, 0.9),
                  end: Offset(1.2, 1.2),
                  duration: 300.ms,
                ),
          );
        },
      ),
    );
  }
}
