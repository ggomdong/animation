import 'package:flutter/material.dart';

class ImplicitAnimationsScreen extends StatefulWidget {
  const ImplicitAnimationsScreen({super.key});

  @override
  State<ImplicitAnimationsScreen> createState() =>
      _ImplicitAnimationsScreenState();
}

class _ImplicitAnimationsScreenState extends State<ImplicitAnimationsScreen> {
  bool _visible = true;

  // void _trigger() {
  //   setState(() {
  //     _visible = !_visible;
  //   });
  // }

  void _trigger() {
    setState(() {
      _visible = !_visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: _visible ? Colors.white : Colors.black,
      appBar: AppBar(title: const Text('Implict Animations')),
      body: Center(
        child: Stack(
          children: [
            // Container(
            //   height: 400,
            //   width: 400,
            //   decoration: BoxDecoration(
            //     color: _visible ? Colors.black : Colors.white,
            //     border: Border.all(color: Colors.black, width: 1),
            //   ),
            // ),
            Container(
              height: 240,
              width: 240,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: _visible ? BoxShape.circle : BoxShape.rectangle,
              ),
              child: AnimatedAlign(
                alignment: _visible ? Alignment.topLeft : Alignment.topRight,
                duration: Duration(seconds: 1),
                child: AnimatedContainer(
                  height: 240,
                  width: 10,
                  duration: Duration(seconds: 1),
                  decoration: BoxDecoration(color: Colors.white),
                ),
              ),
            ),
            ElevatedButton(onPressed: _trigger, child: const Text('Go!')),
          ],
        ),
      ),
    );
  }
}
