/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package view;

import controller.Game;
import java.util.Arrays;


public class ConsoleView {
    
    protected final Game game;
    
    public ConsoleView(final Game game) {
        this.game = game;
    }
    
    // выводим на экран название игры
    public void printGameName() {
        System.out.println(game.getGameName());
    } 
    
    // выводим на экран имена игроков
    public void printPlayersName() {
        System.out.println(Arrays.toString(game.getPlayers()));
    } 
}
