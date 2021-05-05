package model;

public enum BankAccountStatus {
    OPEN("bank account is open"),
    CLOSED("bank account is closed"),
    SUSPENDED("bank account is closed");

    private String description;

    private BankAccountStatus(String description) {
        this.description = description;
    }

    public String getDescription() {
        return description;
    }

    public void hello() { // -> de-obicei nu se prea folosesc metode in enum-uri
        //do something
    }
}
