import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class StaggerAnimation extends StatelessWidget {
  // controller는 0.0에서 1.0 사이의 value를 갖는 전체 애니메이션을 관장하는 객체
  // 이를 제외한 나머지 Animation들이 각각의 정의에 따라
  // 역할별 애니메이션에 사용됨.
  final Animation<double> controller;
  final Animation<double> opacity;
  final Animation<double> width;
  final Animation<double> height;
  final Animation<EdgeInsets> padding;
  final Animation<BorderRadius> borderRadius;
  final Animation<Color> color;

  // 0.0 - 1.0 사이의 값을 갖는 `controller` 애니메이션을 통해서
  // 적절한 interval에 맞춰 필요한 애니메이션을 생성.
  // Interval() 객체를 통해, 내 애니메이션이 사용될 구간을 설정함.
  StaggerAnimation({Key key, this.controller}) :
        opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 0.100, curve: Curves.ease),
          ),
        ),
        width = Tween<double>(begin: 50.0, end: 150.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.125, 0.250, curve: Curves.ease),
          ),
        ),
        height = Tween<double>(begin: 50.0, end: 150.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.250, 0.375, curve: Curves.ease),
          ),
        ),
        padding = EdgeInsetsTween(
            begin: const EdgeInsets.only(bottom: 16.0),
            end: const EdgeInsets.only(bottom: 75.0)
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(0.25, 0.375, curve: Curves.ease),
          ),
        ),
        borderRadius = BorderRadiusTween(
          begin: BorderRadius.circular(4.0),
          end: BorderRadius.circular(75.0),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.375, 0.500,
              curve: Curves.ease,
            ),
          ),
        ),
        color = ColorTween(
          begin: Colors.indigo[100],
          end: Colors.orange[400],
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.500, 0.750,
              curve: Curves.ease,
            ),
          ),
        ),
        super(key:key);

  Widget _buildAnimation(BuildContext context, Widget child) {
    return Container(
      padding: padding.value,
      alignment: Alignment.bottomCenter,
      child: Opacity(
        opacity: opacity.value,
        child: Container(
          width: width.value,
          height: height.value,
          decoration: BoxDecoration(
            color: color.value,
            border: Border.all(
              color: Colors.indigo[300],
              width: 3.0,
            ),
            borderRadius: borderRadius.value,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }
}


class StaggerDemo extends StatefulWidget {
  @override
  _StaggerDemoState createState() => _StaggerDemoState();
}

class _StaggerDemoState extends State<StaggerDemo> with SingleTickerProviderStateMixin{
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // 2초 간 애니메이션 수행함.
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _playAnimation() async {
    try {
      // 일단 정방향 실행 후, 끝나면 역방향 실행. await는 dart:async 참조
      await _controller.forward().orCancel;
      await _controller.reverse().orCancel;
    } on TickerCanceled {
      // 애니메이션이 중간에 dispose 된 경우 이 에러 발생
      // 본 예제에서는 화면 탭을 중복해서 여러번 하기 때문에,
      // 두 번째 이상의 탭에서 발생하는 _playAnimation()이 이전 애니메이션을
      // 취소하게 됨.
      print("ㅎ-ㅎ 중간에 한번더 클릭하셧나봐요");
      print("${_controller.view} 에서부터 다시 시작할게요 :)");
    }
  }
  @override
  Widget build(BuildContext context) {
    timeDilation = 1.0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staggered 애니메이션'),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          _playAnimation();
        },
        child: Center(
          child: Container(
            width: 300.0,
            height: 300.0,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              border: Border.all(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            child: StaggerAnimation(
              // AnimationController가 시간에 따라 생성하는 Animation 객체가
              // `view` 프로퍼티에 할당됨.
              // 해당 Animation의 값은 항상 0.0 에서 1.0 사이로 고정되어 있으므로,
              // 다른 Animation을 만들기 위해 편하게 사용할 수 있음.
              controller: _controller.view,
            ),
          ),
        ),
      ),
    );
  }
}
