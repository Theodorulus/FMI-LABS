package logging;

public class Main {
    public static void main(String[] args) {
        //1st way to obtain an instance of an interface:

        //Logger logger = new Logger(); -> nu merge
        MyFileLogger myFileLogger = new MyFileLogger();
        myFileLogger.log("There was a NullPointer exception in the main method");
        myFileLogger.logInfo("The main method was called");
        myFileLogger.logInfo("The app crashed");

        //2nd way to obtain an instance of an interface - lambda expressions:
        //functional interface = an interface with only one abstract method

    }
}
