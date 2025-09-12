import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

class Spell extends PositionComponent {
  Spell() : super(size: Vector2.all(20.0));

  List<Particle> particles = [];

  int particleNumber = 20;

  @override
  FutureOr<void> onLoad() {
    particles = List.generate(particleNumber, (index) => addParticle(index));
    addAll(particles);
    return super.onLoad();
  }

  Particle addParticle(int index) {
    if(index == 0) {
      Particle particle = Particle(index, Vector2.zero());
      return particle;
    }
    Particle particle = Particle(index, Vector2.random() * 40 - Vector2.all(20));
    return particle;
  }

}

class Particle extends PositionComponent {

  Particle(this.index, this.stableDistance) : super(size: Vector2.all(5.0));

  Vector2 velocity = Vector2.zero();
  int index;
  Vector2 stableDistance;

  @override
  FutureOr<void> onLoad() {
    position = stableDistance;
    Sparkle sparkle = Sparkle(Colors.yellow);
    add(sparkle);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    transform.angleDegrees = Random().nextDouble() * 360;
    super.update(dt);
  }

}

class Sparkle extends RectangleComponent {
  Sparkle(this.typeColor) : super(size: Vector2.all(5.0));

  final Color typeColor;

  @override
  FutureOr<void> onLoad() {
    paint = Paint()..color = typeColor;
    return super.onLoad();
  }

  @override
  void update(double dt) {
    paint.brighten(Random().nextDouble());
    paint.darken(Random().nextDouble());
    super.update(dt);
  }

}