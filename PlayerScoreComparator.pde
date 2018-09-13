/*
 * Helper class that defines how we compare two PlayerScore objects
 */
 
import java.util.Comparator;

public class PlayerScoreComparator implements Comparator<PlayerScore> {
  
  public int compare(PlayerScore playerScore1, PlayerScore playerScore2) {
    int ps1 = playerScore1.getScore();
    int ps2 = playerScore2.getScore();
    
    if (ps1 > ps2) {
      return -1;
    }
    else if (ps1 < ps2) {
      return 1;
    }
    else {
      return 0;
    }
  }
}