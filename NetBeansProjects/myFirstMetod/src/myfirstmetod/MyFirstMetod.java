/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package myfirstmetod;

/**
 *
 * метод, написанный мною
 */
public class MyFirstMetod 
{
    
    public static void main(String[] args) 
    {
        
        System.out.println("Testing:");
        Citizen chel1 = new Citizen ("Alice", "Bond");
        Citizen chel2 = new Citizen ("Bobby", "Lowren");
        System.out.println("This is " + chel1.getName() + " " + chel1.getSurname());
        System.out.println("This is " + chel2.getName() + " " + chel2.getSurname());
        
        System.out.println("\nTesting ciklum:");
        Citizen[] ab = new Citizen[2];
        ab[0] = chel1;
        ab[1] = chel2;
        
        for(Citizen e : ab) 
        {
            System.out.println(e.getName() + " " + e.getSurname()); 
        }  
        
        System.out.println(); 
        
        for(Citizen k : ab) 
        {
            System.out.println(k.getFullInto()); 
        } 

    }
    
}
