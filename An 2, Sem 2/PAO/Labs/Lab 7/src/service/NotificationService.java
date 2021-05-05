package service;

import model.*;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

public class NotificationService {

    /*
      IO streams
      java.io

      IN
        low level
            InputStream
            FileInputStream
            ByteArrayInputStream

        high level
            InputStreamReader
            BufferedReader
            ObjectInputStream
            DataInputStream

      OUT
        low level
            OutputStream
            FileOutputStream
            ByteArrayOutputStream

        high level
            PrintStream
            PrintWriter
            ObjectOutputStream
            DataOutputStream


     java.nio

        Files
        Path
        Paths
    */

    //TODO write the notifications in a csv file
    public void sendNotification(Notification notification) {
        System.out.println("Notification <" + notification.getMessage() + "> successfully sent to " +
                notification.getReceiver().getEmail());
    }

    public void createFolder(String folderName) throws IOException {
        Path path = Paths.get(folderName);
        Files.createDirectories(path);
    }

    public void createFile(String fileName) throws IOException {
        Path path = Paths.get(fileName);
        Files.createFile(path);
    }

    public void deleteFile(String fileName) throws IOException {
        Path path = Paths.get(fileName);
        Files.deleteIfExists(path);
    }

    public void listFolder(String folderName) throws IOException {
        Path path = Paths.get(folderName);
        Files.list(path).forEach(p -> System.out.println(p));
    }
}
