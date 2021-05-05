package streams.main;

import streams.model.*;

import java.util.*;
import java.util.function.Predicate;
import java.util.stream.Collectors;

public class Main {
    public static void main(String[] args) {
        List<Ticket> tickets = new TravelAgency().getTickets();

        System.out.println("\nNumber of tickets for Barcelona: " + getNumberOfTicketsForDestination(tickets, "Barcelona"));

        System.out.println("\nTickets of rteodorescu@gmail.com: ");
        printTicketsForEmail(tickets, "rteodorescu@gmail.com");

        System.out.println("\nDoes 'rteodorescu@gmail.com' have any tickets? ");
        System.out.println(existsTicketForEmail(tickets, "rteodorescu@gmail.com"));

        System.out.println("\nDoes 'email@yahoo.com' have tickets? ");
        System.out.println(existsTicketForEmail(tickets, "email@yahoo.com"));

        System.out.println("\nAverage value of tickets: " + getTicketsAverageValue(tickets));

        System.out.println("\nNumber of tickets for clients from Bucharest: " + getNumberOfTicketsForClientsCity(tickets, "Bucuresti"));

        System.out.println("\nDo all clients have emails? ");
        System.out.println(allClientsHaveEmail(tickets));
    }

    public static Predicate<Ticket> getTicketEmailPredicate(String email) {
        return ticket -> ticket.getClient().getEmail() != null && ticket.getClient().getEmail().equals(email);
    }

    public static long getNumberOfTicketsForDestination(List<Ticket> tickets, String destionation) {
        return tickets.stream()
                .filter(ticket -> ticket.getDestination() != null && ticket.getDestination().equals(destionation))
                .count();

    }

    public static void printTicketsForEmail(List<Ticket> tickets, String email) {
        tickets.stream()
                .filter(getTicketEmailPredicate(email))
                .forEach(ticket -> System.out.println(ticket));
    }

    public static boolean existsTicketForEmail(List<Ticket> tickets, String email) {
        return tickets.stream()
                .anyMatch(getTicketEmailPredicate(email));

        /* SAU return tickets.stream()
                        .filter(getTicketEmailPredicate(email))
                        .count()
                > 0;*/
    }

    public static double getTicketsAverageValue(List<Ticket> tickets) {
        return tickets.stream()
                .map(ticket -> ticket.getPrice())
                .reduce(0.0, (price1, price2) -> price1 + price2) / tickets.size();

        /*SAU return tickets.stream()
                .mapToDouble(ticket -> ticket.getPrice())
                .average()
                .getAsDouble();*/
    }

    public static long getNumberOfTicketsForClientsCity(List<Ticket> tickets, String city) {
        return tickets.stream()
                .filter(ticket -> ticket.getClient().getAddress() != null && ticket.getClient().getAddress().contains(city))
                .count();
    }

    public static boolean allClientsHaveEmail(List<Ticket> tickets) {
        return tickets.stream()
                .allMatch(ticket -> ticket.getClient().getEmail() != null &&
                                    !ticket.getClient().getEmail().isEmpty());
    }

}
