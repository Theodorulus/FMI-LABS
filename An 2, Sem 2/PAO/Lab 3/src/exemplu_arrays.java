public class exemplu_arrays {
    public static void main(String[] args) {
        int[] v = new int[7];
        v[0] = 10;
        v[1] = 15;
        v[3] = 10;

        for(int i = 0; i < v.length; i++) {
            System.out.print(v[i] + " ");
        }

        System.out.println();

        for(int i : v){
            System.out.print(i + " ");
        }

        String[] words = new String[2];

        for(String i : words){
            System.out.print(i + " ");
        }

        int[][] m = new int[3][5];

    }
}
