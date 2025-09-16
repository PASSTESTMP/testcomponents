import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

class MagPlayer extends PositionComponent with HasGameReference {
  MagPlayer():super();
  MagSprite magSprite = MagSprite();

  double lookAngleOffset = 45;
  double lookAngle = 0;

  @override
  FutureOr<void> onLoad() {
    add(magSprite);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    angle = radians(lookAngle - lookAngleOffset);
    super.update(dt);
  }

}


class MagSprite extends SpriteAnimationComponent with HasGameReference {
  MagSprite():super();

  @override
  Future<void> onLoad() async {
    // Load a sprite sheet image
    final spriteSheet = await game.images.load('mag.png');
    // Define the size of each frame in the sprite sheet
    final spriteSize = Vector2(128, 128);
    // Create the animation from the sprite sheet
    animation = SpriteAnimation.fromFrameData(
      spriteSheet,
      SpriteAnimationData.sequenced(
        amount: 7, // number of frames
        stepTime: 0.15, // time per frame
        textureSize: spriteSize,
      ),
    );
    size = spriteSize;
    anchor = Anchor.center;
    await super.onLoad();
  }

}

