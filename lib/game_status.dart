import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';

class GameStatus {
  GameStatus():super();

  Map map = Map();


}

class Map extends PositionComponent {
  Map():super();
  late List<MapTile> map;

  @override
  FutureOr<void> onLoad() {
    // 64x64 tile
    map = List.generate(64*64, (index) {
      MapTile tile = MapTile(Random().nextInt(8));
      tile.position = Vector2((index/64).toInt()*128, index%64*127);
      return tile;
    });
    addAll(map);
    return super.onLoad();
  }

  

}

class MapTile extends SpriteComponent {
  MapTile(this.typeColor):super();
  int typeColor;

  @override
  FutureOr<void> onLoad() async {
    String selectedSprite = switch (typeColor) {
      0 => 'water.png',
      1 => 'mud.png',
      2 => 'lava.png',
      3 => 'grass.png',
      4 => 'stone.png',
      // 5 => 'lava.png',
      // 6 => 'lava.png',
      // 7 => 'lava.png',
      _ => 'grass.png',
    };
    sprite = await Sprite.load(selectedSprite);
    size = Vector2(128, 128);
    return super.onLoad();
  }
}