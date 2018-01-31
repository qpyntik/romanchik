/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package employeetest;

import java.util.Date;
import java.util.GregorianCalendar;

/**
 *
 * @author dima
 */

class Employee {
            private String firstname;
            private String name;  
            private double salary;
            private Date hireDay;
                
                public Employee (String f, String n, double s, int year, int month, int day) {
                    firstname = f;
                    name = n;
                    salary = s;
                    GregorianCalendar calendar = new GregorianCalendar(year, month-1, day);
                    hireDay = calendar.getTime();
                }
             
                
                    public String getName () {
                        return firstname + " " + name;
                    }
                    
                    public double getSalary () {
                        return salary;
                    }                

                    public Date getHireDay() {
                        return hireDay;
                        }
                    
                    public void raiseSalary(double byPersent) {
                        double raise = salary * byPersent / 100;
                        salary += raise;    
                    }
}
