/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package testforjava;

import java.util.Scanner;

/**
 *
 * @author dima
 */
public class TestForJava {

    public static void main(String... args) {
        /*
            Scanner in = new Scanner (System.in);
            System.out.println("Назовите число 'Z': ");
            int z = in.nextInt();
            System.out.println("Ваше число " + z + "? Хорошо.");
            System.out.println("Назовите число 'Y': ");
            int y = in.nextInt();
            System.out.println("И это число " + y + "? Прекрасно!");
            if (z < y) {
            System.out.println("Могу сказать точно, что " + z + " меньше, чем " + y + ".");
            } else if (z > y){
            System.out.println("Первое число " + z + " больше " + y + ".");
            }
            else{
            System.out.println("Понятно! Ваши числа равны!");
            }
  */
        
        // Оператор continue - передает управление в начало текущего цикла 
        int key = 5;
        int res = 27;
        int n;
        
        Scanner in = new Scanner (System.in);
        
                while (key < res) {

                    System.out.println("Enter a number: ");
                    n = in.nextInt();

                    if (n < 2) continue;
                    key += n;

                    System.out.println("Result number is: " + key); 
                }
        
            System.out.println("Final! Sum your number: " + key);
            result();
            
        }
    
    
            public static void result() {
                   System.out.println("Game over"); 
            }
    
}
