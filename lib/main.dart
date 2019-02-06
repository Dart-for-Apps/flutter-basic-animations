import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

import 'animated_builder.dart'; // example 4
import 'simultaneous_animations.dart'; // example 5

import 'hero_animations/standard_hero.dart'; // standard hero animation
import 'hero_animations/radial_hero.dart'; // radial animation 예제

import 'staggered_animation.dart'; // stagger animation 예제


// 이 파일은 example 1 부터 3 까지에 대한 예제 코드
class AnimatedLogo extends AnimatedWidget {
  AnimatedLogo({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        height: animation.value,
        width: animation.value,
        child: FlutterLogo(),
      ),
    );
  }
}

class LogoApp extends StatefulWidget {
  _LogoAppState createState() => _LogoAppState();
}

class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    animation = Tween(begin: 0.0, end: 300.0).animate(controller)
      ..addStatusListener((status) {
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
    return AnimatedLogo(animation: animation);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

void main() {
//  runApp(LogoApp()); // example 1 to 3
//  runApp(LogoAppWithAnimatedBuilder()); // example 4
//  runApp(SimultaneousLogoApp()); // example 5
//  runApp(MaterialApp(
//    home: HeroAnimation(),
//  )); // 기본 히어로 애니메이션
  runApp(MaterialApp(
//    home: RadialExpansionDemo(), // radial 히어로 애니메이션 예제
    home: StaggerDemo(),
  )); //radial 히어로 애니메이션
}
