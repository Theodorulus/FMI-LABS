package model;

import java.util.Date;

public class BuyingTransaction extends Transaction {
    private Card senderCard;
    private Company destinationCompany;


    public BuyingTransaction(double value, String status, Date time, Card senderCard, Company destinationCompany) {
        super(value, status, time);
        this.destinationCompany = destinationCompany;
        this.senderCard = senderCard;
    }

    public Company getDestinationCompany() {
        return destinationCompany;
    }

    public void setDestinationCompany(Company destinationCompany) {
        this.destinationCompany = destinationCompany;
    }

    public Card getSenderCard() {
        return senderCard;
    }

    public void setSenderCard(Card senderCard) {
        this.senderCard = senderCard;
    }

    /*
    public double getValue() {
        return value;
    }

    public void setValue(double value) {
        this.value = value;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getTime() {
        return time;
    }

    public void setTime(Date time) {
        this.time = time;
    }
    */
}
