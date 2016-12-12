package coffee.datatypes;

/**
 * Created by ft on 10/8/15.
 */
public class Identifier implements Token{
    private String mName;

    public Identifier(String mName) {
        this.mName = mName;
    }

    @Override
    public String getTokenName() {
        return "IDENTIFIER";
    }

    @Override
    public Type getTokenType() {
        return Type.IDENTIFIER;
    }

    public String getName() {
        return mName;
    }

    public void setName(String name) {
        this.mName = name;
    }


    @Override
    public String toString() {
        return getTokenName()+"_"+getName();
    }
}
