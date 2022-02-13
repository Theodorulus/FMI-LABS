package model;

public class Shop {
    Product[] products = new Product[100];

    /*public Shop(Product[] products) {
        this.products = products;
    }*/

    public Product[] getProducts() {
        return products;
    }

    public void setProducts(Product[] products) {
        this.products = products;
    }
}
