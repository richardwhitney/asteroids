/*
 * Responsible for draw the different game views to the screen
 * i.e. Start screen, highscore screen, game over screen
 */

public class GameView {
  
  private HighScoreController highScoreController;
  
  private PFont font;
  
  /*
   * Constructor for GameView
   */
  public GameView(HighScoreController highScoreController) {
    this.highScoreController = highScoreController;
    font = createFont("Arial", 16, true);
  }
  
  /*
   * Draws the main menu screen
   */
  public void drawStart() {
    textAlign(CENTER);
    background(0);
    fill(255);
    textFont(font, 32);
    text("ASTEROIDS", width/2, 60);
    
    textFont(font, 12);
    text("Press p to play", width/2, 700);
    text("Press h to view high scores", width/2, 720);
    text("UP, LEFT, RIGHT on keyboard move the ship, SPACEBAR to shoot", width/2, 740);
  }
  
  /*
   * Draws the high scores screen
   */
  public void drawHighScores() {
    textAlign(CENTER);
    background(0);
    fill(255);
    textFont(font, 16);
    text("HIGH SCORES", width/2, 20);
    textFont(font, 12);
    text(highScoreController.getHighScoreString(), width/2, 40);
    text("Press r to return to main menu", width/2, 700);
  }
  
  /*
   * Draws HUD for the main game screen
   */
  public void drawHUD(int lives, int score, int level) {
    textAlign(LEFT);
    fill(255);
    textFont(font, 16);
    text("Lives: " + lives, 10, 20);
    text("Score: " + score, 10, 40);
    text("Level: " + level, 10, 60);
  }
}