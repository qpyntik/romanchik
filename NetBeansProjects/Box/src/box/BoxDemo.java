/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package box;


public class BoxDemo {
    
    public static void main (String[] args){
        Box b1 = new Box(10, 20, 30);
      /*  Box b2 = new Box(40, 50, 60);
        Box b3 = new Box();            
        
        b1.print();
        b2.print();
        b3.print();
        
        b1.change(200, 300, 400);
        
        b1.print();
        */
        long volume = b1.getVolume();
        
        System.out.println(volume);
        
        System.out.println(new Box(1, 5, 8).getVolume());
        
    }
    
}
