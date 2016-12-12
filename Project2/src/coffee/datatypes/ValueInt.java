package coffee.datatypes;

/**
 * Created by ft on 10/2/15.
 */
public class ValueInt implements Value {
    private Integer mValue = null;

    public ValueInt() {}

    public ValueInt(int value) {
        mValue = value;
    }

    @Override
    public Type getType() {
        return Type.INTEGER;
    }

    @Override
    public Integer getValue() {
        return mValue;
    }

    @Override
    public String getTokenName() {
        return "VALUE_INT";
    }

    @Override
    public Token.Type getTokenType() {
        return Token.Type.INTEGER_VALUE;
    }

    @Override
    public String toString() {
        return getTokenName()+"_"+getValue();
    }
}
