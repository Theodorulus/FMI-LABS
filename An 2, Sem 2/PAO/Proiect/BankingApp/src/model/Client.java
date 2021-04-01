package model;

import java.util.Arrays;

public abstract class Client {
    protected String email;
    protected String phoneNumber;
    protected Account[] accounts = new Account[10];
    protected Vault[] vaults = new Vault[10];

    public Client() {

    }

    public Client(String email, String phoneNumber) {
        this.email = email;
        this.phoneNumber = phoneNumber;
    }

    @Override
    public boolean equals(Object obj) {
        return super.equals(obj);
    }

    @Override
    public String toString() {
        return "";
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public Account[] getAccounts() {
        return accounts;
    }

    public Vault[] getVaults() {
        return vaults;
    }

    /*
    public void setVaults(Vault[] vaults) {
        this.vaults = vaults;
    }
    */

    public void setAccounts(Account[] accounts) {
        this.accounts = accounts;
    }

    public String getName() {
        return "";
    }

}
