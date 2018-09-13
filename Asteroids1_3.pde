/*
 * Name: Richard Whitney
 * Student Number: 20040645
 */

private GameView gameView;
private HighScoreController highScoreController;
private GameController gameController;

void setup() {
  size(800, 800);
  background(0);
  frameRate(60);
  highScoreController = new HighScoreController();
  gameView = new GameView(highScoreController);
  gameController = new GameController(gameView, highScoreController, this);
}

/*
 * Main loop for game
 * Different actions taken depending on current game state
 */
void draw() {
  switch (gameController.getGameState()) {
    case START:
      gameController.start();
      break;
    case PLAY:
      background(0);
      gameController.update();
      break;
    case GAME_OVER:
      gameController.gameOver();
      break;
    case HIGH_SCORES:
      gameController.showHighScores();
      break;
  }
}

void keyPressed() {
  gameController.keyPressed();
}

void keyReleased() {
  gameController.keyReleased();
}