/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package listing4dot5;
import java.util.*;

/**
 *
 * @author dima
 */
class Employee {
   
    private static int nextid;
    
    private int id;
    private String name = "";   // инициализация поля экземпляра
    private double salary;
    
    // статический блок инициализации
    static
    {
        Random generator = new Random();
        // задать произвольное число 0 - 999 в поле nextid
        nextid = generator.nextInt(10000);
    }

    // блок инициализации объекта
    {
        id = nextid;
        nextid++;
    }
    
    
    // 3 перегружаемых конструктора
    //
    public Employee(String n, double s) 
    {
        name = n;
        salary = s;
    }
    
    public Employee(double s) 
    {
     // вызвать конструктор Employee(String, double )
        this("Employee #" + nextid, s);
    }
    // конструктор без аргументов
    public Employee() 
    {
       // поле name инициализируется пустой строкой;
       // поле salary не устанавливается явно, а инициализируется нулем; 
       // поле id инициализируется в блоке инициализации    
    }
    //
    
    public String getName()
    {
        return name;
    }
    
    public double getSalary()
    {
        return salary;
    }
    
    public int getId()
    {
        return id;
    }
    
    
}
