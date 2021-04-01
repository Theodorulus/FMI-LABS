package service;

import model.Account;
import model.Client;
import model.Currency;
import model.Transaction;

import java.util.Random;
import java.util.Scanner;

public class AccountService {
    public void createAccount(Client client, Currency currency, double firstDeposit) {
        String iban = "RO";
        Random rand = new Random();
        iban = iban + String.valueOf(rand.nextInt(10)) + rand.nextInt(10);
        iban = iban + "THBN";
        for(int i = 0; i < 13; i++) {
            iban = iban + rand.nextInt(10);
        }
        iban = iban + currency.toString();
        //TO DO -> Check if iban is unique
        Account account = new Account(iban, client, currency, firstDeposit);
        ClientService clientService = new ClientService();
        int index = clientService.getLastAvailableIndexAccounts(client);
        client.getAccounts()[index] = account;
    }

    public void closeAccount(Client client) {
        ClientService clientService = new ClientService();
        int index = clientService.getLastAvailableIndexAccounts(client);
        System.out.println("List of you accounts:");
        for(int i = 0; i < index; i++) {
            System.out.println(String.valueOf(i + 1) + ": "+ client.getAccounts()[i]);
        }
        System.out.println("Which account would you like to close?(Please type the number before the iban)");
        Scanner scanner = new Scanner(System.in);
        int closedAccountIndex = scanner.nextInt();
        System.out.println("In which account would you like your funds to go?(Please type the number before the iban)");
        int transferAccountIndex = scanner.nextInt();
        Account transferAccount = client.getAccounts()[transferAccountIndex - 1];
        Account closedAccount = client.getAccounts()[closedAccountIndex - 1];
        Currency transferAccountCurrency = transferAccount.getCurrency();
        Currency closedAccountCurrency = closedAccount.getCurrency();
        double sumNewCurrency = closedAccount.getNumberOfUnits() * closedAccountCurrency.getValueDependingOnDollar() / transferAccountCurrency.getValueDependingOnDollar();
        transferAccount.setNumberOfUnits(transferAccount.getNumberOfUnits() + sumNewCurrency);

        Account[] accountsCopy = new Account[client.getAccounts().length];
        client.getAccounts()[closedAccountIndex - 1] = null;
        for (int i = 0, j = 0; i < accountsCopy.length; i++){
            if(client.getAccounts()[i] != null) {
                accountsCopy[j++] = client.getAccounts()[i];
            }
        }
        client.setAccounts(accountsCopy);
    }

    public void addTransaction(Account account, Transaction transaction) {
        int index = getLastAvailableIndexTransactions(account);
        account.getTransactions()[index] = transaction;
    }



    public int getLastAvailableIndexCards(Account account) {
        for(int i = 0; i < account.getCards().length; i++) {
            if (account.getCards()[i] == null) {
                return i;
            }
        }
        return -1;
    }

    public int getLastAvailableIndexTransactions(Account account) {
        for(int i = 0; i < account.getTransactions().length; i++) {
            if (account.getTransactions()[i] == null) {
                return i;
            }
        }
        return -1;
    }
}
