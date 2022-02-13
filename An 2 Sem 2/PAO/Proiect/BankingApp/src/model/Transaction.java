package model;

import java.util.Date;

public abstract class Transaction {
    protected double value;
    protected String status;
    protected Date time;

    public Transaction(double value, String status, Date time) {
        this.value = value;
        this.status = status;
        this.time = time;
    }

    @Override
    public String toString() {
        return "";
    }

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
}
