public class ForWhile {
    /*
        while
        do while
        for
    */
    public static void main(String[] args) {
        int n = 10;
        int factorial1 = 1;
        for (int i = 1; i <= n; i++) {
            factorial1 *= i;
        }

        System.out.println("Factorial = " + factorial1);

        int factorial2 = 1;
        while (n > 0) {
            factorial2 *= n--;
        }
        System.out.println("Factorial = " + factorial2);

        n = 10;

        int factorial3 = 1;
        do {
            factorial3 *= n--;
        } while(n > 0);

        System.out.println("Factorial = " + factorial3);

        if (factorial1 == factorial2 && factorial2 == factorial3) {
            System.out.println("Sunt egale ");
        }
        /*
        for(;;) -> ruleaza si creaza bucla infinita
        */

    }
}
