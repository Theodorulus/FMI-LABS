package service;

import model.*;

public class ShopService {
    private NotificationService notificationService;

    public ShopService(NotificationService notificationService) {
        this.notificationService = notificationService;
    }

    public void addProduct (Shop shop, Product product) {
        shop.addProduct(product);

        String message = "Product " + product.getName() + " was added to the shop";
        Receiver receiver = new Receiver("John", "john@gmail.com");
        notificationService.sendNotification(new Notification( message, "office@shop.com", receiver));
    }

    public void viewProducts(Shop shop) {
        Product products[] = shop.getProducts();
        for (int i = 0; i < shop.getN(); i++){
            System.out.println(products[i]);
        }
        if(shop.getN() == 0){
            System.out.println("No products.");
        }
    }
}
