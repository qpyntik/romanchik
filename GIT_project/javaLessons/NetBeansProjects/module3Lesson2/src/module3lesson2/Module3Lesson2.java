/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package module3lesson2;


public class Module3Lesson2 {
    
   // int a;
  //  int b;
    
    public int sum(int a, int  b) {
        
        return a + b;
    }
    
    public static void main(String... args) {
        
       // System.out.println("Engine started!");
        
       Module3Lesson2 mod = new Module3Lesson2();
        
       int a = 4;
       int z = 75;
       
       int result = mod.sum(a, z);
       System.out.println(result);
       
       int c = mod.sum(result, z);
       
        System.out.println((c + result*12) / 5.0);
    
    }
    
}
