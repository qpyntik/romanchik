/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;

import model.Players;

public class Game {
    
    private static final String GAME_NAME = "Crosses & Nulls";
    
    
    private Players[] players;
    
    
        public String getGameName() {  
            return GAME_NAME;
        }  
    
        
        public Players currentPlayer() {        // показывает, чей сейчас ход
            return null;
        }
        
        public boolean move(final int x, final int y) {
            return false;
        }

    public Players[] getPlayers() {
        return players;
    }
}

