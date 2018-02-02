/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package bicycle;

/**
 *на примере выпуска новых мотоциклов. Как только появляется с конвейера новый 
 *мотоцикл, мы ему присваиваем уникальное idб которое увеличивается на 1
 */
public class Bicycle {
    
    public static void main(String[] args) {
        
        BicycleId b = new BicycleId(3);
        System.out.println(b.getID());
        
        b = new BicycleId(5);
        System.out.println(b.getID());
        
        BicycleId c = new BicycleId(1);
        System.out.println(c.getID());
        
        b = new BicycleId(3);
        System.out.println(b.getID());
        System.out.println(b.getID());
        System.out.println(c.getID());
        
        System.out.println(new BicycleId(33).getID());
   
    }
    
}
