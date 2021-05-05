package collections.service;

import collections.model.Account;
import collections.model.DebitBankAccount;
import collections.model.SavingsBankAccount;

import java.util.*;

public class ListService {
    /*

        Collections Framework
        List<T>
            LinkedList<T>
            ArrayList<T>
    */


    public static void main(String[] args) {
        List<Account> accounts = new LinkedList<>();
        accounts.add(new DebitBankAccount(5000, "12345", "1111222233334444", 10000));
        accounts.add(new SavingsBankAccount(7000, "12347", 3));
        accounts.add(new SavingsBankAccount(9000, "12346", 6));

        for(Account account : accounts) {
            System.out.println(account);
        }

        //accounts.remove(0);
        //accounts.clear();

        List<Account> newAccounts = new ArrayList<>();
        newAccounts.add(new DebitBankAccount(3000, "159874", "1111888833334444", 10000));
        newAccounts.add(new DebitBankAccount(7500, "129434", "1111888833335555", 10000));
        accounts.addAll(newAccounts);
        System.out.println("Accounts with the new accounts: ");
        accounts.forEach(account -> System.out.println(account));

        List<Integer> numbers = new ArrayList<>();
        numbers.add(1);
        numbers.add(Integer.valueOf("2"));

        Collections.sort(accounts);
        System.out.println("Accounts sorted by ballance: ");
        accounts.forEach(account -> System.out.println(account));

        System.out.println(accounts.size());
    }
}
