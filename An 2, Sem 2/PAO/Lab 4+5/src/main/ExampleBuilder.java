package main;

import model.Car;

public class ExampleBuilder {
    //Builder Design Pattern
    public static void main(String[] args) {
        Car car = new Car.Builder()
                .withColor("blue")
                .build();
        System.out.println(car.getColor());

        Car car2 = new Car.Builder()
                .withColor("white")
                .withPrice(15000)
                .build();
        System.out.println(car2.getColor() + " " + car2.getPrice());
    }
}
