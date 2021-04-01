package main;

import model.Notification;
import model.Receiver;

public class ExampleImmutable {
    public static void main (String[] args) {
        String message = "Product MTB was added to the shop";
        Receiver receiver = new Receiver("John", "john@gmail.com");
        Notification notification = new Notification( message, "office@shop.com", receiver);

        System.out.println(notification.getReceiver());
        receiver.setEmail("test");
        System.out.println(notification.getReceiver());

    }
}
