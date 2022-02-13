package model;

public class Account {
    private String iban;
    private Client client;
    private Currency currency;
    private double numberOfUnits;
    private Card[] cards = new Card[10];
    private Transaction[] transactions = new Transaction[50];

    public Account(String iban, Client client, Currency currency, double numberOfUnits) {
        this.iban = iban;
        this.client = client;
        this.currency = currency;
        this.numberOfUnits = numberOfUnits;
    }

    @Override
    public String toString() {
        return iban + "; " + numberOfUnits + " " + currency;
    }

    public String getIban() {
        return iban;
    }

    public void setIban(String iban) {
        this.iban = iban;
    }

    public Client getClient() {
        return client;
    }

    public void setClient(Client client) {
        this.client = client;
    }

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

    public Card[] getCards() {
        return cards;
    }

    /*
    public void setCards(Card[] cards) {
        this.cards = cards;
    }
    */

    public Transaction[] getTransactions() {
        return transactions;
    }

    /*
    public void setTransactions(Transaction[] transactions) {
        this.transactions = transactions;
    }
     */
}
