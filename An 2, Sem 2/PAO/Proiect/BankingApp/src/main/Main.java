package main;

import model.*;
import service.*;

import java.util.Date;
import java.util.Random;
import java.time.LocalDate;

public class Main {
    public static void main (String[] args) {
        /*
        Date input:
        1
        2
        yes
        */
        app();
    }
    public static void app() {
        // Add Client & View Clients
        Client[] clients = new Client[50];
        ClientService clientService = new ClientService();
        clientService.addClient(clients, new Individual("marcelus@gmail.com", "0712345678", "5000520999999", "Marcelus", "Wallace"));
        clientService.addClient(clients, new Company("office@th_experts.com", "0777777777", "22111111", "TH Experts"));
        clientService.addClient(clients, new Individual("john@gmail.com", "0712345679", "5000520999998", "John", "Travolta"));
        clientService.viewClients(clients);

        Currency[] currencies = new Currency[5];
        currencies[0] = new Currency();
        currencies[1] = new Currency("EURO", 1.1769715);
        currencies[2] = new Currency("RON", 0.23978812);

        // Create account
        AccountService accountService = new AccountService();
        accountService.createAccount(clients[0], currencies[2], 1500);
        accountService.createAccount(clients[0], currencies[0], 100);
        accountService.createAccount(clients[0], currencies[1], 150);
        accountService.createAccount(clients[0], currencies[2], 500);
        accountService.createAccount(clients[2], currencies[0], 5000);
        System.out.println("\nAccounts of " + clients[0].toString() + ":");
        for(Account client:clients[0].getAccounts()) {
            if(client != null) {
                System.out.println(client);
            }
        }

        // Close account

        System.out.println();
        accountService.closeAccount(clients[0]);
        System.out.println("\nAccounts of " + clients[0].toString() + " after closing an account:");
        for(Account account:clients[0].getAccounts()) {
            if(account != null) {
                System.out.println(account);
            }
        }

        // Create card

        CardService cardService = new CardService();
        cardService.createCard(clients[0].getAccounts()[0], "credit");
        cardService.createCard(clients[0].getAccounts()[0], "debit");

        System.out.println("\nCards of " + clients[0].toString() + "'s account " + clients[0].getAccounts()[0] + ":");
        for(Card card:clients[0].getAccounts()[0].getCards()) {
            if (card != null) {
                System.out.println(card);
            }
        }

        // Freeze/unfreeze card
        System.out.println();

        cardService.freezeCard(clients[0].getAccounts()[0].getCards()[0]);
        System.out.println("The card is: ");
        if(clients[0].getAccounts()[0].getCards()[0].isFrozen())
            System.out.println("Frozen");
        else
            System.out.println("Not Frozen");

        cardService.unfreezeCard(clients[0].getAccounts()[0].getCards()[0]);

        System.out.println("The card is: ");

        if(clients[0].getAccounts()[0].getCards()[0].isFrozen())
            System.out.println("Frozen");
        else
            System.out.println("Not Frozen");

        //Create vault
        VaultService vaultService = new VaultService();
        vaultService.createVault(clients[0], currencies[2]);
        vaultService.addMemberToVault(clients[0].getVaults()[0], clients[1]);

        System.out.println("\nVaults of " + clients[0] + ":");
        for(Vault vault:clients[0].getVaults()){
            if(vault != null){
                System.out.println(vault);
            }
        }

        System.out.println("\nMembers of vault " + clients[0].getVaults()[0] + ":");
        for(Client client:clients[0].getVaults()[0].getMembers()){
            if(client != null)
                System.out.println(client);
        };

        //Make transfer
        TransactionService transactionService = new TransactionService();
        transactionService.makeTransfer(100, clients[0].getAccounts()[0], clients[2],"salut");
        System.out.println("\nTransactions of " + clients[0] + "'s account " + clients[0].getAccounts()[0] + ":");
        for(Transaction transaction: clients[0].getAccounts()[0].getTransactions()) {
            if (transaction != null) {
                System.out.println(transaction);
            }
        }
        System.out.println("\nTransactions of " + clients[2] + "'s account " + clients[2].getAccounts()[0] + ":");
        for(Transaction transaction: clients[2].getAccounts()[0].getTransactions()) {
            if (transaction != null) {
                System.out.println(transaction);
            }
        }
        System.out.println("\nThe accounts after the transfer:");

        System.out.println(clients[0].getAccounts()[0]);
        System.out.println(clients[2].getAccounts()[0]);

        //Make vault deposit
        transactionService.makeVaultDeposit(100, clients[0].getAccounts()[0], clients[0].getVaults()[0]);
        System.out.println("\nTransactions of " + clients[0] + "'s account " + clients[0].getAccounts()[0] + ":");
        for(Transaction transaction: clients[0].getAccounts()[0].getTransactions()) {
            if (transaction != null) {
                System.out.println(transaction);
            }
        }

        //Extract statement
        StatementService statementService = new StatementService();
        statementService.extractStatement(clients[0].getAccounts()[0]);
    }
}
