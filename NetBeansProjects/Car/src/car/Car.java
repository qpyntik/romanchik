/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

// работаем с двумя файлами .java. Вызываем один метод из другого
package car;
/*
public class Car {

        int maxSpeed;
    
      public void start() {
          
          System.out.println("Engine started!");
          
          System.out.println("Max speed is " + maxSpeed);
        
      }  
        
}
*/


// вызываем метод с КОНКРЕТНЫМИ аргументами

public class Car {

        int maxSpeed;
    
      public void start() {
          
          System.out.println("Engine started!");
          
          System.out.println("Max speed is " + maxSpeed);
        
      }  
      
      public void setSpeed(int newSpeed) {
          
     System.out.println(newSpeed);
        
      }  
        
      
      public void setMassege(String mail) {
      
          System.out.println(mail);
          
          System.out.println("Anything else?");
          
      }
}