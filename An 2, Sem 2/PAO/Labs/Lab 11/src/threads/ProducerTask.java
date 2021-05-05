package threads;

import javax.management.monitor.Monitor;
import java.util.Random;

import static threads.Example4.numbers;

public class ProducerTask implements Runnable {
    @Override
    public void run() {
        Random random = new Random();
        while(true) {
            synchronized (numbers) {
                if (numbers.size() < 20) {
                    int number = random.nextInt(100);
                    numbers.add(number);
                    System.out.println(Thread.currentThread().getName() + " has added " + number);
                    numbers.notifyAll();
                } else {
                    try {
                        numbers.wait();
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                    System.out.println("The list already has 20 elements.");
                }
            }
        }
    }
}
