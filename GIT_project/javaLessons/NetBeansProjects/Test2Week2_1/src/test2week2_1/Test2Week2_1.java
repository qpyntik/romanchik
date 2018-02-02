/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package test2week2_1;

/**
 *
 * @author dima
 */
public class Test2Week2_1 {

    /**
     * Використовуючи цикл for виведіть на екран матрицю.
     */
    public static void main(String[] args) {
        
    //int size = 5;
    int[][] array = new int[5][5];
    int k = 1;
    int c = 0;
   
        for (int i = 0; i < array.length; i++)
        {
            c++;
            for(int j = 0; j < array[i].length; j++)
            {
                array[i][j] = k;
                k++;
                
                if (i == j || j == array.length-c)   
                {
                    System.out.print(" * ");
                }                  
                else if (k <= 10)
                            {
                                System.out.print(" " + array[i][j] + " ");
                            } else 
                                {
                                    System.out.print(array[i][j] + " ");
                                }
                

            }
                
            
           System.out.println();
                
     
        }

    }
    
}
