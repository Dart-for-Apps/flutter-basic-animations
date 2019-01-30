import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

/// 이 파일은 예제 4 - AnimatedBUilder 에 대한 코드

/// 애니메이션과 별개로 화면에 표시되는 실제 위젯을 정의함
/// 애니메이션 코드와는 완전히 분리 되어 있음
class LogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlutterLogo();
  }
}

/// 애니메이션의 상태정보나 화면에 보여주는 뷰의 정보는 전혀 없이
/// 단순히 애니메이션의 transition 만을 사용하는 consumer 위젯
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
            margin: EdgeInsets.symmetric(vertical: 10.0),
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


/// 실제 애니메이션의 상태정보를 생성하고 관리하는 위젯
/// 애니메이션 정보에 따른 transition 내용이나 뷰의 정보는 전혀 모름.
/// 뷰, 프로듀서, 컨슈머가 완전히 분리되어있다.
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
