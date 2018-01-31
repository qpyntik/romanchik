/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package box;

/**
 *
 * @author dima
 */
public class Box {

    private int x;
    private int y;
    private int z;
    
    public Box() {
        
    }
    
    public Box(int x, int y, int z){
        this.x = x;
        this.y = y;
        this.z = z;
    }
    
    public void print(){
        System.out.println("x:"+x + " " + "y:"+y + " " + "z:"+z);
    }
    
    // меняем размеры коробки
    public void change(int x, int y, int z){
        this.x = x;
        this.y = y;
        this.z = z;
    }

    // Метод выводит объем коробки
    public long getVolume() {
        return x*y*z;
    }
    
}
