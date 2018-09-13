/*
 * Manages the list of high scores
 * Adds new scores to list
 * Sorts the list from highest score to lowest
 * Reads and writes the high score to a file called highscores.txt
 */
 
import java.util.*;
import java.io.*;

public class HighScoreController {
  
  // Collection of player scores
  private ArrayList<PlayerScore> playerScores;
  
  // Name of file where high scores are stored
  private static final String HIGHSCORE_FILE = "highscores.txt";
  
  // Input and Output streams for reading/writing to file
  private ObjectOutputStream outStream = null;
  private ObjectInputStream inStream = null;
  
  public HighScoreController() {
    playerScores = new ArrayList<PlayerScore>();
  }
  
  /*
   * Use the custom comparator to sort arrayList based on highest scores of players
   */
  private void sortPlayerScores() {
    PlayerScoreComparator c = new PlayerScoreComparator();
    Collections.sort(playerScores, c);
  }
  
  /*
   * Add score to file
   * Load scores in file to list
   * New score is added to list and the file is updated
   */
  public void addScore(String name, int score) {
    readPlayerScoreFile();
    playerScores.add(new PlayerScore(name, score));
    writePlayerScoreFile();
  }
  
  /*
   * Read the playerScores list from the high score file 
   */
  public void readPlayerScoreFile() {
    try {
      inStream = new ObjectInputStream(new FileInputStream(HIGHSCORE_FILE));
      playerScores = (ArrayList<PlayerScore>) inStream.readObject();
    } 
    // Catch various exceptions that could be thrown
    catch (FileNotFoundException e) {
      println("Error File not found: " + e.getMessage());
      //println(e.getStackTrace());
    } 
    catch (IOException e) {
      println("Error IO Read: " + e.getMessage());
    } 
    catch (ClassNotFoundException e) {
      println("Error Class not found: " + e.getMessage());
    } 
    finally {
      // Close the stream when finished
      try {
        if (outStream != null) {
          outStream.flush();
          outStream.close();
        }
      } 
      catch (IOException e) {
        println("Error IO Read2: " + e.getMessage());
      }
    }
  }
  
  /*
   * Write the playerScores list to the high score file
   */
  public void writePlayerScoreFile() {
    try {
      outStream = new ObjectOutputStream(new FileOutputStream(HIGHSCORE_FILE));
      outStream.writeObject(playerScores);
    }
    // Catch various exceptions that could be thrown
    catch (FileNotFoundException e) {
      println("Error File not found: " + e.getMessage());
    }
    catch (IOException e) {
      println("Error IO Write: " + e.getMessage());
    }
    finally {
      // Close the stream when finished
      try {
        if (outStream != null) {
          outStream.flush();
          outStream.close();
        }
      }
      catch (IOException e) {
        println("Error IO: " + e.getMessage());
      }
    }
  }
  
  /*
   * Create a string of all the scores in the list
   * Used to display the high scores list to the screen
   */
  public String getHighScoreString() {
    String highScoreString = "";
    // Only show the top ten high scores
    int max = 10;
    playerScores = getPlayerScores();
    if (playerScores.size() < max) {
      max = playerScores.size();
    }
    for (int i = 0; i < max; i++) {
      highScoreString += i+1 + ". " + playerScores.get(i).toString() + "\n";
    }
    return highScoreString;
  }
  
  /*
   * Read list of high scores from file
   * Sort it from highest to lowest and return sorted list
   */
  public ArrayList<PlayerScore> getPlayerScores() {
    readPlayerScoreFile();
    sortPlayerScores();
    return playerScores;
  }
  
}