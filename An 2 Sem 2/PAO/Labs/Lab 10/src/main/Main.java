package main;

import model.BankAccount;
import model.BankAccountStatus;
import service.*;

import java.util.List;

public class Main {
    public static void main(String[] args) {
        ClientService clientService = ClientService.getInstance();

        BankAccountService bankAccountService = new BankAccountService(ClientService.getInstance());
        List<BankAccount> bankAccounts = bankAccountService.getBankAccounts();

        System.out.println("Number of bank account for rteodorescu@gmail.com: " +
                bankAccountService.getNumberOfAccountsForEmail(bankAccounts, "rteodorescu@gmail.com"));
        System.out.println("\nNames and emails for each client:");
        bankAccountService.printUniqueClientDetails(bankAccounts);
        System.out.println("\nSavings Bank Accounts details by balance:");
        bankAccountService.printSavingsBankAccountByBalance(bankAccounts);
    }
}
