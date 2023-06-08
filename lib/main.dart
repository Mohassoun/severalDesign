import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.white,
      home: _CardsHandler(),
    );
  }
}

class _CardsHandler extends StatefulWidget {
  const _CardsHandler({Key? key}) : super(key: key);

  @override
  State<_CardsHandler> createState() => _CardsHandlerState();
}

class _BlackHoleClipper extends CustomClipper<Path> {
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
    path.lineTo(0, -1000);

    path.lineTo(size.width, -1000);
    path.close();
    return path;
  }

  bool shouldReclip(_BlackHoleClipper oldClipper) => true;
}

class _Card extends StatelessWidget {
  const _Card({
    Key? key,
    required this.size,
    required this.name,
    required this.image,
    required this.data,
    required this.number,
    required this.elevation,
    required this.error,
  }) : super(key: key);

  final double size;
  final double elevation;
  final String image;
  final String name;
  final String data;
  final int number;
  final String error;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      borderRadius: BorderRadius.circular(10),
      child: SizedBox.square(
        dimension: size,
        child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), //raduis hello word
              color: Colors.blue,
            ),
            child: Center(
                child: Column(
              children: [
                Container(
                  child: Image.asset(image),
                ),
                Container(
                  height: 40,
                  color: Colors.blue,
                  alignment: Alignment.bottomCenter,
                  child: Text(name),
                )
              ],
            ))),
      ),
    );
  }
}

class _CardsHandlerState extends State<_CardsHandler>
    with TickerProviderStateMixin {
  final cardSize = 150.0;

  late final cardOffsetTween = Tween<double>(
    begin: 0,
    end: 2 * cardSize,
  ).chain(CurveTween(curve: Curves.easeInBack));
  late final cardRotationTween = Tween<double>(
    begin: 0,
    end: 0.5,
  ).chain(CurveTween(curve: Curves.easeInBack));
  late final cardElevationTween = Tween<double>(
    begin: 2,
    end: 20,
  );
  late final holeSizeTween = Tween<double>(
    begin: 0,
    end: 1.5 * cardSize,
  );
  String image = "assets/images/dj.png";
  String name = "Chiken";
  int number = 0;
  String error = "";
  bool _isShow = true;
  bool _ShowError = false;

  String data =
      "chicken breasts. The meat itself is lean, and without the bones to insulate it or skin to protect it, the naked chicken breast on the grill has a tendency to easily overcooked .";
  late final cardOffsetAnimationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );
  late final holeAnimationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );

  double get cardOffset =>
      cardOffsetTween.evaluate(cardOffsetAnimationController);
  double get cardRotation =>
      cardRotationTween.evaluate(cardOffsetAnimationController);
  double get cardElevation =>
      cardElevationTween.evaluate(cardOffsetAnimationController);
  double get holeSize => holeSizeTween.evaluate(holeAnimationController);

  void minus() {
    if (number < 1) {
      error = "Invalide";
      _isShow = false;
      _ShowError = true;
    } else {
      number = number - 1;

      error = "";
      _isShow = true;
      _ShowError = false;
    }
    setState(() {});
  }

  void add() {
    if (number < 0) {
      number = number + 1;

      error = "Invalide";
      _isShow = false;
      _ShowError = true;
    } else {
      number = number + 1;

      error = "";
      _isShow = true;
      _ShowError = false;
    }
    setState(() {});
  }

  @override
  initState() {
    super.initState();
    holeAnimationController.addListener(() => setState(() {}));
    cardOffsetAnimationController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' '),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Visibility(
            visible: _isShow,
            child: Text("number of items : " + number.toString()),
          ),
          Visibility(
            visible: _ShowError,
            child: Text(
              "number of items : " + error,
              style: TextStyle(color: Colors.red),
            ),
          ),
          Container(
            height: 2,
            color: Colors.blue,
          ),
          Container(
            alignment: AlignmentDirectional.center,
            height: 180,
            width: 250,
            child: Text(data),
          ),
          const SizedBox(width: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 20),
              //button-
              ElevatedButton(
                onPressed: () async {
                  minus();
                  cardOffsetAnimationController.reverse();
                  holeAnimationController.reverse();
                },
                child: Text('_'),
                // Icon(Icons.remove),
              ),
              const SizedBox(width: 20),
              //button +

              ElevatedButton(
                onPressed: () async {
                  Future.delayed(Duration(milliseconds: 200), () {
                    add();
                  });
                  //async w awair 7ata yntru ljura
                  holeAnimationController.forward(); //for hole
                  await cardOffsetAnimationController.forward();

                  Future.delayed(Duration(milliseconds: 200),
                      () => holeAnimationController.reverse());
                  if (number < 0) {
                    error = "Invalide";
                    _isShow = false;
                    _ShowError = true;
                  }
                  if (number > 0) {
                    error = "";
                    _isShow = true;
                    _ShowError = false;
                  }
                },
                child: Text('Add item to basket'),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: ClipPath(
          clipper: _BlackHoleClipper(),
          child: Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                width: holeSize,
                child: Image.asset(
                  'assets/images/hole.png',
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                child: Center(
                  child: Transform.translate(
                    offset: Offset(0, cardOffset),
                    child: Transform.rotate(
                      angle: cardRotation,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: _Card(
                          name: name,
                          data: data,
                          number: number,
                          size: cardSize,
                          error: error,
                          image: image,
                          elevation: cardElevation,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Opacity(
                opacity: 0,
                child: SizedBox(
                  width: cardSize * 1.5,
                  child: Image.asset("assets/images/hole.png"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
