import 'dart:math';

import 'package:animation_task_1/custom_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final double cardSize = 150;
  late final holeSizeTween = Tween<double>(begin: 0, end: 1.5 * cardSize);
  late final holeAnimationController = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 300),
  );
  double get holeSize => holeSizeTween.evaluate(holeAnimationController);

  late final cardOffsetAnimationController = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 1000),
  );

  late final cardOffsetTween = Tween<double>(begin: 0, end: cardSize * 2)
      .chain(CurveTween(curve: Curves.easeInBack));

  late final cardRotationTween = Tween<double>(begin: 0, end: 0.5)
      .chain(CurveTween(curve: Curves.easeInBack));

  late final cardElevationTween = Tween<double>(begin: 0, end: 20);

  double get cardOffset =>
      cardOffsetTween.evaluate(cardOffsetAnimationController);
  double get cardRotation =>
      cardRotationTween.evaluate(cardOffsetAnimationController);
  double get cardElevation =>
      cardElevationTween.evaluate(cardOffsetAnimationController);

  @override
  void initState() {
    holeAnimationController.addListener(() => setState(() {}));
    cardOffsetAnimationController.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    holeAnimationController.dispose();
    cardOffsetAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () async {
              holeAnimationController.forward();
              await cardOffsetAnimationController.forward();
              Future.delayed(Duration(seconds: 200),
                  () => holeAnimationController.reverse());
            },
            child: Icon(Icons.remove),
          ),
          SizedBox(
            width: 20,
          ),
          FloatingActionButton(
            onPressed: () {
              holeAnimationController.reverse();
              cardOffsetAnimationController.reverse();
            },
            child: Icon(Icons.add),
          )
        ],
      ),
      body: Center(
        child: SizedBox(
          height: cardSize,
          child: ClipPath(
            clipper: BlackHoleClipper(),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox(
                  child: Image.asset(
                    width: holeSize * 1.25,
                    'images/hole.png',
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  child: Center(
                    child: Transform.translate(
                      offset: Offset(0, cardOffset),
                      child: Transform.rotate(
                        angle: cardRotation,
                        child: CustomCard(
                          size: cardSize,
                          elevation: cardElevation,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BlackHoleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height / 2);
    path.arcTo(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: size.width,
        height: size.height,
      ),
      0,
      pi,
      true,
    );
    // Using -1000 guarantees the card won't be clipped at the top, regardless of its height
    path.lineTo(0, -1000);
    path.lineTo(size.width, -1000);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(BlackHoleClipper oldClipper) => false;
}
