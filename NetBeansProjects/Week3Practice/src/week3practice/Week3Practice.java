/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package week3practice;

/**
 *
 * Class Point: метод, который будет выводить на экран точку
 * https://courses.prometheus.org.ua/courses/EPAM/JAVA101/2016_T2/courseware/e3bb4f9536e04bdca6b2d2001b0c3eee/776b307afcf64bd4b26df31d39b7c069/
 */
public class Week3Practice {

    private int x;
    private int y;
    private int color = 10;
    
    
    // перегруженные конструкторы (overloading)
    public Week3Practice(int c){
        color = c;
    }
    
    public Week3Practice(){
    
    }
    
    // перегруженные методы (overloading)
    public void draw(int x, int y){
        //magic!!!
    }
    
    public void drow(){
        //magic!!!
        //color!!!
    }
    
    
    public int getColor(){
        return color;
    }
    /*
    public static void main(String[] args) {
        
    }
    */
}
