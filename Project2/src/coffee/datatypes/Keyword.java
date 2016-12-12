package coffee.datatypes;

/**
 * Created by ft on 10/15/15.
 */
public class Keyword implements Token {
    private String mKeyword;

    public Keyword() {

    }

    public Keyword(String keyword) {
        this.mKeyword = keyword;
    }

    @Override
    public String getTokenName() {
        return "Keyword";
    }

    @Override
    public Type getTokenType() {
        return Type.KEYWORD;
    }

    public String getKeyword() {
        return mKeyword;
    }

    public void setKeyword(String keyword) {
        this.mKeyword = keyword;
    }

    @Override
    public String toString() {
        return getTokenName()+"_"+getKeyword();
    }
}
