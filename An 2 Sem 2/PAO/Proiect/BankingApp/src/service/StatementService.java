package service;

import model.Account;
import model.Client;
import model.Transaction;

public class StatementService {
    public void extractStatement(Account account) {
        Client client = account.getClient();
        System.out.println("\nStatement of " + client + "'s account " + client.getAccounts()[0] + ":");
        for(Transaction transaction: account.getTransactions()){
            if(transaction != null)
                System.out.println(transaction);
        }
    }

}
