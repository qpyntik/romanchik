/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package helloworld;

/**
 *
 * @author dima
 */
public class HelloWorld {
    
    public static void main(String[] args) {                

    double a = 0;
    double b = 10;
    double c = 0;
    double x1, x2, D;
    
    D = (b*b) - (4*a*c);
    System.out.println("D = " + D);
    System.out.println(Math.sqrt(D));
    
    
    if (a == 0 && b == 0 || c == 0 && b == 0 || a == 0 && c == 0 || a == 0 && b == 0 && c == 0) 
    {  
        if (D <= 0) 
        {
            System.out.println("x1=");
            System.out.println("x2=");  
        }  else  
            {
                x1 = 0/b;
                x2 = x1;

                System.out.println("x1="+x1);
                System.out.println("x2="+x2);  
            }
        
    } else if (D < 0) 
      {
        System.out.println("x1=");
        System.out.println("x2=");
      } else if (D == 0) 
        {
            x1 = (-b)/(2*a);
            x2 = x1;

            System.out.println("x1="+x1);
            System.out.println("x2="+x2);   
        
        } else  if (D > 0)
            {
              x1 = (-b + Math.sqrt(D)) / (2*a);
              x2 = (-b - Math.sqrt(D)) / (2*a);

              System.out.println("x1="+x1);
              System.out.println("x2="+x2);  

            }
    
    }
   
}





