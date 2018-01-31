/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.

Напишіть застосування для сортування масиву методом сортування Шелла (ShellSort).
https://www.youtube.com/watch?v=HHNSpPRUmPk
 */
package Test2week2_total_not_mark;

import static javafx.beans.binding.Bindings.length;

/**
 *
 * @author dima
 */
public class Week2_total {
    public static void main(String[] args) {
     int[] array = {30, 2, 10, 4, 6};
     int length = array.length;
     int d = length/2;
    
    while (d > 0){
        for(int i = 0; i < (length - d); i++) {
            int j = i;
            while ((j >= 0) && (array[j] > array[j + d] )){
                int temp = array[j];
                array[j] = array[j + d];
                array[j + d] = temp;
                j--;
            }    
        }
            d /= 2;
    }
	    
        for (int i = 0; i < length; i++) {
            System.out.print(array[i] + " ");
        }
    }
}
