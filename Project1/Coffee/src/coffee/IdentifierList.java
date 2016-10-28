package coffee;

import java.util.ArrayList;
import java.util.List;

/**
 * Holds all the identifiers with unique names.
 * Created by ft on 10/2/15.
 */
public class IdentifierList {
    private static int mIdCount = 0;
    private static List<String> mIdentifiers = new ArrayList<String>();
    private static final IdentifierList INSTANCE = new IdentifierList();

    private IdentifierList() {}

    public static IdentifierList getInstance(){
        return INSTANCE;
    }

    /**
     * Initializes a identifier with null value.
     * @param name identifier's name
     * @return identifier's name in identifier list.
     */
    public String addIdentifier(String name) {
        String varName = mIdCount +"_"+name;
        ++mIdCount;
        mIdentifiers.add(varName);
        return varName;
    }

    public List<String> getIdentifiers() {
        return mIdentifiers;
    }

}
