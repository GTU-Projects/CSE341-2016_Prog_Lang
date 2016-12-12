package coffee;

import coffee.project.Parser;

import java.io.File;
import java.util.Scanner;

/**
 * Read-Eval-Print loop.
 * Created by ft on 10/2/15.
 */
public final class REPL {
    private static Scanner input = new Scanner(System.in);
    private static final String CARET  = "> ";
    private static final String INDENT = "  ";
    private static final String HELLO =
    " _______ _______ _     _    _______  ______ _______ ______  _     _ ___   \n" +
    "(_______|_______|_)   (_)  (_______)/ _____|_______|_____ \\| |   (_|___)  \n" +
    " _   ___    _    _     _    _      ( (____  _____   _____) ) |_____   _   \n" +
    "| | (_  |  | |  | |   | |  | |      \\____ \\|  ___) (_____ (|_____  | | |  \n" +
    "| |___) |  | |  | |___| |  | |_____ _____) ) |_____ _____) )     | |_| |_ \n" +
    " \\_____/   |_|   \\_____/    \\______|______/|_______|______/      |_(_____)\n" +
    "                                                                          ";


    private REPL(){}

    public static String getString() {
        return getString(null);
    }

    /**
     * Get String line from Console.
     *
     * @param prompt
     *            Instructions and prompt for the user.
     * @return Raw String from user.
     */
    public static String getString(String prompt) {
        // Display instructions and prompt
        while (true) {
            if(prompt != null)
                System.out.println(INDENT+prompt);
            System.out.print(CARET);
            String inputStr = input.nextLine();

            // Avoiding blank lines
            if (inputStr.trim().isEmpty()) {
                System.out.println(INDENT+"Input must not be blank.\n");
                return inputStr;
            }

            return inputStr;
        }
    }

    public static void repl(String filePath) {
        File file = new File(filePath);
        if(!file.exists()) {
            System.err.println("Unable to open file: "+filePath);
            System.exit(2);
        }

    }

    public static void repl(LineInputCallback callback) {

        // Ctrl-C handler
        Runtime.getRuntime().addShutdownHook(new Thread() {
            public void run() {
                System.out.println("\nBye-Bye");
            }
        });


        System.out.println(HELLO);

        String line;
        String prompt = null;

        while(true) {
            line = getString(prompt);
            if(line.equals("(quit)"))
                break;
            try {
                prompt = callback.lineInput(line);
            } catch (InvalidSyntaxException exc) {
                System.err.println("Invalid syntax!");
                exc.printStackTrace();
            }
        }

        Parser p = new Parser();
        p.parse();
    }

    public static interface LineInputCallback {
        /**
         * This function is a callback function
         * for every user input on REPL. You should
         * return prompt for user. If there is no prompt,
         * return null.
         *
         * @param line User input
         * @return Prompt or null
         */
        public String lineInput(String line) throws InvalidSyntaxException;
    }

    public static class InvalidSyntaxException extends Exception {
    }
}
