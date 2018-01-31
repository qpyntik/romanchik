/*
Какое сегодня число?
Ввести с клавиатуры дату в формате "08/18/2013"
Вывести на экран эту дату в виде "AUG 18, 2013".
Воспользоваться объектом Date и SimpleDateFormat.


Требования:
1. Программа должна считывать данные с клавиатуры.
2. В программе должна быть объявлена переменная типа SimpleDateFormat.
3. В программе должна быть объявлена переменная типа Date.
4. Все переменные должны быть проинициализированы.
5. Программа должна выводить данные на экран.
6. Вывод должен соответствовать заданию.
 */
package dateformat;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;


/**
 *
 * 
 */
public class DateFormat {

    public static void main(String[] args) throws ParseException, IOException {

        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        String dt = reader.readLine();

        SimpleDateFormat output = new SimpleDateFormat("MMM dd, yyyy", Locale.ENGLISH);
        SimpleDateFormat input = new SimpleDateFormat("MM/dd/yyyy");
        Date d = input.parse(dt);
        
        System.out.println(output.format(d).toUpperCase());
       
    }   
}