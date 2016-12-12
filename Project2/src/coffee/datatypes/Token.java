package coffee.datatypes;

/**
 * Created by ft on 10/8/15.
 */
public interface Token {

    /**
     * Token types
     */
    public static enum Type {
        IDENTIFIER,
        OPERATOR,
        BINARY_VALUE,
        INTEGER_VALUE,
        KEYWORD
    }

    /**
     * Returns token's name. Eg: Identifier
     * @return token's name
     */
    public String getTokenName();

    public Type getTokenType();

}
