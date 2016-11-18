package coffee.exceptions;

/**
 * Created by hasan on 18.11.2016.
 */
public class UnresolvedCharacterException extends Exception {
    public UnresolvedCharacterException(){
        super("Unresolved Character Founded");
    }

    public UnresolvedCharacterException(String str,char ch,int index){
        super("Unresolved Character ' "+ch+" ' Founded in "+str+" at "+index+".index");
    }
}
