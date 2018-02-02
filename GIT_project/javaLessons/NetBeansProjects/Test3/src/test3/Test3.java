/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package test3;

/**
 *
 * @author dima
 */
public class Test3 {

    int a, b;
        Test3()
        {
            a = 10;
            b = 20;
            }
    }

    class Runner
    {
        public static void main(String[] args)
        {
            Test3 obj1 = new Test3();
            Test3 obj2 = obj1;
            
            obj1.a += 1;
            obj1.b += 1;

            obj2.a += 1;
            obj2.b += 1;
            
            System.out.println(obj2);
        }
    }


