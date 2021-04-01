package main;

import java.util.Objects;
import java.util.Random;
import java.util.Scanner;
import model.*;
import service.NotificationService;
import service.ShopService;

public class Application {
    public static void main (String[] args) {
        app();
    }

    public static void app() {
        Shop shop = new Shop();
        ShopService shopService = new ShopService(new NotificationService());

        Scanner scanner = new Scanner(System.in);

        String command = "";
        while (true) {
            System.out.println();
            System.out.println("Please type command: ");
            command = scanner.nextLine();
            switch(command) {
                case "add" :
                    System.out.println("Please choose a product type (bicycle / car / equipment):");
                    String productType = scanner.nextLine();
                    System.out.println("Please specify the product details:");
                    switch(productType) {
                        case "bicycle" : {
                            String productDetails = scanner.nextLine();
                            String[] attributes = productDetails.split("/");
                            String name = attributes[0];
                            double price = Double.valueOf(attributes[1]);
                            int stock = Integer.valueOf(attributes[2]);
                            String model = attributes[3];
                            boolean limitedEdition = Boolean.valueOf(attributes[4]);
                            int height = Integer.valueOf(attributes[5]);
                            Product product = new Bicycle(new Random().nextInt(100), name, price, stock, model, limitedEdition, height);
                            shopService.addProduct(shop, product);
                            break;
                        }
                        case "car" : {
                            String productDetails = scanner.nextLine();
                            String[] attributes = productDetails.split("/");
                            String name = attributes[0];
                            double price = Double.valueOf(attributes[1]);
                            int stock = Integer.valueOf(attributes[2]);
                            String model = attributes[3];
                            boolean limitedEdition = Boolean.valueOf(attributes[4]);
                            String color = attributes[5];
                            String transmission = attributes[6];
                            int power = Integer.valueOf(attributes[7]);
                            int numberOfCylinders = Integer.valueOf(attributes[8]);
                            Engine engine = new Engine(transmission, power, numberOfCylinders);
                            Product product = new Car(new Random().nextInt(100), name, price, stock, model, limitedEdition, color, engine);
                            shopService.addProduct(shop, product);
                            break;
                        }
                        case "equipment" : {
                            String productDetails = scanner.nextLine();
                            String[] attributes = productDetails.split("/");
                            String name = attributes[0];
                            double price = Double.valueOf(attributes[1]);
                            int stock = Integer.valueOf(attributes[2]);
                            String supplierName = attributes[3];
                            String supplierCountry = attributes[4];
                            Product product = new Equipment(new Random().nextInt(100), name, price, stock, supplierName, supplierCountry);
                            shopService.addProduct(shop, product);
                            break;
                        }
                        default :
                            System.out.println("This type of product doesn't exist!");
                            break;
                    }
                    break;
                case "view" :
                    shopService.viewProducts(shop);
                    break;
                case "exit" :
                    System.out.println("Good bye!");
                    System.exit(0);
                    break;
                default :
                    System.out.println("Command doesn't exist!");
            }
        }
    }

}
