import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

class Spell extends PositionComponent with DragCallbacks {
  Spell() : super(size: Vector2.all(20.0));

  List<Particle> particles = [];
  Vector2 speed = Vector2.zero();

  int particleNumber = 80;

  @override
  FutureOr<void> onLoad() {
    particles = List.generate(particleNumber, (index) => addParticle(index));
    for (var particle in particles) {
      // particle.stiffness = 50 + Random().nextDouble() * 150;
      // particle.damping = 1 + Random().nextDouble() * 5;
      add(particle);
      particle.attach(particles.first);
    }
    removeAll(particles);
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

  @override
  void onDragStart(DragStartEvent event) {
    addAll(particles);
    particles.first.position = event.localPosition;
    super.onDragStart(event);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    particles.first.position = event.localEndPosition;
    super.onDragUpdate(event);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    removeAll(particles);
    super.onDragEnd(event);
  }
}

class Particle extends PositionComponent with SpringJoint {

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

mixin SpringJoint on PositionComponent {
  /// Obiekt do którego jesteśmy połączeni
  PositionComponent? connectedTo;

  /// Stała sprężystości (im większa, tym mocniej ciągnie)
  double stiffness = 200.0;

  /// Współczynnik tłumienia (0 = brak, 1 = mocne tłumienie)
  double damping = 5.0;

  /// Długość spoczynkowa sprężyny
  Vector2? restPosition;
  double? restLength;

  /// Aktualna prędkość (wektor)
  Vector2 velocity = Vector2.zero();

  void attach(PositionComponent other) {
    connectedTo = other;
    restPosition = other.position - position;
    restLength = restPosition!.length;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (connectedTo == null) return;

    final other = connectedTo!;
    final displacement = other.position - position - restPosition!;
    final distance = displacement.length;

    if (distance == 0) return;

    // Kierunek działania sprężyny
    final direction = displacement.normalized();

    // Siła Hooke'a: F = -k * (x - L)
    final stretch = distance - restLength!;
    final force = direction * (stiffness * stretch);

    // Dodaj tłumienie (proporcjonalne do prędkości)
    final dampingForce = velocity * -damping;

    // Suma sił
    final totalForce = force + dampingForce;

    // Zakładamy jednostkową masę, więc a = F
    final acceleration = totalForce;

    // Integracja ruchu (Euler)
    velocity += acceleration * dt;
    position += velocity * dt;
  }
}