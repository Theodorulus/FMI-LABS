package threads;

public class Example1 {
    public static void main(String[] args) {
        System.out.println(Thread.currentThread().getName() + " hello");

        PrintNumbersThread thread = new PrintNumbersThread(); // thread is in "new" status
        thread.start(); // runnable -> running

        System.out.println(Thread.currentThread().getName() + " bye");
    }
}
