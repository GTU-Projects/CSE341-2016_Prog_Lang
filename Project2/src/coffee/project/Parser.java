package coffee.project;

import coffee.IdentifierList;
import coffee.TokenList;
import coffee.datatypes.*;

import java.util.Collections;
import java.util.Stack;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by ftektas on 12/12/16.
 */
public class Parser {
    // Parses the lexer result and prints *ONLY* the parsing result.

    private final String EXPI_EXPRESSION="(\\((\\+|\\-|\\*|\\/) EXPI EXPI\\))|(Id)|(IntegerValue)|(\\(Id EXPLISTI\\))";
    private final String EXPB_EXPRESSION="(\\((and|or|equal) EXPB EXPB\\)|\\(equal EXPI EXPI\\)|BinaryValue|\\(not EXPB\\))";
    private final String EXPLISTI="(\\(concat EXPLISTI EXPLISTI\\)|\\(append EXPI EXPLISTI\\)|LISTVALUE|null)";
    private final String EXPI_ASSINGMENT="(\\(set Id EXPI\\))";
    private final String EXPI_FUNC="(\\(deffun Id IDLIST EXPLISTI\\))";
    private final String EXPI_IDLIST="empty"; // TODO: EMPTY
    private final String EXPI_FUNC_CALL="(\\(Id EXPLISTI\\))";
    private final String EXPI_IF="(\\(if EXPB (then EXPLISTI else EXPLISTI|EXPLISTI|EXPLISTI EXPLISTI)\\))";
    private final String EXPB_WHILE="(\\(while \\(EXPB\\) EXPLISTI\\))";
    private final String EXPB_FOR="(\\(for \\(Id EXPI EXPI\\) EXPLISTI\\))";
    private Matcher matcher;
    private Stack<String> reducedStack = new Stack<>();
    private Stack<Token> tokenStack = new Stack<>();


    public Parser(){}// TODO: belki patternler buraya gelebilir

    public void parse() {
        IdentifierList identifierList = IdentifierList.getInstance();
        TokenList tokenList = TokenList.getInstance();


        tokenStack.addAll(tokenList.getAllTokens());
        Collections.reverse(tokenStack);

        System.out.println("Token Stack:"+tokenStack);
        while(!tokenStack.empty()){
            // eger stack reduce edilebilir ise reduce et
            reduceStack();
            reducedStack.push(tokenStack.pop().getTokenVal());
            System.out.println("Stack : "+reducedStack.toString());
        }
        /*boolean res = canReduce("(/ EXPI EXPI)",EXPI_EXPRESSION);
        boolean res2 = canReduce("(or EXPB EXPB)",EXPB_EXPRESSION);
        System.out.println("Res1:"+res+" Res2:"+res2);*/

        /*for(Token t: tokenList.getAllTokens()){
            String item=null;
            if(t instanceof Operator)
                item = ((Operator)t).getOperator();
            else if (t instanceof Keyword)
                item = ((Keyword)t).getKeyword();
            else if (t instanceof Identifier)
                item = ((Identifier)t).getName();
            else if(t instanceof ValueBinary)
                item = ((ValueBinary)t).getValue().toString();
            else if(t instanceof ValueInt)
                item=((ValueInt)t).getValue().toString();
            stack.push(item);
            //System.out.println("Parse Stack:"+stack.toString());
        }*/
    }

    private void reduceStack(){
        // eger bos ise direk don ve elemanı eklet
        if(reducedStack.empty())
            return;

        String pk = reducedStack.peek();
        if(canReduce(pk,EXPI_EXPRESSION)){
            String temp = "EXPI";
            reducedStack.pop();
            reducedStack.push(temp);
            System.out.println("New Stack:"+reducedStack.toString());
        }
    }


    private boolean isInput(String str){
        if(str.equals("EXPI")| str.equals("EXPILISI"))
            return true;
        return false;
    }

    private boolean canReduce(String str,String pattern){
        boolean result=false;
        Pattern r= Pattern.compile(pattern);
        Matcher matcher=r.matcher(str);
        return matcher.find();
    }
}
