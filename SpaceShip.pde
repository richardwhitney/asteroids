/* 
 * The space ship that the player controls
 */

public class SpaceShip {
  // create the shape of the space ship and its thruster
  private final float[] origXPts = {14, -10, -6, -10};
  private final float[] origYPts = {0, -8, 0, 8};
  private final float[] origThrusterXPts = {-6, -23, -6};
  private final float[] origThrusterYPts = {-3, 0, 3};
  
  // radius of circle used to approximate the ship during collision detection
  private final int radius = 6;
  
  // Vectors for ship's position and velocity
  private PVector shipPos;
  private PVector shipVel;
  private float angle;
  // Ship's acceleration
  private float acceleration;
  // Rate at which ships veloctiy slows to 0 when acceleration is not being applied
  private float velocityDecay;
  // Turning rate of ship
  private float rotationalSpeed;
  
  // Boolean variables used in ship's movement and shooting
  private boolean turningLeft;
  private boolean turningRight;
  private boolean accelerating;
  private boolean shooting;
  
  // Variables to store the currents locations of the points used to draw the ship and its thruster
  private float[] xPts;
  private float[] yPts;
  private float[] thrusterXPts;
  private float[] thrusterYPts;
  
  // Used to determine the rate of firing
  private int shotDelay;
  private int shotDelayLeft;
  
  // Used to make the player invincible for a short period of time after colliding with an asteroid
  private boolean isInvincible;
  
  /*
   * Constructor for SpaceShip
   */
  public SpaceShip(PVector shipPos, float angle, float acceleration, float velocityDecay, float rotationalSpeed, int shotDelay) {
    this.shipPos = shipPos;
    this.angle = angle;
    this.acceleration = acceleration;
    this.velocityDecay = velocityDecay;
    this.rotationalSpeed = rotationalSpeed;
    // Ship starts not moving
    shipVel = new PVector(0, 0);
    turningLeft = false;
    turningRight = false;
    accelerating = false;
    isInvincible = false;
    // allocate arrays
    xPts = new float[4];
    yPts = new float[4];
    thrusterXPts = new float[3];
    thrusterYPts = new float[3];
    // Ship starts ready to shoot
    this.shotDelay = shotDelay;
    shotDelayLeft = 0;
  }
  
  /*
   * Draw the space ship to the screen
   * First origin points for ship and thruster are rotated by the current angle the ship is facing
   * Then origin points for ship and thruster are moved to the current location of the ship by adding its positional vector
   */
  public void draw() {
    // draw thruster if accelerating
    if (accelerating) {
      for (int i = 0; i < 3; i++) {
        // Rotate thruster points around origin by current ship angle and add ship position
        thrusterXPts[i] = (float)(origThrusterXPts[i]*Math.cos(angle) - origThrusterYPts[i]*Math.sin(angle) + shipPos.x);
        thrusterYPts[i] = (float)(origThrusterXPts[i]*Math.sin(angle) + origThrusterYPts[i]*Math.cos(angle) + shipPos.y);
      }
      fill(255, 0, 0);
      // Draw thruster
      beginShape();
      vertex(thrusterXPts[0], thrusterYPts[0]);
      vertex(thrusterXPts[1], thrusterYPts[1]);
      vertex(thrusterXPts[2], thrusterYPts[2]);
      endShape(CLOSE);
    }
    for (int i = 0; i < 4; i++) {
      // Rotate ship points around origina by current ship angle and add ship position
      xPts[i] = (float)(origXPts[i]*Math.cos(angle) - origYPts[i]*Math.sin(angle) + shipPos.x);
      yPts[i] = (float)(origXPts[i]*Math.sin(angle) + origYPts[i]*Math.cos(angle) + shipPos.y);
    }
    // Make the ship flicker when hit by an asteroid
    if (isInvincible) {
      if (frameCount % 5 == 0) {
        fill(0);
      }
      else {
        fill(156);
      }
    }
    else {
      fill(255);
    }
    // Draw ship
    beginShape();
    vertex(xPts[0], yPts[0]);
    vertex(xPts[1], yPts[1]);
    vertex(xPts[2], yPts[2]);
    vertex(xPts[3], yPts[3]);
    endShape(CLOSE);
  }
  
  /*
   * Called every frame so shotDelayLeft variable can be decremented here (must be 0 in order to shoot)
   * Moves ship by adding acceleration to ship's velocity if ship is accelerating
   * Update ship's position by adding ship's velocity
   * Slows the ship to a stop over time
   * Wrap the location of the ship around to the opposite side of the screen if it goes out of bounds
   */
  public void move() {
    if (shotDelayLeft > 0) {
      shotDelayLeft--;
    }
    if (turningLeft) {
      angle -= rotationalSpeed;
    }
    if (turningRight) {
      angle += rotationalSpeed;
    }
    // Keep the ship's angle within bounds of 0 to 2*PI
    if (angle > (2*Math.PI)) {
      angle -= (2*Math.PI);
    }
    else if (angle < 0) {
      angle += (2*Math.PI);
    }
    if (accelerating) {
      // Calculate components of acceleration and add them to velocity
      shipVel.x += acceleration*Math.cos(angle);
      shipVel.y += acceleration*Math.sin(angle);
    }
    // Move ship by adding velocity to positon
    shipPos.x += shipVel.x;
    shipPos.y += shipVel.y;
    // Slow the ship down by percentage (Should be between 0 and 1)
    shipVel.x *= velocityDecay;
    shipVel.y *= velocityDecay;
    // Check to see if ship has gone out of screen bounds and wrap opposite side if true
    if (shipPos.x < 0) {
      shipPos.x += width;
    }
    else if (shipPos.x > width) {
      shipPos.x -= width;
    }
    if (shipPos.y < 0) {
      shipPos.y += height;
    }
    else if (shipPos.y > height) {
      shipPos.y -= height;
    }
  }
  
  /*
   * Check to see if the ship is ready to shoot again
   * shotDelayLeft must be 0 in order to return true
   */
  public boolean canShoot() {
    if (shotDelayLeft > 0) {
      return false;
    }
    else {
      return true;
    }
  }
  
  /*
   * Create a new bullet using the ship's postion, angle and velocity
   * These parameters are used to calculate the bullet's position and velocity
   */
  public Bullet shoot() {
    // Reset delay untill next shot can be fired
    shotDelayLeft = shotDelay;
    // Create copies of ship's position and velocity instead of directly passing them as parameters in Bullet's constructor
    // Otherwise ship's position and velocity will be modified by the bullet
    PVector p = new PVector(shipPos.x, shipPos.y);
    PVector v = new PVector(shipVel.x, shipVel.y);
    return new Bullet(p, angle, v, 60);
  }
  
  public PVector getPosition() {
    return shipPos;
  }
  
  public float getRadius() {
    return radius;
  }
  
  public boolean getShooting() {
    return shooting;
  }
  
  public boolean getIsInvincible() {
    return isInvincible;
  }
  
  public void setAccelerating(boolean accelerating) {
    this.accelerating = accelerating;
  }
  
  public void setTurningLeft(boolean turningLeft) {
    this.turningLeft = turningLeft;
  }
  
  public void setTurningRight(boolean turningRight) {
    this.turningRight = turningRight;
  }
  
  public void setShooting(boolean shooting) {
    this.shooting = shooting;
  }
  
  public void setIsInvincible(boolean isInvincible) {
    this.isInvincible = isInvincible;
  }
  
}