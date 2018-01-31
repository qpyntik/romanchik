/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package videolessonsjava;

 /* простое создание класса VideoLessonsJava, объявление переменных, 
присвоение значений и вывод на экран  */

public class VideoLessonsJava 
{

        String name;
   
        int age;

        String surname;
        
    public static void main(String... args) 
    {
      
        VideoLessonsJava guest = new VideoLessonsJava();
     
        guest.surname = "Иванов";

        System.out.println(guest.surname);
        
        guest.age = 78;
        
        System.out.println(guest.age);
        
        System.out.println("Господину " + guest.surname + "у " + "сегодня исполнилось " + guest.age + " лет!");
     }
    
    
    
}

