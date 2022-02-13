public class IfSwitch {
    /*
        Structuri decizionare:
            if
            switch
    */
    public static void main(String[] args){
        int x = 15;

        if (x % 2 == 0){
            System.out.println("x este par");
        } else {
            System.out.println("x este impar");
        }

        String zi = "m";

        switch (zi) {
            case "luni":
                System.out.println("azi e luni");
                break;
            case "marti":
                System.out.println("azi e marti");
                break;
            default: System.out.println("azi e alta zi");
        }

        int a = 10;
        int b = a > 0 ? a : 0; // if (a > 0){ b = a; } else { b = 0; }
        System.out.println(b);
    }
}
