package coffee.exceptions;

/**
 * Created by hasan on 17.11.2016.
 */
public class InvalidTokenException extends Exception {
    public InvalidTokenException(){
        super("Invalid Token found in string");
    }

    public InvalidTokenException(String message){
        super(message);
    }

    public InvalidTokenException(String token, int index){
        super("Invalid match found in "+token+" at "+index+".index");
    }
}
