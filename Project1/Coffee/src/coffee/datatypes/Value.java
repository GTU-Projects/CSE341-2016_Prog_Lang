package coffee.datatypes;

/**
 * Variable Interface.
 * All variable classes should implement this interface.
 * Created by ft on 10/2/15.
 */
public interface Value extends Token {

    /**
     * Type of a variable
     */
    public static enum Type {
        INTEGER,
        BOOLEAN
    };

    /**
     * Returns the type of a variable
     * @return variable type
     */
    public Type getType();

    /**
     * Returns the variable's value
     * @return variable's value
     */
    public Object getValue();
}
