/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

// работаем с двумя файлами .java. Вызываем один метод из другого
package car;

import java.util.HashSet;
import java.util.Set;

/*
public class Main {

public static void main(String... args) {
        
       // System.out.println("Engine started!");
        
        Car car = new Car();
        car.maxSpeed = 55;
        car.start();   
        
    }
}
*/

// вызываем метод с КОНКРЕТНЫМИ аргументами

public class Main {

public static void main(String... args) {
        
       // System.out.println("Engine started!");
        
        Car car = new Car();
        
        int speed = 27;
        
        car.maxSpeed = 55;
        
        car.start();   
        
        car.setSpeed(39);
        
        car.setSpeed(speed);
        
        car.setMassege("Over!");
    
        
    }
}