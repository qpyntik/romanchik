/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package paramtest4;

/**
 *
 * @author dima
 */

class Employee 
            {

                private String name;
                private double salary;

                public Employee (String x, double y)
                {
                    name = x;
                    salary = y;
                }
                
                public String getName ()
                {
                    return name;
                }
                
                public double getSalary ()
                {
                    return salary;
                }

                public void raiseSalary(double byPersent) 
                {
                   double raise = salary * byPersent / 100;
                   salary += raise;
                }

             }
