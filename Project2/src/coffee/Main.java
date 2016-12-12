package coffee;

import coffee.datatypes.Token;
import coffee.project.Lexer;

import java.io.*;

/**
 * Created by ft on 10/2/15.
 */
public class Main {

    public static void main(String[] args) {
        Lexer lexer = new Lexer();
        if(args.length > 1) { // invalid input
            error();
        } else if(args.length == 1) { // file input provided
            System.out.println("Reading file: "+args[0]);
            BufferedReader br = null;
            try {
                br = new BufferedReader(new FileReader(new File(args[0])));
                String line = null;
                while ((line = br.readLine()) != null) {
                    System.out.println(line);
                    lexer.lineInput(line);
                }
            } catch (Exception e) {
                System.err.println("Unable to read file: "+args[0]);
            } finally {
                try {
                    if(br != null)
                        br.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

        REPL.repl(lexer);
    }

    private static void usage() {
        System.out.println("Usage: [INPUT FILE] or no parameter");
    }

    private static void error() {
        System.err.println("Invalid parameters.");
        usage();
        System.exit(1);
    }
}
