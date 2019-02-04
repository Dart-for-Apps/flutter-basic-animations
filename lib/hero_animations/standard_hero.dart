import 'package:flutter/material.dart';

class PhotoHero extends StatelessWidget {
  const PhotoHero({Key key, this.photo, this.width, this.onTap})
    : super(key: key);

  final String photo;
  final VoidCallback onTap;
  final double width;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Hero(
        tag: photo,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Image.asset(
              photo,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}


class HeroAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double timeDilation = 5.0;
    String src = 'src_images/flippers-alpha.png';

    return Scaffold(
      appBar: AppBar(
        title: const Text('기본 히어로 애니메이션'),
      ),
      body: Center(
        child: PhotoHero(
          photo: src,
          width: 300.0,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext _context) {
                return Scaffold(
                  appBar: AppBar(
                    title: const Text("Flippers Page"),
                  ),
                  body: Container(
                    color: Colors.lightBlueAccent,
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.topLeft,
                    child: PhotoHero(
                      photo: src,
                      width: 100.0,
                      onTap: () {
                        // 이미지를 클릭했을 때, 뒤로 가기
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}
