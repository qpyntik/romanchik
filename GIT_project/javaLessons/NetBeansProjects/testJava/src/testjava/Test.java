/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package testjava;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.util.Scanner;
import java.io.FileWriter;
import java.io.PrintStream;
import java.util.Arrays;

/**
 *
 * @author dima
 */
/*
public class TestJava {

    
  
    
    public static void main(String[] args) {
        
    int a = 3;
	  System.out.println(a);

	  int rep; 
    
    for (rep == 0; rep < 5; rep = rep+1)
    {
	    a++;
	    System.out.println(a);
    }
  
        
    System.out.println("Вышли из цикла");
*/


//public class Test {
//
//   public static void main(String args[]) {
//       
//       int a = 4;
//       String c = Integer.toString(a);
//       
//      // c = a.toString();
///*  
//      for(int x = 0; x < 3; x++) {
//          
//          if (a != 5)
//	  {
//	    a++;
//		System.out.println(a);
//	  }
//          break;
//         // System.out.println("Значение x: " + x );
//      }*/
//
//      System.out.println(c);
//   }
//   
//}
        // Копирование массивов изменение длинны и сортировка нового массива при копировании
        /*
        int[] smallArray = {2, 87, 4, 234, 67, 7};
      
       int[] fistArray = Arrays.copyOf(smallArray, 4 + smallArray.length ) ;
        Arrays.sort(fistArray);
        for (int znachenie : fistArray) {
            System.out.println(znachenie);
        };
        
        */
        /* преобразование строки в число
        String interval = "201706";
        int intervalDate = (Integer.parseInt(interval) - 1);
        System.out.println(intervalDate);
         */
        
        /*
        String[] brank =  {"sf", "ee", "sdejhjj", "235", "ju", "f"};  // первый способ вывести все элементы массива
        System.out.println(Arrays.toString(brank));
         */
        
        /*
        int[] brank =  {2, 7, 87, 234, 67, 7};  // второй способ вывести все элементы массива
        System.out.println(Arrays.toString(a));
        for (int i = 0; i < brank.length; i++){
        //brank[i] = i;
        System.out.println(brank[i]);}
        for (int q : brank)   // второй способ вывести все элементы массива
        System.out.println(q);
         */
        
        //Массивы
        /*
        int [] a = new int[10];
        for (int i = 0; i < a.length; i++){
        a[i] = i;
        System.out.println(a[i]);}
         */
        
        //int [] a = new int[10];
        // System.out.println(Arrays.toString(a));
        // работаем с SWITCH
       
        /*     String input = "st";
        switch(input.toLowerCase())  {
        case "crash" : System.out.println("Это нужное нам слово - " + input + "!");
        break;
        default: System.out.println("Это ненужное слово...!");
        break;
        }
         */
        
        // int s = 1;
        // int a = 27;
        /*
        if (s > a) {
        System.out.println("Первое число больше второго!");
        } else if (s < a) {
        System.out.println("Второе число больше первого!");
        } else
        System.out.println("Неужели числа равны?!");
         */
        
        // цикл while
        /*
        while (s < a) {
        System.out.println("Твое число " + s + " и оно всё еще меньше искомого.");
        s +=5;
        }
        System.out.println("Поздравляем! Твое число больше искомого! Искомое число: " + a);*/
        /*  //игра с вводом и выводом чисел
        Scanner in = new Scanner (System.in);
        System.out.println("Назовите число 'Z': ");
        int z = in.nextInt();
        System.out.println("Ваше число " + z + "? Хорошо.");
        System.out.println("Назовите число 'Y': ");
        int y = in.nextInt();
        System.out.println("И это число " + y + "? Прекрасно!");
        if (z < y) {
        System.out.println("Могу сказать точно, что " + z + " меньше, чем " + y + ".");
        } else if (z > y){
        System.out.println("Первое число " + z + " больше " + y + ".");
        }
        else{
        System.out.println("Понятно! Ваши числа равны!");
        }
         */


/*
    public static void main(String[] args) {
       /* // TODO code application logic here
        System.out.println("Вот и всё!\u2122");
        System.out.print("Получилось уже что-то! ");
        System.out.println("Продолжай!");
        
        double x = 25;
        double y = Math.sqrt(x); // вычисление корня
        System.out.println(y);
        
        y = Math.pow(x,3); //возведение в степень 3
        System.out.println(y);
        
        double c = 39.98767;
        int g = (int)Math.round(c); //привели с в другой тип int и округлили к ближайшему целому числу
        System.out.println(g);
        
        String green = "зеленый цвет";
        String color = green.substring(8, 12); // обрезали строку - достали из строки подстроку
        System.out.println(color);
        
        boolean abr = "Hello".equalsIgnoreCase("heLly"); // сравниваем строки на идентичность
        System.out.println(abr);
        
        Scanner vxod = new Scanner(System.in); //задаем вопрос пользователю "как его зовут?", ждем ввода информации и выводим результат на экран
        System.out.println("What's your name? ");
        String name = vxod.nextLine();
        System.out.println("Hello, " + name);
        
        System.out.println("Where are do you live?");
        String city = vxod.nextLine();
        System.out.println(city + " is a beautiful city!");
        
        double k = 10000.0 / 3.0;
        System.out.printf("%8.2f", k);
        System.out.println(" ");
        
        String nick = "Dmitriy";
        int age1 = 27;
        String town = "Dnepr";
        System.out.printf("Hello! My name is %s. My old - %d. I live in %s! ", nick, age1, town);
              
        // System.out.printf("%tc", new Date() ); не работает какого то хера*/
       
       
  //  }
    
//}
