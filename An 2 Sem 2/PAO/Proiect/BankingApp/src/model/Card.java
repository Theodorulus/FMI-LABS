package model;

public abstract class Card {
    protected String cardNumber;
    protected ExpirationDate expirationDate;
    protected String holderName;
    protected String cvv;
    protected Account account;
    protected boolean frozen;

    public Card(String cardNumber, ExpirationDate expirationDate, String holderName, String cvv, Account account, boolean frozen) {
        this.cardNumber = cardNumber;
        this.expirationDate = expirationDate;
        this.holderName = holderName;
        this.cvv = cvv;
        this.account = account;
        this.frozen = frozen;
    }

    public String getCardNumber() {
        return cardNumber;
    }

    public void setCardNumber(String cardNumber) {
        this.cardNumber = cardNumber;
    }

    public ExpirationDate getExpirationDate() {
        return expirationDate;
    }

    public void setExpirationDate(ExpirationDate expirationDate) {
        this.expirationDate = expirationDate;
    }

    public String getHolderName() {
        return holderName;
    }

    public void setHolderName(String holderName) {
        this.holderName = holderName;
    }

    public String getCvv() {
        return cvv;
    }

    public void setCvv(String cvv) {
        this.cvv = cvv;
    }

    public Account getAccount() {
        return account;
    }

    public void setAccount(Account account) {
        this.account = account;
    }

    public boolean isFrozen() {
        return frozen;
    }

    public void setFrozen(boolean frozen) {
        this.frozen = frozen;
    }

    @Override
    public String toString() {
        return cardNumber + ", Expiring at " + expirationDate;
    }
}
