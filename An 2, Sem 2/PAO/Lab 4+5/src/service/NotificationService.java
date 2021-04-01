package service;

import model.Notification;

public class NotificationService {
    public void sendNotification (Notification notification){
        System.out.println("Notification <" + notification.getMessage() + "> successfully sent to " + notification.getReceiver().getEmail());
    }
}
