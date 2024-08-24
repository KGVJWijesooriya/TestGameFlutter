

import 'dart:math';

import 'package:flame/components.dart';
import 'package:test_game/main.dart';

class Obstacle extends SpriteComponent with HasGameRef<CarGame> {
  final double screenWidth;
  final double screenHeight;
  final double speed = 200;

  Obstacle(this.screenWidth, this.screenHeight)
      : super(size: Vector2(80, 80), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('obstacle.png');
    position = Vector2(
      Random().nextDouble() * screenWidth,
      -size.y, // Start above the screen
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += speed * dt;

    if (position.y > screenHeight) {
      // Remove obstacle when it goes off-screen
      gameRef.removeObstacle(this);
    }
  }
}