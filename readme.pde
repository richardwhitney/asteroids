/*
 * Name: Richard Whitney
 * Student Number: 20040645
 *
 * Description: A simple version of the old arcade game 'Asteroids'. The player controls a space ship on the screen and must avoid and shoot 
 *              asteroids that move around the screen. The player recieves a score when an asteroid is destroyed.
 *              When all asteroids in a level are destroyed a new level is begun with more asteroids to increase 
 *              difficulty. If an asteroid hits the player's ship the player loses a life. The game ends when the player has no more lives left.
 *              A list of high scores can be displayed and the list is saved to a file called 'highscores.txt' so that they are persistant
 *
 * Justification of spec: Multiple user-defined classes - e.g. 'SpaceShip', 'Asteroid', 'Bullet'
 *                        All user-defined classes adhere to encapsulation rules (fields are private and are accessed by other classes using appropriate methods)
 *                        Constructors are present in most user-defined classes - e.g. 'SpaceShip', 'Asteroid', 'Bullet'
 *                        Most user-defined classes have getters and setters where needed - e.g. 'SpaceShip', 'Asteroid', 'Bullet'
 *                        Other bespoke methods are used throughout the assingment - e.g. GameController's 'updateAsteroids' method
 *                        'Asteriods1_3' is the usual Processing class containing setup(), draw() etc.
 *                        User of selection (if) and iteration(loops) used throughout the assingment - e.g. GameController's 'update' method
 *                        ArrayLists are used to store collections of asteroids and bullets in the gameController class
 *                        Calculations are performed on these arrayLists e.g. check for collisions between bullets and asteroids in GameController's 'updateAsteroids' method
 *                        
 * Known bugs/problems: I used a third part library for game's sound effects called Minim. This library must be installed in order for the code to run.
 *                      You can do this by going to Processing's menu, clicking the sketch tab, then clicking import libraries and finally clicking add libraries
 *                      Enter minim into the search bar that pops up and click install. I've also included the Minim library files with this submission so you can 
 *                      manually add them to your Processing libraries folder if you like.
 *                      I've included a Window's executable of the assignment that will also run without the Minim library installed.
 */