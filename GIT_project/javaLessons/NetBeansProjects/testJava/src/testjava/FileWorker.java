/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package testjava;

import java.util.Arrays;

// masive
class FileWorker {
    
   
    
    public static void main(String args[]) {
 
    int[] brank =  {2, 7, 87, 234, 67, 38};  // первый способ вывести все элементы массива
     Arrays.sort(brank);    // упорядочивание массива
    System.out.println(Arrays.toString(brank)); // вывели все элементы массива строкой
        
        // выводим каждый элемент массива по отдельности
        for (int g : brank) {
            FileWorker.show();
            System.out.println(g);
        }
    }
    
    public static void show() {
        System.out.print("Element: ");
    
    
    /*
    int z = 0;
    int b = 0;
    
    while (z < 5) {
      
		b += 21;
		
		if (b < 20) {
		  
		  z++;
                  
                  System.out.println("После попытки №" + z + " b = " + b);
		  
		} else break;
    
    }
        
        System.out.println("b = " + b);
        System.out.println("Попыток = " + z);
        */
 }
 
}
