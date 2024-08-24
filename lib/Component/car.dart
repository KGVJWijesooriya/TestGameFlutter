


import 'package:flame/components.dart';
import 'package:test_game/main.dart';

import 'Obstacle.dart';

class Car extends SpriteComponent with HasGameRef<CarGame> {
  final double screenWidth;
  final double screenHeight;

  Car(this.screenWidth, this.screenHeight)
      : super(size: Vector2(100, 150), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('car.png');

    // Change the size of the car, e.g., 80x160
    size = Vector2(80, 160);

    position = Vector2(screenWidth / 2, screenHeight-120);
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  void move(double deltaX) {
    position.x += deltaX;

    // Ensure the car doesn't go off the screen
    if (position.x < size.x / 2) {
      position.x = size.x / 2;
    } else if (position.x > screenWidth - size.x / 2) {
      position.x = screenWidth - size.x / 2;
    }
  }

  bool collidesWith(Obstacle obstacle) {
    return obstacle.toRect().overlaps(toRect());
  }
}