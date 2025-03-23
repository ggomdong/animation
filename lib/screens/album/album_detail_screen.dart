import 'package:animation/screens/album/widgets/animated_star_rating.dart';
import 'package:animation/screens/album/widgets/track_item.dart';
import 'package:flutter/material.dart';

class AlbumDetailScreen extends StatefulWidget {
  const AlbumDetailScreen({
    super.key,
    required double maxDrag,
    required double dragOffset,
    required this.album,
    required bool isCollapsed,
    required int currentPage,
  }) : _maxDrag = maxDrag,
       _dragOffset = dragOffset,
       _isCollapsed = isCollapsed,
       _currentPage = currentPage;

  final double _maxDrag;
  final double _dragOffset;
  final Map<String, dynamic> album;
  final bool _isCollapsed;
  final int _currentPage;

  @override
  State<AlbumDetailScreen> createState() => _AlbumDetailScreenState();
}

class _AlbumDetailScreenState extends State<AlbumDetailScreen> {
  int _playingTrackIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -widget._maxDrag + widget._dragOffset,
      left: 0,
      right: 0,
      height: 740,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 50),
            Text(
              widget.album['title']!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 30),
            if (widget._isCollapsed)
              AnimatedStarRating(
                key: ValueKey(
                  'star_${widget._currentPage}_${widget._isCollapsed}',
                ),
                score: widget.album['rating'],
              ),
            SizedBox(height: 30),
            Text(
              widget.album['detail']!,
              softWrap: true,
              style: TextStyle(color: Colors.white),
            ),
            TrackItem(
              albumTitle: widget.album['title'],
              albumImagePath: "assets/images/album_${widget.album['id']}.jpg",
              tracks: List<Map<String, String>>.from(widget.album['tracks']),
              playingTrackIndex: _playingTrackIndex,
              onPlay: (index) => setState(() => _playingTrackIndex = index),
            ),
          ],
        ),
      ),
    );
  }
}
