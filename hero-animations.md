# Hero Animations

Hero Animations 챕터에서 배우는 내용은 아래와 같다
- *hero*는 서로 다른 스크린 사이에서 공유되는 위젯을 의미한다
- 플러터에서는 `Hero` 위젯으로 히어로 애니메이션을 구성할 수 있다.
- 예제를 통해 한 스크린에서 다른 스크린으로 넘어가는 히어로를 구현한다
- 스크린 사이를 넘어갈 떄 원형 박스에서 사각형 박스로 변경하는 예제를 실습한다.
- 플러터에서의 `Hero`는 *shared element transition* 혹은 *shared element animation*
으로 알려진 흔히 사용되는 애니메이션을 구현한 위젯이다.

다양한 앱속에서 이미 수많은 히어로 애니메이션을 보고 경험했을 것이다.
예를 들어 많은 썸네일 리스트를 제공하는 스크린에서 특정 아이템을 선택할 경우,
새로운 화면으로 넘어가면서 해당 썸네일이 디테일 페이지로 위치가 크기가 변경되면서
넘어가는 경우가 있다. 이러한 것을 *shared element transition*이라고 부르는데
플러터에서는 히어로 애니메이션이라고 표현한다.

본 챕터에서 다루는 가이드는 기본적으로 단순히 공유만 되는 히어로 애니메이션과
원형 박스에서 사각형 박스로 변화하는 히어로 애니메이션을 담고 있다.

- [Basic structure of a hero animation](#Basic-structure-of-a-hero-animation)
- [Standard Hero Animation](#Standard-Hero-Animation)
- [Radial Hero Animation](#Radial-Hero-Animation)

스크린을 넘어갈 때 히어로 위젯을 통해 히어로 애니메이션을 실행하면,
다음으로 나올 화면에서 히어로 위젯의이 들어갈 위치는 비어있는 채로 화면에
스크린이 렌더링 된다. 보통 히어로 위젯은 전체 UI중에서 단순 이미지 같은
서로 다른 스크린에서 공유되는 작은 부분을 구성하고 있다. 유저의 관점에서
바라보면 히어로는 서로 다른 스크린을 날아가면서 이동하는것처럼 표현된다.

##### Standart hero animations 예시

일반적인 표준 히어로 애니메이션은 히어로가 서로 다른 스크린 사이에서,
서로 다른 위치와 크기로 이동하는 것을 표현한다.

아래에 링크된 비디오가 일반적인 예제를 보여준다. 화면의 오리발을 탭하면
새로운 파란화면의 좌상단으로 이동하고 크기가 작아진다. 다시한번 탭하면
화면의 중앙으로 오면서 크기가 커진다. (사진을 클릭하면 이동합니다.)

[![기본 히어로 애니메이션 예제](http://img.youtube.com/vi/CEcFnqRDfgw/0.jpg)](https://youtu.be/CEcFnqRDfgw)

##### Radial hero animations

방사형 (radial) 히어로 애니메이션은, 히어로가 원형에서 사각형으로 변경되면서
이동하는 애니메이션이다.

아래에 링크된 비디오가 래디얼 히어로 애니메이션의 예제를 보여준다.
처음 시작에는 하단에 세개의 원형 이미지가 있지만, 그들을 클릭할 경우
새로운 스크린으로 넘어가면서 사각형으로 변하는 것을 알 수 있다. (사진을 클릭하면 이동합니다.)

[![래디얼 히어로 애니메이션 예제](http://img.youtube.com/vi/LWKENpwDKiM/0.jpg)](https://youtu.be/LWKENpwDKiM)

이후 곧바로 예제 코드로 넘어가지 말고 본 가이드를 순서대로 읽어보길 바란다.
이를 통해 실제 히어로 애니메이션의 기본 구조와 동작 방식을 이해할 수 있다.

## Basic structure of a hero animation

추가 필요