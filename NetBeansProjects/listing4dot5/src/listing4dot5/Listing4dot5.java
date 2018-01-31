/**
 * 
 * 
 * 
 */
package listing4dot5;

/**
 * конструирование объектов
 * 
 */


public class Listing4dot5 {

   
    public static void main(String[] args) {
        // заполним массив с 3мя объектами
        
        Employee [] part = new Employee[3];
        
        part[0] = new Employee("Jack", 30000);
        part[1] = new Employee(50000);
        part[2] = new Employee();
        
        // выводим данные обо всех объектах типа Employee
        for (Employee e : part) 
        {
            System.out.println("Name - " + e.getName());
            System.out.println("Id = " + e.getId());
            System.out.println("Salary = " + e.getSalary());
            System.out.println();
        }
        
    }
    
}
