package model;

import java.util.Arrays;

public class Vault {
    private String identificationNumber;
    private Client[] members = new Client[15];
    private Currency currency;
    private double numberOfUnits;
    private Transaction[] transactions = new Transaction[50];

    public Vault(String identificationNumber, Client foundingMember, Currency currency, double numberOfUnits) {
        this.identificationNumber = identificationNumber;
        this.members[0] = foundingMember;
        this.currency = currency;
        this.numberOfUnits = numberOfUnits;
    }

    @Override
    public String toString() {
        return identificationNumber + " " + Arrays.toString(members) + " " + numberOfUnits + " " + currency;
    }

    public String getIdentificationNumber() {
        return identificationNumber;
    }

    public void setIdentificationNumber(String identificationNumber) {
        this.identificationNumber = identificationNumber;
    }

    public Client[] getMembers() {
        return members;
    }

    /*
    public void setMembersAccounts(Account[] membersAccounts) {
        this.membersAccounts = membersAccounts;
    }
     */

    public Currency getCurrency() {
        return currency;
    }

    public void setCurrency(Currency currency) {
        this.currency = currency;
    }

    public double getNumberOfUnits() {
        return numberOfUnits;
    }

    public void setNumberOfUnits(double numberOfUnits) {
        this.numberOfUnits = numberOfUnits;
    }

    public Transaction[] getTransactions() {
        return transactions;
    }

    /*
    public void setTransactions(Transaction[] transactions) {
        this.transactions = transactions;
    }
     */
}
