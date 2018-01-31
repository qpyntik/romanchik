/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Test2week2_3;

/**
 *
Напишіть застосування, що виконує пошук заданого числа у відсортованому масиві — бінарний пошук
У випадку коли число знайдено виведіть на екран його позицію в масиві (позиції нумеруємо з нуля) або -1 в іншому випадку
 * 
 */
public class Test2week2_3 {
    public static void main(String[] args) {

	int data[] = { 18, 20, 27, 29, 51, 55, 56, 66, 72, 73 };
	int numberToFind = 51;
        int a = -1;
        int c = -1;
        
        for(int i = 0; i < data.length; i++){ 
        
            if (data[i] == numberToFind)
            {
                c = i;
                break;
            } 
        } 
      System.out.println(c);
    }
}
