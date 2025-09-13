import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

class Spell extends PositionComponent with DragCallbacks, HasGameReference{
  Spell() : super(size: Vector2.all(20.0));

  List<Particle> particles = [];
  List<Particle> shoticles = [];
  Vector2 speed = Vector2.zero();
  Vector2 directionVector = Vector2.zero();

  int particleNumber = 80;

  @override
  FutureOr<void> onLoad() {
    particles = List.generate(particleNumber, (index) => addParticle(index));
    for (var particle in particles) {
      add(particle);
      particle.attach(particles.first);
    }
    removeAll(particles);
    shoticles = List.generate(particleNumber, (index) => addParticle(index));
    for (var shoticle in shoticles) {
      shoticle.isShoticle = true;
    }
    shoticles.first.position = Vector2.zero();
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
    final hasShoticles = children.any((c) => shoticles.contains(c));
    if(hasShoticles) removeAll(shoticles);
    particles.first.position = event.localPosition;
    addAll(particles);
    for (Particle shoticle in shoticles){
      shoticle.setDirection(Vector2.zero(), Vector2.zero());
    }
    super.onDragStart(event);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    particles.first.position = event.localEndPosition;
    directionVector = (event.localEndPosition - event.localStartPosition).normalized();
    super.onDragUpdate(event);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    shotSpell();
    particles.first.position = game.size/2;
    removeAll(particles);
    super.onDragEnd(event);
  }

  void shotSpell(){
    for (Particle shoticle in shoticles){
      final distanceTocenter = Vector2(0, game.size.y / 2) - shoticles.first.position;
      shoticle.setDirection(directionVector, distanceTocenter);
    }
    addAll(shoticles);
  }
}

class Particle extends PositionComponent with SpringJoint, CollisionCallbacks {

  Particle(this.index, this.stableDistance) : super(size: Vector2.all(5.0));

  // Vector2 velocity = Vector2.zero();
  int index;
  Vector2 stableDistance;
  bool isShoticle = false;

  @override
  FutureOr<void> onLoad() {
    position = stableDistance;
    Sparkle sparkle = Sparkle(Colors.yellow);
    add(sparkle);
    add(RectangleHitbox());
    return super.onLoad();
  }

  @override
  void update(double dt) {
    transform.angleDegrees = Random().nextDouble() * 360;
    super.update(dt);
  }

  // @override
  // void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
  //   super.onCollision(intersectionPoints, other);
  //   if (!isShoticle) return;
    
  // }

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
  double stiffness = 400.0;

  /// Współczynnik tłumienia (0 = brak, 1 = mocne tłumienie)
  double damping = 15.0;

  /// Długość spoczynkowa sprężyny
  Vector2? restPosition;
  double? restLength;

  /// Aktualna prędkość (wektor)
  Vector2 velocity = Vector2.zero();

  Vector2 targetDirection = Vector2.zero();

  Vector2 distanceToCenter = Vector2.zero();

  bool shotted = false;

  void attach(PositionComponent other) {
    connectedTo = other;
    restPosition = other.position - position;
    restLength = restPosition!.length;
  }

  void setDirection(Vector2 direction, Vector2 distance){
    targetDirection = direction;
    distanceToCenter = distance;
    shotted = true;
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // Shoticles
    if (connectedTo == null) {
      
      if(shotted){
        position += distanceToCenter;
        shotted = false;
      }

      position += targetDirection * 400 * dt;
      return;
    }

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