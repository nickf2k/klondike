import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/painting.dart';
import 'package:klondike/components/foundation.dart';
import 'package:klondike/components/tableau.dart';
import 'package:klondike/components/stock.dart';
import 'package:klondike/components/waste.dart';

import 'components/card.dart';

class KlondikeGame extends FlameGame {
  static const double cardWidth = 1000.0;
  static const double cardHeight = 1400.0;
  static const double cardGap = 175.0;
  static const double cardRadius = 100.0;
  static final cardRRect = RRect.fromRectAndRadius(
    const Rect.fromLTWH(0, 0, cardWidth, cardHeight),
    const Radius.circular(cardRadius),
  );
  static final Vector2 cardSize = Vector2(cardWidth, cardHeight);
  @override
  FutureOr<void> onLoad() async {
    await Flame.images.load('klondike-sprites.png');
    final stock = StockPile()
      ..size = cardSize
      ..position = Vector2(cardGap, cardGap);
    final waste = WastePile()
      ..size = cardSize
      ..position = Vector2(cardGap * 2 + cardWidth, cardGap);
    final foundations = List.generate(
        4,
        (index) => FoundationPile(index)
          ..size = cardSize
          ..position =
              Vector2((cardGap + cardWidth) * (index + 3) + cardGap, cardGap));

    final piles = List.generate(
        7,
        (index) => TableauPile()
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
    final cards = [
      for (var rank = 1; rank <= 13; rank++)
        for (var suit = 0; suit < 4; suit++) Card(rank, suit)
    ];
    cards.shuffle();
    world.addAll(cards);
    int cardToDeal = cards.length - 1;
    for (var i = 0; i < 7; i++) {
      for (var j = i; j < 7; j++) {
        piles[j].acquireCard(cards[cardToDeal--]);
      }
      piles[i].flipTopCard();
    }
    for (int n = 0; n <= cardToDeal; n++) {
      stock.acquireCard(cards[n]);
    }

    // cards.forEach(stock.acquireCard);
  }
}

Sprite klondikeSprite(double x, double y, double width, double height) {
  return Sprite(
    Flame.images.fromCache('klondike-sprites.png'),
    srcPosition: Vector2(x, y),
    srcSize: Vector2(width, height),
  );
}
