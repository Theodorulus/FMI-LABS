package main;

import model.Bicycle;
import model.Product;

public class Example {
    public static void main(String[] args){
        Bicycle b1 = new Bicycle(1, "BMX", 12, 7, "BMX-500", false, 100 );
        Bicycle b2 = new Bicycle(2, "BMX", 15, 5, "BMX-500", false, 100 );

        if(b1 == b2) { // references are compared
            System.out.println("reference of b1 is equal to the reference of b2");
        } else {
            System.out.println("reference of b1 is not equal to the reference of b2");
        }

        if(b1.equals(b2)) { // instances are compared
            System.out.println("b1 is equal to b2");
        } else {
            System.out.println("b1 is not equal to b2");
        }

        System.out.println(b1.getClass());

    }
}
