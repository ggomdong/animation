import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TrackItem extends StatefulWidget {
  final String albumTitle;
  final String albumImagePath;
  final List<Map<String, String>> tracks;
  final int playingTrackIndex;
  final ValueChanged<int> onPlay;

  const TrackItem({
    super.key,
    required this.albumTitle,
    required this.albumImagePath,
    required this.tracks,
    required this.playingTrackIndex,
    required this.onPlay,
  });

  @override
  State<TrackItem> createState() => _TrackItemState();
}

class _TrackItemState extends State<TrackItem> {
  late final Color backgroundColor;

  @override
  void initState() {
    super.initState();
    backgroundColor = _getRandomAlbumColor();
  }

  Color _getRandomAlbumColor() {
    final colors = [
      const Color(0xFF752F23),
      const Color(0xFF203345),
      const Color(0xFF3C1D3A),
      const Color(0xFF1A1F2E),
    ];
    return colors[Random().nextInt(colors.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: backgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    widget.albumImagePath,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    widget.albumTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white38),
          ...widget.tracks.asMap().entries.map((entry) {
            final i = entry.key;
            final track = entry.value;
            final isPlaying = i == widget.playingTrackIndex;

            final row = Row(
              children: [
                Text(
                  '${i + 1}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        track['title']!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                              isPlaying ? FontWeight.bold : FontWeight.w600,
                          color: isPlaying ? Colors.white : Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Dream Theater',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Text(
                  track['duration']!,
                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                ),
                IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    widget.onPlay(isPlaying ? -1 : i);
                  },
                ),
              ],
            );

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child:
                  isPlaying
                      ? row.animate().shimmer(
                        duration: 1000.ms,
                        color: Colors.greenAccent,
                      )
                      : row,
            );
          }),
        ],
      ),
    );
  }
}
