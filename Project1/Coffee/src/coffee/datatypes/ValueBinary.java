package coffee.datatypes;

/**
 * Created by ft on 10/2/15.
 */
public class ValueBinary implements Value {
    private Boolean mValue = null;

    public ValueBinary() {}

    public ValueBinary(boolean value) {
        this.mValue = value;
    }

    @Override
    public Type getType() {
        return Type.BOOLEAN;
    }

    @Override
    public Boolean getValue() {
        return mValue;
    }

    @Override
    public String getTokenName() {
        return "VALUE_BINARY";
    }

    @Override
    public Token.Type getTokenType() {
        return Token.Type.BINARY_VALUE;
    }

    @Override
    public String toString() {
        return getTokenName()+"_"+getValue();
    }
}
