package functionalinterfaces;

import java.util.Random;
import java.util.function.*;

public class Main {
    public static void main(String[] args) {
        Predicate<String> predicate1 = (String word) -> word.length() > 10; // se putea si fara sa specific ca word e String

        System.out.println(predicate1.test("hello"));
        System.out.println(predicate1.test("hello world!!!"));

        Function<String, Integer> function1 = word -> word.length();

        System.out.println(function1.apply("hello"));
        System.out.println(function1.apply("hello world!!!"));

        Supplier<Double> supplier1 = () -> new Random().nextDouble();

        System.out.println(supplier1.get());
        System.out.println(supplier1.get());

        Consumer<Double> consumer1 = number -> System.out.println("This is a number: " + number);

        consumer1.accept(100.0);
    }
}
