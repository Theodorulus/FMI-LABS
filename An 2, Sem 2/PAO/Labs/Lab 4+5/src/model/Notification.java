package model;

public final class Notification {
    private final String message;
    private final String from;
    private final Receiver receiver;

    public Notification(String message, String from, Receiver receiver) {
        this.message = message;
        this.from = from;
        //this.receiver = receiver; -> nu vrem sa copiem direct referinta
        Receiver receiverClone = new Receiver(receiver.getName(), receiver.getEmail());
        this.receiver = receiverClone;
    }

    public String getMessage() {
        return message;
    }

    public String getFrom() {
        return from;
    }

    public Receiver getReceiver() {
        return receiver;
    }

    @Override
    public String toString() {
        return "Notification{" +
                "message='" + message + '\'' +
                ", from='" + from + '\'' +
                ", receiver=" + receiver +
                '}';
    }
}
