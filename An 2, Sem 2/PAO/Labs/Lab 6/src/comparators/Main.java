package comparators;

import java.util.Arrays;

public class Main {
    public static void main(String[] args) {
        Person[] persons = new Person[3];
        persons[0] = new Person("John", 27, "john@gmail.com");
        persons[1] = new Person("Anne", 25, "anne@gmail.com");
        persons[2] = new Person("Mary", 23, "mary@gmail.com");

        for (Person p : persons) {
            System.out.println(p);
        }

        System.out.println("Persons sorted by age: ");
        Arrays.sort(persons, (p1, p2) -> {
            if(p1.getAge() > p2.getAge()){
                return 1;
            } else if (p1.getAge() < p2.getAge()) {
                return -1;
            } else {
                return 0;
            }
        });

        for (Person p : persons) {
            System.out.println(p);
        }

        System.out.println("Persons sorted by name: ");
        Arrays.sort(persons, (p1, p2) -> {
            return p1.getName().compareTo(p2.getName());
        });

        for (Person p : persons) {
            System.out.println(p);
        }

    }
}
