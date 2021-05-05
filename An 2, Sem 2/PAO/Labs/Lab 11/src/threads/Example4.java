package threads;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class Example4 {
    public static List<Integer> numbers = new ArrayList<>();

    public static void main(String[] args) {
        //Producer - Consumer
        ExecutorService executorService = Executors.newCachedThreadPool();
        executorService.submit(new ProducerTask());
        executorService.submit(new ConsumerTask());
        executorService.submit(new ProducerTask());
        executorService.submit(new ConsumerTask());
    }
}
