/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package employeetest;

import static java.lang.System.*;

/*
 *
 * @author dima
 */
public class EmployeeTest {

    
    public static void main(String... args) {
        /*
        // фабричный метод
        NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance();
        NumberFormat percentFormatter = NumberFormat.getPercentInstance();
        double x = 0.1;
        System.out.println(currencyFormatter.format(x)); // UAH 0,10
        System.out.println(percentFormatter.format(x)); //10%
        */
        /*
        final int x = 5;
        final int a = 2;
        // метод возведения в степень 
        int c = (int) Math.pow(x, a);
        
        System.out.println(c);  // 25
       */
       
        Employee[] staff = new Employee[3];
            staff[0] = new Employee("Jack", "Nickolson", 30000, 1987, 12, 15);
            staff[1] = new Employee("Fred", "Murray", 45000, 1989, 21, 25);
            staff[2] = new Employee("Alex", "Sandro", 50000, 1983, 18, 11);
            
        // увеличить зп на 5%
        for (Employee e : staff)
        {
            e.raiseSalary(5);
        }
        
        // вывести данные обо всех объектах типа Employee
        for (Employee e : staff)
        {
            out.println("name = " + e.getName() + ", salary = " + e.getSalary() + ", hireDay = " + e.getHireDay());  
        }
    }
    
 }   
