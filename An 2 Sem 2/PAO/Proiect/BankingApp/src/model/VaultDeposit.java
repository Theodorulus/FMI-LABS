package model;

import java.util.Date;

public class VaultDeposit extends Transaction {
    private Account senderAccount;
    private Vault destionationVault;

    public VaultDeposit( double value, String status, Date time, Account senderAccount, Vault destionationVault) {
        super(value, status, time);
        this.destionationVault = destionationVault;
        this.senderAccount = senderAccount;
    }

    @Override
    public String toString() {
        return "VaultDeposit{" +
                "value=" + value +
                ", status='" + status + '\'' +
                ", time=" + time +
                ", destionationVault=" + destionationVault +
                '}';
    }

    public Vault getDestionationVault() {
        return destionationVault;
    }

    public void setDestionationVault(Vault destionationVault) {
        this.destionationVault = destionationVault;
    }

    public Account getSenderAccount() {
        return senderAccount;
    }

    public void setSenderAccount(Account senderAccount) {
        this.senderAccount = senderAccount;
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
