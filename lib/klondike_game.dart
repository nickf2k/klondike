import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:klondike/components/foundation.dart';
import 'package:klondike/components/pile.dart';
import 'package:klondike/components/stock.dart';
import 'package:klondike/components/waste.dart';

import 'components/card.dart';

class KlondikeGame extends FlameGame {
  static const double cardWidth = 1000.0;
  static const double cardHeight = 1400.0;
  static const double cardGap = 175.0;
  static const double cardRadius = 100.0;
  static final Vector2 cardSize = Vector2(cardWidth, cardHeight);
  @override
  FutureOr<void> onLoad() async {
    await Flame.images.load('klondike-sprites.png');
    final stock = Stock()
      ..size = cardSize
      ..position = Vector2(cardGap, cardGap);
    final waste = Waste()
      ..size = cardSize
      ..position = Vector2(cardGap * 2 + cardWidth, cardGap);
    final foundations = List.generate(
        4,
        (index) => Foundation()
          ..size = cardSize
          ..position =
              Vector2((cardGap + cardWidth) * (index + 3) + cardGap, cardGap));

    final piles = List.generate(
        7,
        (index) => Pile()
          ..size = cardSize
          ..position = Vector2(cardGap + index * (cardGap + cardWidth),
              cardGap * 2 + cardHeight));
    world.add(stock);
    world.add(waste);
    world.addAll(foundations);
    world.addAll(piles);

    camera.viewfinder.visibleGameSize =
        Vector2(cardWidth * 7 + cardGap * 8, 4 * cardHeight + 3 * cardGap);
    camera.viewfinder.position = Vector2(cardWidth * 3.5 + cardGap * 4, 0);
    camera.viewfinder.anchor = Anchor.topCenter;

    final random = Random();
    for (var i = 0; i < 7; i++) {
      for (var j = 0; j < 4; j++) {
        final card = Card(random.nextInt(13) + 1, random.nextInt(4))
          ..position = Vector2(100 + i * 1150, 100 + j * 1500)
          ..addToParent(world);
        if (random.nextDouble() < 0.9) {
          // flip face up with 90% probability
          card.flip();
        }
      }
    }
  }
}

Sprite klondikeSprite(double x, double y, double width, double height) {
  return Sprite(
    Flame.images.fromCache('klondike-sprites.png'),
    srcPosition: Vector2(x, y),
    srcSize: Vector2(width, height),
  );
}
