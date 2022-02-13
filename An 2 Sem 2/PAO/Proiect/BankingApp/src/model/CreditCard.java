package model;

public class CreditCard extends Card {

    public CreditCard(String cardNumber, ExpirationDate expirationDate, String holderName, String cvv, Account account, boolean frozen) {
        super(cardNumber, expirationDate, holderName, cvv, account, frozen);
    }

    public void setCardNumber(String cardNumber) {
        this.cardNumber = cardNumber;
    }

    public String getCardNumber() {
        return this.cardNumber;
    }

    public void setExpirationDate(ExpirationDate expirationDate) {
        this.expirationDate = expirationDate;
    }

    public ExpirationDate getExpirationDate() {
        return this.expirationDate;
    }

    public void setHolderName(String holderName) {
        this.holderName = holderName;
    }

    public String getHolderName() {
        return this.holderName;
    }

    public void setCVV(String cvv) {
        this.cvv = cvv;
    }

    public String getCVV() {
        return this.cvv;
    }

    public void setAccount(Account account) {
        this.account = account;
    }

    public Account getAccount() {
        return this.account;
    }

}
