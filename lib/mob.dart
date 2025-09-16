import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:testcomponents/spell.dart';

class Mob extends PositionComponent with CollisionCallbacks{
  Mob():super();

  MobSprite mobSprite = MobSprite();

  DieAnimation dieAnimation = DieAnimation();

  RectangleHitbox hb = RectangleHitbox();

  @override
  FutureOr<void> onLoad() {
    size = Vector2(64, 64);
    anchor = Anchor.center;
    mobSprite.position = size/2;
    add(hb);
    add(mobSprite);
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // TODO: implement onCollision
    super.onCollision(intersectionPoints, other);
    if (other is Particle) {
      if(other.isShoticle){
        dieAction();
      }
    }
  }

  void dieAction(){
    removeFromParent();
    // TODO: ogarnij animację śmierci!
    add(dieAnimation);
  }
}

class MobSprite extends SpriteAnimationComponent with HasGameReference {
  MobSprite():super();

  @override
  Future<void> onLoad() async {
    // Load a sprite sheet image
    final spriteSheet = await game.images.load('mob.png');
    // Define the size of each frame in the sprite sheet
    final spriteSize = Vector2(128, 128);
    // Create the animation from the sprite sheet
    animation = SpriteAnimation.fromFrameData(
      spriteSheet,
      SpriteAnimationData.sequenced(
        amount: 2, // number of frames
        stepTime: 0.15, // time per frame
        textureSize: spriteSize,
      ),
    );
    size = spriteSize;
    anchor = Anchor.center;
    await super.onLoad();
  }
}

class DieAnimation extends SpriteAnimationComponent with HasGameReference {
  DieAnimation():super();

  @override
  Future<void> onLoad() async {
    // Load a sprite sheet image
    final spriteSheet = await game.images.load('mob_die.png');
    // Define the size of each frame in the sprite sheet
    final spriteSize = Vector2(128, 128);
    // Create the animation from the sprite sheet
    animation = SpriteAnimation.fromFrameData(
      spriteSheet,
      SpriteAnimationData.sequenced(
        amount: 2, // number of frames
        stepTime: 0.15, // time per frame
        textureSize: spriteSize,
      ),
    );
    size = spriteSize;
    anchor = Anchor.center;
    await super.onLoad();
  }
}