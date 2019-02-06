# Staggered Animations

> [원문](https://flutter.io/docs/development/ui/animations/staggered-animations)

이번 챕터에서 배울 내용은 아래와 같다.
- Staggered animation은 연속되거나 겹치는 여러 애니메이션으로 구성된다.
- Staggered animation을 만들기 위해서는 다수의 `Animation` 객체를 사용해야 한다.
- 하나의 `AnimationController`로 모든 애니메이션을 관리한다.
- 개별 `Animation`마다 특정 구간에서 필요한 애니메이션을 따로 정의한다.
- 애니메이션의 각 요소 (크기, 위치 등) 마다 그에 맞는 `Tween`을 생성한다.

> Tween에 관한 내용은 [Animations in Flutter tutorial](https://flutter.io/docs/development/ui/animations/tutorial)를 참조하세요.

Staggered animation은 매우 직관적인 개념이다. 한번에 모든 애니메이션이
동시에 발생하는 것이 아닌 연속된 애니메이션들로 구성되는 것이 staggered
animation이다. 애니메이션들은 겹치는 부분 없이 한 애니메이션이 끝나면
다른 애니메이션으로 넘어가는 완전히 순수한 애니메이션의 연속일 수도 있고,
애니메이션의 일부가 다른 애니메이션과 겹칠 수도 있다. 또는, 두 애니메이션
사이에 짧은 시간 텀을 두고 애니메이션을 쉴 수도 있다.

이번 가이드는 기본적인 staggered animation을 플러터에서 어떻게 구현하는지
설명한다. 사용하는 예제는 [basic_staggered_animation](https://github.com/flutter/website/tree/master/examples/_animation/basic_staggered_animation)이다.
더 복잡한 애니메이션을 만들고 싶은 경우에는 [staggered_pic_selection](https://github.com/flutter/website/tree/master/examples/_animation/staggered_pic_selection)을
참고하기 바란다.

**basic_staggered_animation**은 가장 기본적인 애니메이션으로, 일련의
서로다른 애니메이션들이 연속적으로 수행되는 예제이다. 화면을 탭하면 애니메이션이
시작되고, 한 위젯의 투명도, 크기, 모양, 색깔과 패딩이 변화한다.

**staggered_pic_selection**은 이미지 리스트에서 하나의 이미지를 삭제하는
예제이다. 이 예제에서는 두개의 `animation controller`를 사용한다. 하나는
이미지의 선택/취소에 대한 애니메이션을 관장하고, 다른 하나는 이미지의
삭제에 대한 애니메이션을 관장한다. 이 때 선택/삭제 애니메이션이 staggered
애니메이션으로 구현된다. (애니메이션 효과를 더 확실히 관찰하기 위해서는
`timeDilation` 값을 늘리면 된다.) 가장 큰 이미지를 하나 클릭하면
파란 원 안에 체크마크를 표시하는 뷰로 바뀔때까지 줄어든다. 다시 다른 작은
이미지를 클릭하면, 체크 마크가 사라질때까지 원래 이미지 크기로 돌아간다.
큰 이미지의 크기가 원래대로 확장되기 전에, 작은 이미지가 체크마크 버튼으로
변화하는것을 볼 수 있다. (쉽게 이해하기 위해서는 구글 포토 앱을 깔고,
사진을 길게 눌러서 선택해보면 볼 수 있다.)

[![Staggered animation example](https://img.youtube.com/vi/0fFvnZemmh8/0.jpg)](https://youtu.be/0fFvnZemmh8)

위의 동영상이 이번 가이드에서 만들 예제를 실행한 화면이다. 동영상에서
확인할 수 있듯이, 처음에는 경계선이 있는 파란 사각형으로 시작한다.
이후 애니메이션에 따라서 다음과 같이 변화한다.

1. Fades in (서서히 화면에 등장)
2. 가로 크기 확장
3. 뷰의 가운데로 이동하면서 높이 확장
4. 경계선이 있는 원으로 변화
5. 오렌지 색으로 변화

이후에는 다시 반대 순서로 원래 크기로 돌아간다.

> 이후의 예제코드는 쉬우므로 예제 코드에 대한 번역은 제외합니다. 일부
한글 주석을 예제에 써 놓았으니 [staggered_animation.dart](./lib/staggered_animation.dart)를
참조하시기 바랍니다.
