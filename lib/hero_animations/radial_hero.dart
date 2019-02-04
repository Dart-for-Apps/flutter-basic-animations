import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'dart:math' as math;

// 히어로 애니메이션 대상이 되는 클래스
class Photo extends StatelessWidget {
  final String photo;
  final Color color;
  final VoidCallback onTap;

  Photo({Key key, this.photo, this.onTap, this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      // 애니메이션 변화가 잘보이도록 opacity 추가해서 뒷배경 나오게 함
      color: Theme.of(context).primaryColor.withOpacity(0.25),
      child: InkWell(
        onTap: onTap,
        child: Image.asset(
          photo,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}


class RadialExpansion extends StatelessWidget {
  final double maxRadius;
  final clipRectSize;
  final Widget child;

  RadialExpansion({Key key, this.child, this.maxRadius}) : clipRectSize = 2.0 * (maxRadius / math.sqrt2), super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Center(
        child: SizedBox(
          // child 위젯의 사이즈를 제한함.
          width: clipRectSize,
          height: clipRectSize,
          child: ClipRect(
            child: child,
          ),
        ),
      ),
    );
  }
}

class RadialExpansionDemo extends StatelessWidget {

  static const double kMinRadius = 32.0;
  static const double kMaxRadius = 128.0;
  static const opacityCurve = const Interval(0.0, 0.7, curve: Curves.fastOutSlowIn);

  static RectTween _createRectTween(Rect begin, Rect end) {
    // 실제 이동 중에 사용할 begin/end 크기 지정
    return MaterialRectCenterArcTween(begin: begin, end: end);
  }

  static Widget _buildPage(BuildContext context, String imageName, String desc) {
    // 각 이미지 별 카드 한장 씩 생성하는 메소드
    return Container(
      color: Theme.of(context).canvasColor,
      child: Center(
        child: Card(
          elevation: 8.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: kMaxRadius * 2.0,
                height: kMaxRadius * 2.0,
                child: Hero(
                  // 히어로 위젯이 사용할 tween 지정
                  createRectTween: _createRectTween,
                  tag: imageName,
                  child: RadialExpansion(
                    maxRadius: kMaxRadius,
                    child: Photo(
                      photo: imageName,
                      onTap: () {
                        // 클릭하면 창 닫기
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
              ),
              Text(
                desc,
                style: TextStyle(fontWeight:  FontWeight.bold),
                textScaleFactor: 3.0,
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildHero(BuildContext context, String imageName, String desc) {
    // 히어로 애니메이션 직접 사용하는 클래스
    return Container(
      width: kMinRadius * 2.0,
      height: kMinRadius * 2.0,
      child: Hero(
        createRectTween: _createRectTween,
        tag: imageName,
        child: RadialExpansion(
          maxRadius: kMaxRadius,
          child: Photo(
            photo: imageName,
            onTap: () {
              Navigator.of(context).push(
                // AnimatedBuilder 사용을 위한
                PageRouteBuilder<void>(
                  pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                    return AnimatedBuilder(
                      animation: animation,
                      builder: (BuildContext context, Widget child) {
                        return Opacity(
                          opacity: opacityCurve.transform(animation.value),
//                        opacity: 1.0,
                          child: _buildPage(context, imageName, desc),
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    timeDilation = 5.0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Radial Transition'),
      ),
      body: Container(
        padding: const EdgeInsets.all(32.0),
        alignment: FractionalOffset.bottomLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildHero(context, 'src_images/chair-alpha.png', 'Chair'),
            _buildHero(context, 'src_images/binoculars-alpha.png', 'Binoculars'),
            _buildHero(context, 'src_images/beachball-alpha.png', 'Beach ball'),
          ],
        ),
      ),
    );
  }
}

