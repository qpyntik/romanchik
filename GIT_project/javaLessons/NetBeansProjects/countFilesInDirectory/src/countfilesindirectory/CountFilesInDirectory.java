/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package countfilesindirectory;

/**
 *
 * @author dima
 */
class Human {

   String name;
   
   int age;
   
   String surname;

}

class main {
    
    public static void main(String... args) {
        
     Human guest = new Human();
     
     guest.surname = "Ivanov";
     
     System.out.println(guest.surname);
        }
}
