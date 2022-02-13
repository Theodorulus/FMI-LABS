package threads;

import static threads.Example4.numbers;

public class ConsumerTask implements Runnable {
    @Override
    public void run() {
        while(true) {
            synchronized (numbers) {
                if (!numbers.isEmpty()) {
                    int number = numbers.get(0);
                    numbers.remove(0);
                    System.out.println(Thread.currentThread().getName() + " has removed " + number);
                    numbers.notifyAll();
                } else {
                    try {
                        numbers.wait();
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                    System.out.println("The list is already empty.");
                }
            }
        }
    }
}
