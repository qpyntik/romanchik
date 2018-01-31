/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package javarush;

/**
 *
 * @author dima
 */


public class JavaRush {
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) 
   {
     int a = 48;
     int b = 12;
     int m = min(a, b);
     
     //System.out.println("Minimum is " + m);
    
       
       
       //   /home/dima/dima.txt
  
       
}
    public static int min(int c, int j)
    {
        int t;
        
        if (c < j)
            t = c;
        else
            t = j;
        return t;
    }
}