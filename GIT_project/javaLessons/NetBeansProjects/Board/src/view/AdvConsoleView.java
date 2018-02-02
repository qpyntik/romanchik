/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package view;

import controller.Game;
//import java.util.Arrays;

/**
 *
 * @author dima
 */
public class AdvConsoleView extends ConsoleView {
    
    public AdvConsoleView(final Game game) {
        super(game);
    }
    
    // выводим на экран название игры
    @Override
    public void printGameName() {
        printLine();
        System.out.println(game.getGameName());
        printLine();
    } 
    
    public void printLine() {
        System.out.println("***");
    }    
    
}
