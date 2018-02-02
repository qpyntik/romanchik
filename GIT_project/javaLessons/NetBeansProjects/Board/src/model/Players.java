/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package model;


public class Players {
    
    private final String name;
    private final String figure;
    //private final Figure figure;
    
    public Players(final String name, final String figure){
        this.name = name;
        this.figure = figure;
    }
    
    public String getName() {
        return name;
    }
    
    public String getFigure() {
        return figure;
    }
}
