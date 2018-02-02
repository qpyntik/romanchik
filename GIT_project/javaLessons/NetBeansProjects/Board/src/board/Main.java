/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package board;


//import model.Board;
import controller.Game;
import view.AdvConsoleView;
import view.ConsoleView;


public class Main {
    
    public static void main(String... args) {
        
      Game game = new Game();
        
      final AdvConsoleView advConsoleView = new AdvConsoleView(game);
      final ConsoleView consoleView = new ConsoleView(game);
      
      startGame(advConsoleView);
      }
    
      // метод, который будет запускать UI(view) - что в нем передадим (advConsoleView или consoleView), то и запустит
      public static void startGame(final ConsoleView advConsoleView) {
          advConsoleView.printGameName();
      }
        
}
        
//        final Game game = new Game();      
//        final Board board = new Board();
        /*
        game.printGameName();
        
        final TwoPlayersGame twoPlayersGame = new TwoPlayersGame("Dima", "Andy");
        twoPlayersGame.printPlayer1Name();
        twoPlayersGame.printPlayer2Name();
        twoPlayersGame.printGameName();
        */
        /*
        ThreePlayersGame threePlayersGame = new ThreePlayersGame("Dima", "Andy", "Mike");
        threePlayersGame.printPlayer1Name();
        threePlayersGame.printPlayer2Name();
        threePlayersGame.printPlayer3Name();
        threePlayersGame.printGameName();
       */
   //     printGameNameAndBoard(game, board);
        
    
//        private static void printGameNameAndBoard(final Game game, final Board board) {
//          //  game.printGameName();
//          //  System.out.println("==================");
//            board.printBoard();
//        } 
        
    
