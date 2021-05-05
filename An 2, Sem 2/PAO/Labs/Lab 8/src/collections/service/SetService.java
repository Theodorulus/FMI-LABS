package collections.service;

import collections.model.Account;
import collections.model.DebitBankAccount;
import collections.model.SavingsBankAccount;

import java.util.*;

public class SetService {
    /*

        Collections Framework
        Set<E>
            HashSet<E>
            LinkedHashSet<E>
            TreeSet<E>
    */

    public static void main(String[] args) {
        Set<String> cities = new HashSet<>();
        cities.add("Bucuresti");
        cities.add("Timisoara");
        cities.add("Brasov");
        cities.add("Bucuresti");
        cities.add("Cluj");

        System.out.println("Cities:");
        cities.forEach(city -> System.out.println(city));

        Set<String> cities2 = new LinkedHashSet<>();
        cities2.add("Bucuresti");
        cities2.add("Timisoara");
        cities2.add("Brasov");
        cities2.add("Bucuresti");
        cities2.add("Cluj");

        System.out.println("\nCities ordered by adding opperation:");
        cities2.forEach(city -> System.out.println(city));

        Set<String> cities3 = new TreeSet<>();
        cities3.add("Bucuresti");
        cities3.add("Timisoara");
        cities3.add("Brasov");
        cities3.add("Bucuresti");
        cities3.add("Cluj");

        System.out.println("\nCities sorted alphabetically:");
        cities3.forEach(city -> System.out.println(city));

        Set<Account> accounts = new TreeSet<>();
        accounts.add(new SavingsBankAccount(7000, "12347", 3));
        accounts.add(new DebitBankAccount(5000, "12345", "1111222233334444", 10000));
        accounts.add(new SavingsBankAccount(9000, "12346", 6));
        System.out.println("\n" + accounts.contains(new SavingsBankAccount(7000, "12347", 3)));

        System.out.println("\nAccounts sorted by balance:");
        accounts.forEach(account -> System.out.println(account));
    }
}
