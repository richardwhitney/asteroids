/*
 * Updates game and handles user input
 * Manages game state transitions
 */
 
 import java.util.*;
 import javax.swing.*;
 import ddf.minim.*;
 
 public class GameController {
   
   private GameState gameState;
   private GameView gameView;
   private HighScoreController highScoreController;
   
   // All the 'entities' in the game
   private SpaceShip ship;
   private ArrayList<Bullet> bullets = new ArrayList<Bullet>();
   private ArrayList<Asteroid> asteroids = new ArrayList<Asteroid>();
   
   // Values used to intialise asteroids
   private float astRadius;
   private float minAstVel;
   private float maxAstVel;
   private int astNumHits;
   private int astNumSplit;
   
   private int shipInvincibilityTimer;
   
   // The current level;
   private int level;
   // Player score
   private int score;
   // Player lives
   private int lives;
   
   // Various sounds used 
   private Minim minim;
   private AudioPlayer shootSound;
   private AudioPlayer thrustSound;
   private AudioPlayer bangLargeSound;
   private AudioPlayer bangMediumSound;
   private AudioPlayer bangSmallSound;
   
   
   // Constructor for GameController
   public GameController(GameView gameView, HighScoreController highScoreController, PApplet sketch) {
     this.gameView = gameView;
     this.highScoreController = highScoreController;
     // Increment once first level is set up
     level = 0;
     astRadius = 60;
     minAstVel = 0.5;
     maxAstVel = 5;
     astNumHits = 3;
     astNumSplit = 2;
     lives = 3;
     gameState = GameState.START;
     // Set up the sounds
     minim = new Minim(sketch);
     shootSound = minim.loadFile("fire.wav");
     thrustSound = minim.loadFile("thrust.wav");
     bangLargeSound = minim.loadFile("bangLarge.wav");
     bangMediumSound = minim.loadFile("bangMedium.wav");
     bangSmallSound = minim.loadFile("bangSmall.wav");
   }
   
   /*
    * Show the main menu screen
    * Logic for navigating to main game and high score screens
    */
   public void start() {
     gameView.drawStart();
     if (keyPressed) {
       if (key == 'p' || key == 'P') {
         gameState = GameState.PLAY;
       }
       else if (key == 'h' || key == 'H') {
         gameState = GameState.HIGH_SCORES;
       }
     }
   }
   
   /*
    * Show the high scores screen
    * Logic for navigating back to the main menu screen
    */
   public void showHighScores() {
     gameView.drawHighScores();
     if (keyPressed) {
       if (key == 'r' || key == 'R') {
         gameState = GameState.START;
       }
     }
   }
   
   /*
    * Display an input dialog box when a game is lost
    * Add player name and score to high score list and save to file
    */
   public void gameOver() {
     String name = JOptionPane.showInputDialog("Game Over man!\n\nYour score: " + getScore() + "\n\nPlease enter your name: ");
     // Only add new score to list if player entered a name
     if (name != null && name.length() > 0) {
       highScoreController.addScore(name, getScore());
     }
     resetGame();
   }
   
   /*
    * Reset the game so we can start a new one
    */
   public void resetGame() {
     level = 0;
     setUpLevel();
     gameState = GameState.START;
   }
   
   /*
    * Main update loop for the game
    * 
    */
   public void update() {
     gameView.drawHUD(lives, score, level);
     // If start of the game or all asteroids in the level have been destroyed
     if (asteroids.size() <= 0) {
       // Set up the next level
       setUpLevel();
     }
     // Used to make ship invincible for a short period of time after the ship collides with an asteroid
     if (shipInvincibilityTimer > 0) {
       shipInvincibilityTimer--;
     }
     else {
       ship.setIsInvincible(false);
     }
     ship.draw();
     ship.move();
     // Use an iterator to go through list so that a bullet can be deleted while iterating
     for (Iterator<Bullet> it = bullets.iterator(); it.hasNext(); ) {
       Bullet bullet = it.next();
       bullet.draw();
       bullet.move();
       // Destroy the bullet after a certain period of time
       if (bullet.getTimeToLive() <= 0) {
         it.remove();
       }
     }
     // update asteroids and check for collisions
     updateAsteroids();
     if (ship.getShooting() && ship.canShoot()) {
       Bullet b = ship.shoot();
       shootSound.rewind();
       shootSound.play();
       bullets.add(b);
     }
   }
   
   /*
    * Set up the next level in the game 
    * Create a new ship and asteroids and clear arrays 
    */
   public void setUpLevel() {
     level++;
     ship = new SpaceShip(new PVector(width/2, height/2), 0, .35, .98, .1, 12);
     shipInvincibilityTimer = 0;
     bullets.clear();
     ship.setShooting(false);
     asteroids.clear();
     for (int i = 0; i < level; i++) {
       PVector asteroidPos = new PVector((float)Math.random()*width, 0);
       Asteroid a = new Asteroid(asteroidPos, astRadius, minAstVel, maxAstVel, astNumHits, astNumSplit);
       asteroids.add(a);
     }
   }
   
   /*
    * Update all asteroids and check for collisions with space ship and bullets
    * Create a new local collection of asteroids that will be added to the original collection
    * if a bullet collides with an asteroid and new asteroids have to be created
    */
   private void updateAsteroids() {
     // Local list of new asteroids that may have to added to the game
     ArrayList newAsteroids = new ArrayList<Asteroid>();
     // Use an iterator to iterate throught the asteroids collection so that asteroids can be removed from the collection at the same time
     for (ListIterator<Asteroid> it = asteroids.listIterator(); it.hasNext(); ) {
       // Get the next asteroid in the collection
       Asteroid asteroid = it.next();
       asteroid.draw();
       asteroid.move();
       // Check for collisions with the space ship
       if (checkSpaceShipCollision(asteroid) && !ship.getIsInvincible()) {
         if (lives > 0) {
           lives--;
           shipInvincibilityTimer = 60;
           ship.setIsInvincible(true);
           return;
         }
         // Game over
         else {
           gameOver();
         }
         return;
       }
       // Iterate through the collection of bullets 
       for (Iterator<Bullet> itB = bullets.iterator(); itB.hasNext(); ) {
         // Get the next bullet in the collection
         Bullet bullet = itB.next();
         // Check if a collision between a bullet and an asteroid has occured
         if (checkBulletCollision(bullet, asteroid)) {
           // Remove the bullet that collided with the asteroid from the game
           itB.remove();
           // Play sound based on asteroid size
           switch (asteroid.getHitsLeft()) {
             case 1:
               bangSmallSound.rewind();
               bangSmallSound.play();
               break;
             case 2:
               bangMediumSound.rewind();
               bangMediumSound.play();
               break;
             case 3:
               bangLargeSound.rewind();
               bangLargeSound.play();
               break;
             default:
               break;
           }
           // Split the asteroid up into smaller ones if needed
           if (asteroid.getHitsLeft() > 1) {
             // Create smaller new asteroids based on asteroid's numSplit variable (i.e create two new asteroids)
             for (int i = 0; i < asteroid.getNumSplit(); i ++) {
               Asteroid a = asteroid.splitAsteroid(minAstVel, maxAstVel);
               // Add new asteroid to local ArrayList 
               newAsteroids.add(a);
             }
           }
           // Add to player's score
           addScore(100);
           // Remove the original asteroid
           it.remove();
         }
       }
     }
     // Add the new asteroids to the original asteroid collection
     asteroids.addAll(newAsteroids);
   }
   
   /*
    * Collision detection between space ship and asteroid.
    * The shape of the ship is approximated with a circle to simplify the calculations needed.
    * If the sum of the radii of two circles (asteroid and space ship) is greater than the distance 
    * between the centers of the circles, then a collision has occurred.
    */
   private boolean checkSpaceShipCollision(Asteroid asteroid) {
     // Square both sides of the inequality in order to remove the square root of the distance formula
     if (Math.pow(asteroid.getRadius() + ship.getRadius(), 2) > Math.pow(ship.getPosition().x - asteroid.getPosition().x, 2) + Math.pow(ship.getPosition().y - asteroid.getPosition().y, 2)) {
       return true;
     }
     return false;
   }
   
   /*
    * Collision detection between bullet and asteroid
    * The bullet is treated as a single point with no radius
    * If the radius of the asteroid is greater than the distance between the bullet
    * and the center of the circle, then a collision has occurred
    */
   private boolean checkBulletCollision(Bullet bullet, Asteroid asteroid) {
     // Square both sides of the inequality in order to remove the square root of the distance formula
     if (Math.pow(asteroid.getRadius(), 2) > Math.pow(bullet.getBulletPos().x - asteroid.getPosition().x, 2) + Math.pow(bullet.getBulletPos().y - asteroid.getPosition().y, 2)) {
       return true;
     }
     return false;
   }

   public void keyPressed() {
     if (gameState == gameState.PLAY) {
       if (key == CODED) {
         switch (keyCode) {
           case UP:
             ship.setAccelerating(true);
             if (!thrustSound.isPlaying()) {
               thrustSound.rewind();
               thrustSound.loop();
             }
             break;
           case LEFT:
             ship.setTurningLeft(true);
             break;
           case RIGHT:
             ship.setTurningRight(true);
             break;
           default:
             break;
         }
       }
       if (key == ' ') {
         ship.setShooting(true);
       }
     }
   }
   
   public void keyReleased() {
     if (gameState == gameState.PLAY) {
       if (key == CODED) {
         switch (keyCode) {
           case UP:
             ship.setAccelerating(false);
             if (thrustSound.isPlaying()) {
               thrustSound.pause();
             }
             break;
           case LEFT:
             ship.setTurningLeft(false);
             break;
           case RIGHT:
             ship.setTurningRight(false);
           default:
             break;
         }
       }
       if (key == ' ') {
         ship.setShooting(false);
       }
     }
   }
   
   public int getScore() {
     return score;
   }
   
   public int getLives() {
     return lives;
   }
   
   public GameState getGameState() {
     return gameState;
   }
   
   public void setGameState(GameState gameState) {
     this.gameState = gameState;
   }
   
   public void addScore(int s) {
     score += s;
   }
 }
 
 