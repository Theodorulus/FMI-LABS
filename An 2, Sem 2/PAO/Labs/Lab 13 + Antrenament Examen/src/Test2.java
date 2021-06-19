class A {
    public static void metoda(String s) {
        System.out.println("A" + s);
    }
}

class B extends A {
    public static void metoda (String s) {
        System.out.println("B" + s);
    }
    public void metoda (String s, String t) {
        System.out.println("B" + s + t);
    }
}

public class Test2 {
    public static void main(String[] args) {
        A ob = new B();
        ob.metoda("P");
        //ob.metoda("Q", "R");
    }
}