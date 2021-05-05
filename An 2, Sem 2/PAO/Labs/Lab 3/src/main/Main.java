package main;

import model.*; // toate clasele din pachetul model
import service.ShopService;

public class Main {
    public static void main (String[] args) {
        //test();
        ShopService shopService = new ShopService();
        Shop shop = new Shop();
        Product product = new Product ("pen");
        shopService.printProducts(shop);
    }

    public static void test () {
        Product p = new Product();
        System.out.println(p.getId());
        System.out.println(p.getName());
        System.out.println(p.getPrice());
        System.out.println(p.isInStock());

        //3. modificare cu set

        Product p1 = new Product("telefon");
        System.out.println(p1.getName());
        System.out.println();
    }
}
