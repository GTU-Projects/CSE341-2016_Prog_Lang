package coffee.datatypes;

/**
 * Created by ft on 10/15/15.
 */
public class Operator implements Token{
    private String mOperator;


    public Operator(String operator) {
        mOperator = operator;
    }

    @Override
    public String getTokenName() {
        return "Operator";
    }

    @Override
    public Type getTokenType() {
        return Type.OPERATOR;
    }

    public String getOperator() {
        return mOperator;
    }

    public void setOperator(String operator) {
        this.mOperator = operator;
    }

    @Override
    public String toString() {
        return getTokenName()+"_"+getOperator();
    }
}
