package model;

public class Equipment extends Product {
    private String supplierName;
    private String supplierCountry;

    public Equipment(long id, String name, double price, int stock, String supplierName, String supplierCountry) {
        super(id, name, price, stock);
        this.supplierName = supplierName;
        this.supplierCountry = supplierCountry;
    }

    @Override
    public String toString() {
        return "Equipment{" +
                "supplierName='" + supplierName + '\'' +
                ", supplierCountry='" + supplierCountry + '\'' +
                ", id=" + id +
                ", name='" + name + '\'' +
                ", price=" + price +
                ", stock=" + stock +
                '}';
    }

    public String getSupplierName() {
        return supplierName;
    }

    public void setSupplierName(String supplierName) {
        this.supplierName = supplierName;
    }

    public String getSupplierCountry() {
        return supplierCountry;
    }

    public void setSupplierCountry(String supplierCountry) {
        this.supplierCountry = supplierCountry;
    }
}
