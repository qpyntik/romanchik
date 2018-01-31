/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package calendartest;

import java.util.*;


public class CalendarTest {
    
  
    public static void main(String[] args) {
        
        final  GregorianCalendar deadline = new GregorianCalendar();
        

        // получить в объект deadline текущий месяц
        final int month = deadline.get(Calendar.MONTH);
        showScreen(month);
        
        // получить в объект deadline текущий год
        int year = deadline.get(Calendar.YEAR);
        showScreen(year);
        
        // получить в объект deadline текущий день недели (Sunday: 1)
        final int dayOfWeek = deadline.get(Calendar.DAY_OF_WEEK);
        showScreen(dayOfWeek);
        
        // получить в объект deadline текущий день месяца
        final int dayOfMonth = deadline.get(Calendar.DAY_OF_MONTH);
        showScreen(dayOfMonth);
        
//        // изменить число месяца
//        deadline.set(Calendar.MONTH, 3);
//        
//        // прибавить к числу года 33
        deadline.add(Calendar.YEAR, -33);
      year = deadline.get(Calendar.YEAR);
      showScreen(year);  
//        if (deadline.get(Calendar.MONTH) == 3) {
//            System.out.println("Number of month incorrectly!\nNumber of month now: " + month);
//        }   else System.out.println("Day of month number correctly!");
//
//        if (deadline.get(Calendar.YEAR) != 2017) {
//            System.out.println("Year is " + deadline.get(Calendar.YEAR));
//        }   
  
        final int a = deadline.getMaximum(Calendar.DAY_OF_MONTH);
        showScreen(a);
        
        // получить последний день месяца
        final int b = deadline.getActualMaximum(Calendar.DAY_OF_MONTH);
        showScreen(b);
        
        if (b == dayOfMonth ) {
            System.out.println("Сегодня последний день месяца!");
      }  else  System.out.println("Сегодня не конец месяца");
        
       final int firstDayOfWeek = deadline.getFirstDayOfWeek();
        showScreen(firstDayOfWeek); 
        
        final int ERA = deadline.get(Calendar.ERA);
        showScreen(ERA); 
        
        // выводим текущие день, месяц, число, время, год
        final Date dt = deadline.getTime();
        System.out.println(dt);
        
    }

    private static void showScreen(int c) {
        System.out.println(c);
    }

}
