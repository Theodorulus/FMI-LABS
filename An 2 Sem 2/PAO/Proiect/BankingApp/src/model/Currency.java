package model;

public class Currency {
    private String currencyName;
    private double valueDependingOnDollar;

    public Currency() {
        this.valueDependingOnDollar = 1.0;
        this.currencyName = "USD";
    }

    public Currency(String currencyName, double valueDependingOnDollar) {
        this.valueDependingOnDollar = valueDependingOnDollar;
        this.currencyName = currencyName;
    }

    @Override
    public String toString() {
        return currencyName;
    }

    public String getCurrencyName() {
        return currencyName;
    }

    public void setCurrencyName(String currencyName) {
        this.currencyName = currencyName;
    }

    public double getValueDependingOnDollar() {
        return valueDependingOnDollar;
    }

    public void setValueDependingOnDollar(double valueDependingOnDollar) {
        this.valueDependingOnDollar = valueDependingOnDollar;
    }
}
