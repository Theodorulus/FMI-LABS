package logging;

public class DBLogger implements Logger {

    @Override
    public boolean isDebugEnabled() {
        return true;
    }

    @Override
    public void log(String message) {
        //logging in a database
    }
}
