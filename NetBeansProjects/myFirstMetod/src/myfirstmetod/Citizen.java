/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package myfirstmetod;

/**
 *
 * @author dima
 */
public class Citizen {
    
    private String name;
    private String surname;

    public Citizen(String n, String s) 
    {
        name = n;
        surname = s;
    }

    String getName() 
    {
       return name;
    }
    
    String getSurname()
    {
        return surname;
    }
    
    String getFullInto ()
    {
        return surname + " " + name;
    }
    
}
