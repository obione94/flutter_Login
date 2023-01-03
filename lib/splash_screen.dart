import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:animated_text_kit/animated_text_kit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.title});
  final String title;
  @override
  State<SplashScreen>  createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {

  bool _loadingInProgress = true;
  late Animation<double> _angleAnimation;
  late Animation<double> _scaleAnimation;
  late AnimationController _controller ;

  final Future <List<String>> _loading = Future<List<String>>.delayed(
    const Duration(milliseconds: 100),
        () {
          List<String> loading =  [
            'Loading ...',
            'Wird geladen ...',
            'Cargando ...',
            'Chargement ...',
            '読み込み中 ...',
            'تحميل ...',
          ];
          loading.shuffle();
          return loading;
        }
  );

  @override
  void initState()  {
    // TODO: implement initState
    super.initState();
    _loadingInProgress = true;
    _controller = AnimationController(
        duration: const Duration(seconds: 6), vsync: this
    );
    _angleAnimation = Tween(begin: 0.0, end: 360.0).animate(_controller)
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });
    _scaleAnimation = Tween(begin: 1.0, end: 5.0).animate(_controller)
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });
    _angleAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
          _controller.reverse();
      }
      if (status == AnimationStatus.dismissed) {
          _controller.forward();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
      Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: _buildAnimation(),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child:
                DefaultTextStyle(
                  style: const TextStyle(
                  fontSize: 40.0,
                  fontFamily: 'Horizon',
                    color: Colors.green
                  ),
                  child: FutureBuilder<List<String>> (
                    future: _loading,
                    builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                      Widget child;
                      if (snapshot.hasData) {
                        child = AnimatedTextKit(
                          animatedTexts: [
                            RotateAnimatedText(snapshot.data![0], textStyle: const TextStyle(color: Colors.green) ),
                            RotateAnimatedText(snapshot.data![1], textStyle: const TextStyle(color: Colors.blue) ),
                            RotateAnimatedText(snapshot.data![2], textStyle: const TextStyle(color: Colors.red) ),
                            RotateAnimatedText(snapshot.data![3], textStyle: const TextStyle(color: Colors.yellow) ),
                          ],
                          pause: const Duration(milliseconds: 900),
                          repeatForever: true,
                        );
                      } else {
                        child = AnimatedTextKit(animatedTexts:[RotateAnimatedText("")]);
                      }
                      return child;
                    }
                  )
              )
            )
          ]
      );

  }

  Widget _buildAnimation() {
    double circleWidth = 10.0 * _scaleAnimation.value;
    Widget circles = SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Row (
            children: <Widget>[
              _buildCircle(circleWidth,Colors.blue),
              _buildCircle(circleWidth,Colors.red),
            ],
          ),
          Row (
            children: <Widget>[
              _buildCircle(circleWidth,Colors.yellow),
              _buildCircle(circleWidth,Colors.green),
            ],
          ),
        ],
      ),
    );

    double angleInDegrees = _angleAnimation.value;
    return Transform.rotate(
      angle: angleInDegrees / 360 * 2 * math.pi,
      child: SizedBox(
        width: circleWidth * 2.0,
        height: circleWidth * 2.0,
        child: circles,
      ),
    );
  }

  Widget _buildCircle(double circleWidth, Color color) {
    return  Container(
      width: circleWidth,
      height: circleWidth,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
