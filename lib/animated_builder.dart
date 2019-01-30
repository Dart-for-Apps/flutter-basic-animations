import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

/// 이 파일은 예제 4 - AnimatedBUilder 에 대한 코드

class LogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: FlutterLogo(),
    );
  }
}

class GrowTransition extends StatelessWidget {
  GrowTransition({this.child, this.animation});

  final Widget child;
  final Animation<double> animation;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget child) {
          return Container(
            height: animation.value,
            width: animation.value,
            child: child,
          );
        },
        child: child,
      ),
    );
  }
}

class LogoAppWithAnimatedBuilder extends StatefulWidget {
  @override
  _LogoAppWithAnimatedBuilderState createState() => _LogoAppWithAnimatedBuilderState();
}

class _LogoAppWithAnimatedBuilderState extends State<LogoAppWithAnimatedBuilder>
  with TickerProviderStateMixin{
  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    final CurvedAnimation curvedAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeIn);
    animation = Tween(begin: 0.0, end: 300.0).animate(curvedAnimation);
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GrowTransition(child: LogoWidget(), animation: animation);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


}
