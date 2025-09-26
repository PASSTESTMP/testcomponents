import 'dart:async';

import 'package:flame/components.dart';

class MagPlayer extends PositionComponent with HasGameReference {
  MagPlayer():super();
  MagSprite magSprite = MagSprite();

  double lookAngleOffset = 45;
  double lookAngle = 0;

  int actualMagTileType = 0;

  @override
  FutureOr<void> onLoad() {
    add(magSprite);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    angle = radians(lookAngle - lookAngleOffset);
    magSprite.actualMagTileType = actualMagTileType;
    super.update(dt);
  }

}


class MagSprite extends SpriteAnimationComponent with HasGameReference {
  MagSprite():super();
  
  int actualMagTileType = 0;

  final floorResponse = FloorResponse();

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

  @override
  void update(double dt) {
    if(floorResponse.actualMagTileType != actualMagTileType){
      floorResponse.actualMagTileType = actualMagTileType;
      children.query<FloorResponse>().firstOrNull?.removeFromParent();
      add(floorResponse);
    }
    super.update(dt);
  }

}


class FloorResponse extends SpriteAnimationComponent with HasGameReference {
  FloorResponse():super();

  int actualMagTileType = 0;

  @override
  Future<void> onLoad() async {
    // Load a sprite sheet image
    final spriteName = switch (actualMagTileType) {
      _ => 'splash.png'
    };

    final spriteSheet = await game.images.load(spriteName);
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
    position = Vector2(64, 64);
    anchor = Anchor.center;
    await super.onLoad();
  }

}