package test;

import jdk.swing.interop.SwingInterOpUtils;

import java.util.HashMap;

class Fir extends Thread{
    int nivel;
    static int numar = 0;
    public Fir(int n){nivel=n;}
    public void run(){
        System.out.print(nivel+" ");
        if (nivel<3){
            Fir fir = new Fir(nivel+1);
            fir.start();
        }
        if (nivel<100000){
            Fir fir = new Fir(nivel+1);
            fir.start();
        }
    }
}
public class Test {
    public static void main(String[] args) {
        Fir fir = new Fir(0);
        fir.start();
    }
}