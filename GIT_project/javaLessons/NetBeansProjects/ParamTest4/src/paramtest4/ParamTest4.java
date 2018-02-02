/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package paramtest4;

/**
 * Демонстрируется передача параметров в Java
 * 
 */
public class ParamTest4 {

    
    public static void main(String[] args) {
        
        //
        // Тест 1: методы не могут видоизменять числовые параметры
        //
        System.out.println("Testing tripleValue:");
        double percent = 10;
        System.out.println("Before: percent = " + percent);
        tripleValue(percent);
        System.out.println("After: percent = " + percent);
        
        //
        // Тест 2: методы могут изменять состояния объектов, передаваемых в качестве параметров
        //
        System.out.println("\nTesting tripleSalary:");
        Employee harry = new Employee ("Yarry", 50000);
        System.out.println("Before salary: " + harry.getSalary());
        tripleSalary(harry);
        System.out.println("After salary: " + harry.getSalary());
        
        //
        // Тест 3: методы не могут присоединять новые объекты к объектным параметрам
        //
        System.out.println("\nTesting swap:");
        Employee a = new Employee ("Alice", 35000);
        Employee b = new Employee ("Bobby", 77000);
        System.out.println("Before: a = " + a.getName());
        System.out.println("Before: b = " + b.getName());
        swap(a, b);
        System.out.println("After: a = " + a.getName());
        System.out.println("After: b = " + b.getName());
    }
    
    public static void tripleValue (double x)   // не сработает
    {
        x *= 3;
        System.out.println("End of method \"tripleValue()\": x = " + x);
    }
    
    public static void tripleSalary (Employee x) // сработает
    {
        x.raiseSalary(200);
         System.out.println("End of method \"raiseSalary()\": salary = " + x.getSalary());
    }

    public static void swap (Employee x, Employee y)
    {
        Employee temp = x;
        x = y;
        y = temp;
        
        System.out.println("End of method: x = " + x.getName());
        System.out.println("End of method: y = " + y.getName());
    }
    
    
    
    
    
    /*

    
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
            */
}
