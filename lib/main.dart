import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/flame.dart';
import 'dart:math';

import 'package:test_game/Component/car.dart';

import 'Component/Obstacle.dart';
import 'Component/ObstacleManager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setPortrait();

  runApp(GameWidget(
    game: CarGame(),
    overlayBuilderMap: {
      'RestartButton': (context, CarGame game) => Positioned(
            top: 16,
            right: 16,
            child: Row(
              children: [
                ValueListenableBuilder<bool>(
                  valueListenable: game.isPaused,
                  builder: (context, isPaused, child) {
                    return IconButton(
                      icon: Icon(
                        isPaused ? Icons.play_arrow : Icons.pause,
                        color: Colors.white,
                        size: 36,
                      ),
                      onPressed: game.togglePause,
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.restart_alt, color: Colors.white, size: 36),
                  onPressed: game.resetGame,
                ),
              ],
            ),
          ),
    },
    initialActiveOverlays: const ['RestartButton'],
  ));
}

class CarGame extends FlameGame with HasCollisionDetection, PanDetector {
  late Car car;
  late double screenWidth;
  late double screenHeight;
  final List<Obstacle> obstacles = [];
  ValueNotifier<bool> isPaused = ValueNotifier(false);

  @override
  Future<void> onLoad() async {
    screenWidth = size.x;
    screenHeight = size.y;

    car = Car(screenWidth, screenHeight);
    add(car);

    add(ObstacleManager(screenWidth, screenHeight));
  }

  @override
  void update(double dt) {
    if (isPaused.value) return;

    super.update(dt);

    // Check for collisions between car and obstacles
    for (final obstacle in obstacles) {
      if (car.collidesWith(obstacle)) {
        // End the game or take action on collision
        overlays.add('gameOver');
        pauseEngine();
        break;
      }
    }
  }

  void addObstacle(Obstacle obstacle) {
    obstacles.add(obstacle);
    add(obstacle);
  }

  void removeObstacle(Obstacle obstacle) {
    obstacles.remove(obstacle);
    obstacle.removeFromParent();
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (!isPaused.value) {
      // Update the car's position based on the drag distance
      car.move(info.delta.global.x);
    }
  }

  void resetGame() {
    // Reset game state
    obstacles.clear();
    removeAll(obstacles);
    car.position = Vector2(screenWidth / 2, screenHeight - 150);
    isPaused.value = false;
    overlays.remove('gameOver');
    resumeEngine();
  }

  void togglePause() {
    isPaused.value = !isPaused.value;
    if (isPaused.value) {
      pauseEngine();
    } else {
      resumeEngine();
    }
  }
}




