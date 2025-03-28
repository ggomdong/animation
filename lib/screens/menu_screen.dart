import 'package:animation/screens/album/album_screen.dart';
import 'package:animation/screens/apple_watch_screen.dart';
import 'package:animation/screens/assignment29.dart';
import 'package:animation/screens/assignment30.dart';
import 'package:animation/screens/assignment31.dart';
import 'package:animation/screens/explicit_animations_screen.dart';
import 'package:animation/screens/implicit_animations_screen.dart';
import 'package:animation/screens/music_player_screen.dart';
import 'package:animation/screens/swiping_cards_screen.dart';
import 'package:animation/screens/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:animation/screens/assignment28.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  void _goToPage(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Animations')),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                _goToPage(context, const ImplicitAnimationsScreen());
              },
              child: const Text('Implicit Animations'),
            ),
            ElevatedButton(
              onPressed: () {
                _goToPage(context, const Assignment28());
              },
              child: const Text('Assignment 28'),
            ),
            ElevatedButton(
              onPressed: () {
                _goToPage(context, const ExplicitAnimationsScreen());
              },
              child: const Text('Explicit Animations'),
            ),
            ElevatedButton(
              onPressed: () {
                _goToPage(context, const Assignment29());
              },
              child: const Text('Assignment 29'),
            ),
            ElevatedButton(
              onPressed: () {
                _goToPage(context, const AppleWatchScreen());
              },
              child: const Text('Apple Watch'),
            ),
            ElevatedButton(
              onPressed: () {
                _goToPage(context, Assignment30());
              },
              child: const Text('Assignment 30'),
            ),
            ElevatedButton(
              onPressed: () {
                _goToPage(context, SwipingCardsScreen());
              },
              child: const Text('Swiping Cards'),
            ),
            ElevatedButton(
              onPressed: () {
                _goToPage(context, Assignment31());
              },
              child: const Text('Assignment 31'),
            ),
            ElevatedButton(
              onPressed: () {
                _goToPage(context, MusicPlayerScreen());
              },
              child: const Text('Music Player'),
            ),
            ElevatedButton(
              onPressed: () {
                _goToPage(context, WalletScreen());
              },
              child: const Text('Wallet'),
            ),
            ElevatedButton(
              onPressed: () {
                _goToPage(context, AlbumScreen());
              },
              child: const Text('Album App'),
            ),
          ],
        ),
      ),
    );
  }
}
