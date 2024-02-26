import 'package:flame/components.dart';
import 'package:flutter/rendering.dart';

import '../klondike_game.dart';
import '../rank.dart';
import '../suit.dart';

class Card extends PositionComponent {
  Card(int intRank, int intSuit)
      : rank = Rank.fromInt(intRank),
        suit = Suit.fromInt(intSuit),
        _faceUp = false,
        super(size: KlondikeGame.cardSize);

  final Rank rank;
  final Suit suit;
  bool _faceUp;
  bool get isFaceUp => _faceUp;
  bool get isFaceDown => !_faceUp;
  void flip() => _faceUp = !_faceUp;
  @override
  String toString() => rank.label + suit.label; // e.g. "Q♠" or "10♦"

  @override
  void render(Canvas canvas) {
    if (_faceUp) {
      _renderFront(canvas);
    } else {
      _renderBack(canvas);
    }
  }

  void _renderFront(Canvas canvas) {}
  void _renderBack(Canvas canvas) {}
}
