package model;

import java.util.Date;

public class Transfer extends Transaction {
    private Account senderAccount;
    private Client destionationClient;
    private String message;

    public Transfer(double value, String status, Date time, Account senderAccount, Client destionationClient, String message) {
        super(value, status, time);
        this.destionationClient = destionationClient;
        this.senderAccount = senderAccount;
        this.message = message;
    }

    @Override
    public String toString() {
        return "Transfer{" +
                "value=" + value +
                ", status='" + status + '\'' +
                ", time=" + time +
                ", senderAccount=" + senderAccount +
                ", destionationClient=" + destionationClient +
                ", message='" + message + '\'' +
                '}';
    }

    public Client getDestionationClient() {
        return destionationClient;
    }

    public void setDestionationClient(Client destionationClient) {
        this.destionationClient = destionationClient;
    }

    public Account getSenderAccount() {
        return senderAccount;
    }

    public void setSenderAccount(Account senderAccount) {
        this.senderAccount = senderAccount;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
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
    }*/

}
