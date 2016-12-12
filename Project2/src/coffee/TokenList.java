package coffee;

import coffee.datatypes.Token;

import java.util.ArrayList;
import java.util.List;

/**
 * Singleton token list.
 * Created by ft on 10/8/15.
 */
public class TokenList {
    private List<Token> mTokens = new ArrayList<Token>();

    private static final TokenList INSTANCE = new TokenList();

    private TokenList() {}

    public static TokenList getInstance(){
        return INSTANCE;
    }

    /**
     * Adds a token.
     * @param token
     */
    public void addToken(Token token) {
        mTokens.add(token);
    }

    /**
     * Returns all tokens
     * @return all tokens
     */
    public List<Token> getAllTokens() {
        return mTokens;
    }

}
