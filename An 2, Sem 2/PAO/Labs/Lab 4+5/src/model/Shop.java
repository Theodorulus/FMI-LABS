package model;

public class Shop {
    private Product[] products = new Product[10];

    public Product[] getProducts() {
        return products;
    }

    public void setProducts(Product[] products) {
        this.products = products;
    }

    public void addProduct(Product product) {
        for(int i = 0; i < products.length; i++){
            if (products[i] == null) {
                products[i] = product;
                break;
            }
        }
    }

    public int getN(){
        for(int i = 0; i < products.length; i++){
            if (products[i] == null) {
                return i;
            }
        }
        return products.length;
    }
}
