/*
 * The asteroids that the player must avoid and shot
 * Vectors are used to store the asteroids position and velocity
 * 
 */

public class Asteroid {
  
  private PVector asteroidPos;
  private PVector asteroidVel;
  private float radius;
  private int hitsLeft;
  private int numSplit;
  
  /*
   * Constructor for Asteroid
   * Calculate a random velocity based on maxVelocity and minVelocity
   * Calculate a random angle between 0 and 2PI (0 and 360 degrees)
   */
  public Asteroid(PVector asteroidPos, float radius, float minVelocity, float maxVelocity, int hitsLeft, int numSplit) {
    this.asteroidPos = asteroidPos;
    this.radius = radius;
    // Number of shots it takes to destroy the asteroid
    this.hitsLeft = hitsLeft;
    // Number of smaller asteroids this one will break up to when shot
    this.numSplit = numSplit;
    // Calculate a random velocity and direction 
    float velocity = (float)(minVelocity + Math.random() * (maxVelocity - minVelocity));
    float direction = (float)(2 * Math.PI * Math.random());
    asteroidVel = new PVector(0, 0);
    asteroidVel.x = (float)(velocity * Math.cos(direction));
    asteroidVel.y = (float)(velocity * Math.sin(direction));
  }
  
  /*
   * Draw an asteroid represented as a grey circle
   */
  public void draw() {
    fill(180);
    ellipse(asteroidPos.x, asteroidPos.y, radius*2, radius*2);
  }
  
  /*
   * Moves the asteroid on the screen
   * If the asteroid moves off the edge of the screen
   * it will reappear on the opposite side
   */
  public void move() {
    asteroidPos.x += asteroidVel.x;
    asteroidPos.y += asteroidVel.y;
    if (asteroidPos.x < 0-radius) {
      asteroidPos.x += width + 2*radius;
    }
    else if (asteroidPos.x > width+radius) {
      asteroidPos.x -= width + 2*radius;
    }
    if (asteroidPos.y < 0-radius) {
      asteroidPos.y += height + 2*radius;
    }
    else if (asteroidPos.y > height + radius) {
      asteroidPos.y -= height + 2*radius;
    }
  }
  
  /*
   * Creates a smaller asteroid at the current asteroid's position
   */
  public Asteroid splitAsteroid(float minVelocity, float maxVelocity) {
    PVector p = new PVector(asteroidPos.x, asteroidPos.y);
    return new Asteroid(p, (float)(radius/Math.sqrt(numSplit)), minVelocity, maxVelocity, hitsLeft-1, numSplit);
  }
  
  public PVector getPosition() {
    return asteroidPos;
  }
  
  public int getHitsLeft() {
    return hitsLeft;
  }
  
  public int getNumSplit() {
    return numSplit;
  }
  
  public float getRadius() {
    return radius;
  }
}