/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package test2week2;

/**
 *
 * Напишіть застосування для сортування масиву методом бульбашки
 */
public class Test2Week2 {

    public static void main(String[] args) {
        
        int[] array = {30, 186, 1, 2, 23, 10, 4, 6};
	int length = array.length;

        
        for(int i = length-1 ; i > 0 ; i--){
            for(int j = 0 ; j < i ; j++){

                if( array[j] > array[j+1] ){
                    int tmp = array[j];
                    array[j] = array[j+1];
                    array[j+1] = tmp;
                }
            }
        }
		
		for (int i = 0; i < length; i++) {
			System.out.print(array[i] + " ");
		}
    }
}
