


import 'dart:math';

import 'package:flame/components.dart';
import 'package:test_game/Component/Obstacle.dart';

import '../main.dart';

class ObstacleManager extends Component with HasGameRef<CarGame> {
  final double screenWidth;
  final double screenHeight;
  final Random random = Random();
  final double spawnInterval = 1.5;
  double timeSinceLastSpawn = 0;

  ObstacleManager(this.screenWidth, this.screenHeight);

  @override
  void update(double dt) {
    super.update(dt);

    timeSinceLastSpawn += dt;
    if (timeSinceLastSpawn >= spawnInterval) {
      final obstacle = Obstacle(screenWidth, screenHeight);
      gameRef.addObstacle(obstacle);
      timeSinceLastSpawn = 0;
    }
  }
}