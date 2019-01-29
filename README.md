# 플러터에서의 애니메이션
> [Flutter Animation Tutorial](https://flutter.io/docs/development/ui/animations/tutorial)

> 본 저장소에서 제공하는 해설은 튜토리얼 사이트의 단순 번역 입니다.
공부할때에는 직접 원문을 참고하시는것을 추천합니다. 번역은 개인 의견이
들어갈 수 있으므로, 원문으로 공부중에 이해하지 못하는 부분을 참고하는 용도로만
사용하시기를 바랍니다. 번역중에서도 예제는 번역하지 않습니다.

플러터에서 화면이나 상태 변화에 따른 애니메이션을 표기 하고 싶을 때에는 `Animation` 클래스에 기반한 코드를 작성하면 된다. 본 저장소는 플러터 공식 홈페이지의 애니메이션 튜토리얼 페이지에 대한 코드 및 설명을 제공한다. 이 튜토리얼에서 배울 수 있는 내용은 아래와 같다.

- 위젯에 애니메이션을 추가하기 위해 애니메이션 라이브러리가 제공하는 기본적인 클래스들을 사용하는 방법
- `AnimatedWidget`과 `AnimatedBuilder`를 상황에 맞게 사용하는 방법

플러터 SDK는 기본적으로 구현된 `FadeTransition`, `SizeTransition`, `SlideTransition`과 같은 transition 애니메이션들을 제공한다. 직접 애니메이션을 구현하기 어려운 경우에는 위와 같은 간단한 애니메이션을 이용하면 된다.

## 애니메이션 필수 개념 및 클래스

애니메이션 관련 클래스들의 중요 사항을 미리 정리하자면 아래와 같다.

- `Animation` 객체는 플러터 애니메이션 라이브러리의 가장 중요한 코어 클래스로 애니메이션을 실행하기 위한 정보들의 값을 관리한다.
- `Animation` 객체는 현재 애니메이션이 started/stopped/forward/reverse 중 어느 상태인지를 알고 있으며, 실제 화면에 보여지는 뷰에 대해서는 정보를 가지고 있지 않다.
- `AnimationController` 클래스가 `Animation`을 관리한다.
- `CurvedAnimation`은 비선형적인 커브형 애니메이션 상태 변화를 정의한다.
- `Tween` 객체는 애니메이션으로 이용되는 객체의 중간값을 보간한다. 예를 들어, 빨강에서 파랑으로, 0에서 255로 등과 같이 특정 범위에 대한 정의를 수행한다.
- `Listener`나 `StatusListener`는 애니메이션 상태의 변화를 모니터링 한다.

플러터의 애니메이션 시스템은 `Animation` 객체에 기반한다. 위젯들은 이러한 애니메이션 객체를 `build` 함수에서 사용하여, 애니메이션 값을 통해 직접 사용할 수 있다. 혹은 다른 위젯으로 전달하는 더욱 다채로운 애니메이션의 기반 값으로 사용할 수 있다.

### Animation\<double\>

앞에서 언급한것처럼 플러터에서 `Animation` 객체는 실제 화면에 보이는 정보는 아무것도 저장하고 있지 않다. `Animation` 객체 자체는 단순히 진행중인 애니메이션의 현재 값과 state(completed 혹은 dismissed) 만을 관리하는 추상적인 클래스이다. 가장 자주 사용되는 애니메이션 타입은 `Animation<double>` 타입이다.

> 이후 부터 한글로 적힌 애니메이션 객체 는 `Animation` 객체를 의미한다. 화면에 보여지는 애니메이션과 애니메이션 객체를 헷갈리지 않도록 주의하자.

애니메이션 객체가 가지고 있는 정보는 시작 값과 끝 값 사이의 특정 지속 기간동한 변화한
값이다. 애니메이션 객체가 제공하는 값은 선형/커브형/스텝별 혹은 개발자가
지정한 방식대로 변화한다. 애니메이션 객체를 조절하는 방법에 따라서,
애니메이션을 역으로 진행할 수도 있고, 중간에 진행 방향을 바꿀 수도 잇다.

`double` 형이 아닌 다양한 다른 타입을 중간값으로 사용할 수 있으며, 대표적으로
`Animation<Color>` 와 `Animation<Size>`가 있다.

애니메이션 객체가 관리하는 상태와 값 정보는 각각 `Animation.status`와
`Animation.value`로 접근할 수 있다.

### CurvedAnimation

커브드 애니메이션은 비선형적인 커브형 애니메이션을 구현할 때 사용한다.
기본 예제는 아래와 같다.

```dart
final CurvedAnimation curve =
    CurvedAnimation(parent: controller, curve: Curves.easeIn);
```

[Curves](https://docs.flutter.io/flutter/animation/Curves-class.html) 클래스는
주로 사용되는 다양한 비선형 증감함수를 제공하고, 이를 이용해서 커스텀 커브를
구현할 수 있다. 예를 들면 아래와 같다.

```dart
class ShakeCurve extends Curve {
    @override
    double transform(double t) {
        return math.sin(t * math.PI * 2);
    }
}
```

CurvedAnimation과 AnimationController는 둘 다 `Animation<double>` 타입이므로
둘을 섞어서 사용할 수 있다. CurvedAnimation은 변경할 뷰 객체를 직접 포함하므로
AnimationController를 추가할 필요없다.

### AnimationController

`AnimationController`는 하드웨어가 새로운 프레임을 렌더링할 준비가 될 때마다,
새로운 값을 생성하는 특수한 `Animation` 객체이다. 기본적으로, 0.0 에서 1.0
까지의 double값을 선형적으로 생성하여 제공한다. 아래의 코드는 선형적 애니메이션
객체를 생성하는 코드이다. 실제로 애니메이션이 실행이 되지는 않는 코드이다.

```dart
final AnimationController controller = AnimationController(
    duration: const Duration(milliseconds: 2000), vsync: this
);
```

AnimationController는 Animation<double>에서 파생된 것이므로, Animation
객체를 필요로 하는 곳에서는 모두 사용할 수 있다. AnimationController는
추가적으로 애니메이션을 조정할 수 있다. 예를 들어, `.forward()` 메소드로
정방향 애니메이션을 실행하거나, `.reverse()` 메소드로 역방향 애니메이션을
실행할 수 있다. 새로운 값의 생성은 화면 새로고침과 같이 동작하므로,
일반적으로 60fps의 화면에서 초당 60번의 새로운 값을 생성한다.
새로운 값이 생성된 이후에는 애니메이션 객체에 등록된 `Listener`들을
호출한다. 서로다른 위젯들에 대해서 서로 다른 새로고침 주기를 제공하고
싶은 경우에는 [RepaintBoundary](https://docs.flutter.io/flutter/widgets/RepaintBoundary-class.html)를 참고하면 된다.

AnimationController를 생성할 때에 `vsync` 파라미터를 사용한다. 해당
파라미터를 사용할 경우 화면 밖에 있는 애니메이션이 불필요한 리소스를
사용하는 것을 방지한다. stateful 위젯들은 `SingleTickerProviderStateMixin`
클래스를 추가하여 vsync를 사용할 수있다. 자세한 내용은 [animate1 예제](https://github.com/flutter/website/tree/master/src/_includes/code/animation/animate1/main.dart)를
참조하면 된다.

종종 애니메이션 AnimationController가 관리하는 0.0 - 1.0의 범위를 초과하는
값을 사용할 수도 있다. 예를 들어 `fling()` 함수의 경우 애니메이션 velocity,
force와 position을 사용할 수 있도록 제공한다. 이 때의 position은 0.0 - 1.0의
범위가 아닌 그 밖의 다른 값을 사용할 수 있다.

CurvedAnimation이 제공하는 값 또한 0.0 - 1.0의 범위를 벗어날 수 있다. 어떤
커브 함수를 선택했느냐에 따라서 값의 범위가 변경될 수 있다.

### Tween

기본적으로 AnimationController는 0.0 부터 1.0까지의 범위를 제공한다.
다른 범위나 다른 타입의 데이터를 사용하길 원하는 경우에는 `Tween`을 사용할 수 있다.
예를 들어 아래의 코드는 -200.0 부터 0.0 까지의 범위를 제공한다.

```dart
final Tween doubleTween = Tween<double>(begin: -200.0, end: 0.0);
```

Tween은 오로지 범위의 시작값과 끝값만을 저장하는 stateless 객체로, 단순히
애니메이션의 인풋/아웃풋 범위를 정하는 용도로 사용된다.

Tween 클래스는 Animation 객체가 아닌 `Animatable` 객체를 상속한다. `Animatable`은
Animation 객체와 유사하지만 제공하는 값이 double 일 필요가 없다. 예를 들어, 아래의
코드 `ColorTween`은 두가지 색의 범위를 제공한다.

```dart
final Tween colorTween =
    ColorTween(begin: Colors.transparent, end: Colors.black54);
```

Tween 객체에서 직접 state를 관리하지 않는 대신 `evalute(Animation<double> animation)`
메소드를 제공하여 현재 애니메이션의 상태값에 대응하는 커스텀 값을 매핑해주는
역할을 한다. 애니메이션의 현재 값은 `Animation.value`를 통해 확인가능하다.
evaluate 메소드는 애니메이션의 값이 0.0일 때는 begin을, 1.0일 때는 end 값을 리턴하는
추가적인 역할도 수행한다.

#### Tween.animate

Tween 객체를 사용하기 위해서는 `animate()` 메소드의 파라미터로
AnimationController 객체를 사용하면 된다. 아래의 예제 코드는 0에서 255까지의
정수 값을 500ms 동안 생성하는 코드이다.

```dart
final AnimationController controller = AnimationController(
    duration: const Duration(milliseconds: 500), vsync: this);

Animation<int> alpha = IntTween(begin: 0, end: 255).animate(controller);
```

위의 코드에서 보다시피 `animate()` 메소드는 Animatable이 아닌 Animation 객체를 반환한다.

아래의 예제는 선형 애니메이션이 아닌 CurvedAnimation을 사용하는 코드이다.

```dart
final AnimationController controller = AnimatinoController(
    duration: const Duration(milliseconds: 500), vsync: this);
final Animation curve =
    CurvedAnimation(parent: controller, curve: Curves.easeout);
Animation<int> alpha = IntTween(begin: 0, end: 255).animate(curve);
```

### Animation notifications

Animation 객체는 `addLIstener()`와 `addStatusListener()`를 통해
Listener와 StatueListener를 등록할 수 있다. 애니메이션의 값이 바뀔 때 마다
Listener를 호출하고, 일반적으로 호출된 Listener는 변경된 값에 맞는 setState()
메소드를 호출한다. StatusListener는 애니메이션의 시작/끝/forward/reverse 상태 변화마다
호출되며 해당 상태는 `AnimationStatus`에 정의되어 있다.

튜토리얼 사이트에서는 이후 실제 예제를 다루고 있습니다. 홈페이지를 확인하기 바랍니다.
