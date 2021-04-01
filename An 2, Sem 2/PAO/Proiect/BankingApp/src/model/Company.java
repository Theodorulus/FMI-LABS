package model;

public class Company extends Client {
    private String fiscalCode;
    private String companyName;

    public Company() {
    }

    public Company(String email, String phoneNumber, String fiscalCode, String companyName) {
        super(email, phoneNumber);
        this.fiscalCode = fiscalCode;
        this.companyName = companyName;
    }

    @Override
    public String toString() {
        return companyName ;
    }

    @Override
    public boolean equals(Object obj) {
        return super.equals(obj);
    }

    @Override
    public String getName(){
        return companyName;
    }

    public String getFiscalCode() {
        return fiscalCode;
    }

    public void setFiscalCode(String fiscalCode) {
        this.fiscalCode = fiscalCode;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    /*
    @Override
    public String getEmail() {
        return email;
    }

    @Override
    public void setEmail(String email) {
        this.email = email;
    }

    @Override
    public String getPhoneNumber() {
        return phoneNumber;
    }

    @Override
    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    @Override
    public Account[] getAccounts() {
        return accounts;
    }


    @Override
    public void setAccounts(Account[] accounts) {
        this.accounts = accounts;
    }
     */
}
