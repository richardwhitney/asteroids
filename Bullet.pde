/*
 * The bullet that the player's ship can shoot
 * Vectors are used for the bullet's position and velocity
 */
 
public class Bullet {
  // the speed at which the bullets move
  private final float speed = 12;
  // Vectors used for movement
  private PVector bulletPos;
  private PVector bulletVel;
  // Maximun time the bullet will last for if it does not hit anything
  private int timeToLive;
  
  /*
   * Constructor for Bullet
   * Bullets are created by Space Ship so we can use the ship's position, angle and velocity to initialise a bullet
   */
  public Bullet(PVector bulletPos, float angle, PVector shipVel, int timeToLive) { //<>//
    this.bulletPos = bulletPos;
    bulletVel = new PVector();
    // Add ship's velociy to the bullets's velocity so the bullet's velocity is relative to the ship's velocity
    bulletVel.x = (float)(speed*Math.cos(angle) + shipVel.x);
    bulletVel.y = (float)(speed*Math.sin(angle) + shipVel.y);
    this.timeToLive = timeToLive;
  }
  
  /*
   * Draw a bullet as a white circle of radius 3
   */
  public void draw() {
    fill(255);
    ellipse(bulletPos.x, bulletPos.y, 6, 6);
  }
  
  /*
   * Called every frame that the bullet exists
   * Add velocity to the bullet's position
   * Wrap the location of the bullet around to the opposite side of the screen if it goes out of bounds
   */
  public void move() {
    // Decrement timeToLive (used to remove bullet if it dosen't hit anything)
    timeToLive--;
    // Update bullet's position
    bulletPos.x += bulletVel.x;
    bulletPos.y += bulletVel.y;
    // Check to see if bullet has gone out of screen bounds and wrap opposite side if true
    if (bulletPos.x < 0) {
      bulletPos.x += width;
    }
    else if (bulletPos.x > width) {
      bulletPos.x -= width;
    }
    if (bulletPos.y < 0) {
      bulletPos.y += width;
    }
    else if (bulletPos.y > 800) {
      bulletPos.y -= width;
    }
  }
  
  public PVector getBulletPos() {
    return bulletPos;
  }
  
  public int getTimeToLive() {
    return timeToLive;
  }
}