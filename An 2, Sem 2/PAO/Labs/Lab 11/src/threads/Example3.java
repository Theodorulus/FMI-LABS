package threads;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class Example3 {
    public static void main(String[] args) {
        ExecutorService executorService = Executors.newCachedThreadPool();
        executorService.submit(() -> {
            System.out.println(Thread.currentThread().getName());
            for(int i = 1; i <= 20; i++) {
                System.out.println(i);
            }
        });
    }
}
