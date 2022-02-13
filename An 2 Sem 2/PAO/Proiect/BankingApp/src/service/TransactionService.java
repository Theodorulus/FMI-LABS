package service;

import model.*;

import java.util.Date;

public class TransactionService {
    public void makeTransfer(double value, Account senderAccount, Client destinationClient, String message) {
        Date date = new Date();
        if(destinationClient.getAccounts()[0] != null) {
            Account destinationAccount = destinationClient.getAccounts()[0];
            Currency destinationCurrency = destinationAccount.getCurrency();
            Currency senderCurrency = senderAccount.getCurrency();
            //Client sender = senderAccount.getClient();
            double valueInNewCurrency = value * senderCurrency.getValueDependingOnDollar() / destinationCurrency.getValueDependingOnDollar();
            destinationAccount.setNumberOfUnits(destinationAccount.getNumberOfUnits() + valueInNewCurrency);
            senderAccount.setNumberOfUnits(senderAccount.getNumberOfUnits() - value);
            Transaction transfer = new Transfer(value, "successful", date, senderAccount, destinationClient, message);
            AccountService accountService = new AccountService();
            accountService.addTransaction(senderAccount, transfer);
            accountService.addTransaction(destinationAccount, transfer);
        }
        else {
            System.out.println("You cannot transfer money to this individual because they don't have an account.");
            Transaction transfer = new Transfer(value, "failed", date, senderAccount, destinationClient, message);
            AccountService accountService = new AccountService();
            accountService.addTransaction(senderAccount, transfer);
        }
    }

    public void makeVaultDeposit(double value, Account senderAccount, Vault destinationVault) {
        boolean ok = false;
        Client sender = senderAccount.getClient();
        for(Client x: destinationVault.getMembers()) {
            if (x != null && x.equals(sender)){
                ok = true;
            }
        }
        Date date = new Date();
        if(ok) {
            Currency destinationCurrency = destinationVault.getCurrency();
            Currency senderCurrency = senderAccount.getCurrency();
            double valueInNewCurrency = value * senderCurrency.getValueDependingOnDollar() / destinationCurrency.getValueDependingOnDollar();
            destinationVault.setNumberOfUnits(destinationVault.getNumberOfUnits() + valueInNewCurrency);
            senderAccount.setNumberOfUnits(senderAccount.getNumberOfUnits() - value);
            Transaction vaultDeposit = new VaultDeposit(value, "successful", date, senderAccount, destinationVault);
            AccountService accountService = new AccountService();
            VaultService vaultService = new VaultService();
            accountService.addTransaction(senderAccount, vaultDeposit);
            vaultService.addTransaction(destinationVault, vaultDeposit);
        } else {
            Transaction vaultDeposit = new VaultDeposit(value, "failed", date, senderAccount, destinationVault);
            AccountService accountService = new AccountService();
            VaultService vaultService = new VaultService();
            accountService.addTransaction(senderAccount, vaultDeposit);
            vaultService.addTransaction(destinationVault, vaultDeposit);
        }
    }
}
