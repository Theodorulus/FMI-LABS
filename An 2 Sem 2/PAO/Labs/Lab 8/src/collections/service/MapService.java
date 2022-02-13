package collections.service;

import java.util.HashMap;
import java.util.Map;

public class MapService {
    /*

        Collections Framework
        Map<K, V>
            HashMap<K, V>
            LinkedHashMap<K, V>
            TreeMap<K, V>

    */

    public static void main(String[] args) {
        Map<String, Integer> cities = new HashMap<>();
        cities.put("Bucuresti", 2000000);
        cities.put("Timisoara", 400000);
        cities.put("Cluj", 300000);
        cities.put("Bucuresti", 2150000);
        cities.put("Constanta", 760000);

        System.out.println(cities.get("Bucuresti"));
        /*
        for(String city : cities.keySet()) {
            System.out.println(city + " has " + cities.get(city) + " habitants.");
        }
         */

        cities.forEach((key, value) -> System.out.println(key + " has " + value + " habitants."));
    }
}
