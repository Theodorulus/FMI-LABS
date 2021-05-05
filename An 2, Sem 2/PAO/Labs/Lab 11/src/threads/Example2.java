package threads;

public class Example2 {
    public static void main(String[] args) {
        System.out.println(Thread.currentThread().getName() + " hello");

        new Thread(() -> {
            System.out.println(Thread.currentThread().getName());
            for(int i = 1; i <= 20; i++) {
                System.out.println(i);
            }
        }).start();

        System.out.println(Thread.currentThread().getName() + " bye");
    }
}

