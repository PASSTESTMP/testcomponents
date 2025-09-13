import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testcomponents/mag_player.dart';
import 'package:testcomponents/mob.dart';
import 'package:testcomponents/spell.dart';

void main() {
  runApp(
    GameWidget(
      game: MyEmptyGame(),
    ),
  );
}

class MyEmptyGame extends FlameGame with HasKeyboardHandlerComponents, HasCollisionDetection {
  @override
  Future<void> onLoad() async {
    Spell spell = Spell();
    spell.size.x = size.x/2;
    spell.size.y = size.y;
    spell.position = size / 4;
    world.add(spell);

    debugMode = false;

    MagPlayer mag = MagPlayer();
    world.add(mag);

    Mob mob = Mob();
    mob.position = Vector2(0, 200);
    world.add(mob);

    return super.onLoad();
  }

  Vector2 speed = Vector2(0, 0);

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if(event is KeyDownEvent){
      if(event.logicalKey == LogicalKeyboardKey.arrowUp){
        speed = Vector2(0, -100);
      }
      if(event.logicalKey == LogicalKeyboardKey.arrowDown){
        speed = Vector2(0, 100);
      }
    }

    if(event is KeyUpEvent){
      speed = Vector2(0, 0);
    }
    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void update(double dt) {
    Spell targetSpell = world.children.query<Spell>().first;
    MagPlayer magPlayer = world.children.query<MagPlayer>().first;

    targetSpell.size.x = size.x/2;
    targetSpell.size.y = size.y;

    targetSpell.position.x = 0;
    targetSpell.position.y = -size.y/2;

    magPlayer.position = Vector2.zero();

    super.update(dt);
  }
}