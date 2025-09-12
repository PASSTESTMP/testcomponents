import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:testcomponents/spell.dart';

void main() {
  runApp(
    GameWidget(
      game: MyEmptyGame(),
    ),
  );
}

class MyEmptyGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    Spell spell = Spell();
    spell.position = size / 4;
    world.add(spell);
    return super.onLoad();
  }

  Vector2 speed = Vector2(0, 100);

  @override
  void update(double dt) {
    Spell targetSpell = world.children.query<Spell>().first;
    
    if(targetSpell.position.y > 100){
      speed = Vector2(0, -100);
    }
    if(targetSpell.position.y < -100){
      speed = Vector2(0, 100);
    }
    targetSpell.position += speed * dt;
    super.update(dt);
  }
}