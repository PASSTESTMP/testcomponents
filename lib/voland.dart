import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/widgets.dart';

class Voland extends CircleComponent with HasGameReference {
  Voland():super();
  SteerCicle steer = SteerCicle();

  Vector2 speed = Vector2.zero();

  @override
  Future<void> onLoad() {
    paint = Paint()..color=Color.fromARGB(99, 207, 100, 223);

    size = game.size/2;
    steer.size = size/2;
    steer.position = size/4;
    add(steer);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    size = game.size/2;
    steer.size = size/2;

    // steer.position = size/4;

    final steerCenterPosition = size/4;
    final steerOffset = steer.position;
    final offset = steerOffset - steerCenterPosition;
    double maxRadius = size.length/4;

    if (offset.length > maxRadius) {
      final limited = steerCenterPosition + steerOffset.normalized() * maxRadius;

      steer.position = limited;
    }

    speed = offset.normalized();
    

    

    super.update(dt);
  }
}

class SteerCicle extends CircleComponent with DragCallbacks {
  SteerCicle():super();

  @override
  Future<void> onLoad() {
    paint = Paint()..color=Color.fromARGB(100, 143, 14, 162);
    return super.onLoad();
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    Vector2 posChange = event.localEndPosition - size/2;

    position += posChange;
    super.onDragUpdate(event);
  }
  @override
  void onDragEnd(DragEndEvent event) {
    position = size/2;
    super.onDragEnd(event);
  }
}