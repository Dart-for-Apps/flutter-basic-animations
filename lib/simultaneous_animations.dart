import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class SimultaneousLogo extends AnimatedWidget {
  // 위젯을 재사용 할 때에도 전혀 변하지 않는 값이므로
  // static 변수로 사용한다.
  static final _opacityTween = Tween<double>(begin: 0.1, end: 1.0);
  static final _sizeTween = Tween<double>(begin: 0.0, end: 300.0);

  SimultaneousLogo({Key key, Animation<double> animation})
    :super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    // 하나의 animation 이 만들어내는 값으로
    // 두개의 transition 을 관리한다.
    final Animation<double> animation = listenable;
    final double _opacity = _opacityTween.evaluate(animation);
    final double _size = _sizeTween.evaluate(animation);
    return Center(
      child: Opacity(
        opacity: _opacity,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          height: _size,
          width: _size,
          child: FlutterLogo(),
        ),
      ),
    );
  }
}

class SimultaneousLogoApp extends StatefulWidget {
  @override
  _SimultaneousLogoAppState createState() => _SimultaneousLogoAppState();
}

class _SimultaneousLogoAppState extends State<SimultaneousLogoApp>
    with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;


  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    // AnimationController와 CurvedAnimation은 대체가 가능하고
    // AnimationController는 특수한 animation 객체 이므로
    // 곧바로 할당 가능하다.
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    // 예제 3에서 사용한 코드와 동일하다
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SimultaneousLogo(animation: animation);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


}
