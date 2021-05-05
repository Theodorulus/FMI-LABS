package main;

import java.util.Locale;

public class ExampleString {
    public static void main(String[] args) {
        String name1 = "John"; // String pool
        String name2 = new String("John"); // Heap -> Nu e tocmai recomandat; e mai eficient cu = "..."
        String name3 = "John"; // String pool

        System.out.println(name1 == name3); // references -> true
        System.out.println(name1 == name2); // references -> false

        System.out.println();

        String hello = "hello";
        System.out.println(hello.charAt(0));
        System.out.println(hello.toCharArray()); // -> un array de char-uri => putem folosi []
        System.out.println(hello.substring(2));
        System.out.println(hello.substring(2, 3));

        String upperCaseHello = hello.toUpperCase();
        System.out.println(upperCaseHello);

        String helloWorld = hello.concat(" world!");
        System.out.println(helloWorld);

        StringBuilder sb1 = new StringBuilder("hello");
        sb1.append(" world");
        System.out.println(sb1);
    }
}
