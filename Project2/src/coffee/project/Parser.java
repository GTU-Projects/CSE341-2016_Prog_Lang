package coffee.project;

import coffee.IdentifierList;
import coffee.TokenList;
import coffee.datatypes.*;

import java.util.Collections;
import java.util.EmptyStackException;
import java.util.Stack;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by ftektas on 12/12/16.
 */
public class Parser {
    // Parses the lexer result and prints *ONLY* the parsing result.

    private final String EXPI_EXPRESSION = "(\\(\\s*(\\+|\\-|\\*|\\/) EXPI EXPI\\s*\\))|(Id)|(IntegerValue)|(\\(\\s*Id EXPLISTI\\s*\\))";
    private final String EXPB_EXPRESSION = "(\\(\\s*(and|or|equal) EXPB EXPB\\s*\\)|\\(\\s*equal EXPI EXPI\\s*\\)|BinaryValue|\\(\\s*not EXPB\\s*\\))";
    private final String EXPLISTI = "(\\(\\s*concat EXPLISTI EXPLISTI\\s*\\)|\\(\\s*append EXPI EXPLISTI\\s*\\)|LISTVALUE|null)";
    private final String EXPI_ASSINGMENT = "(\\(\\s*set Id EXPI\\s*\\))";
    private final String EXPI_FUNC = "(\\(\\s*deffun Id IDLIST EXPLISTI\\s*\\))";
    private final String EXPI_IDLIST = "empty"; // TODO: EMPTY
    private final String EXPI_FUNC_CALL = "(\\(\\s*Id EXPLISTI\\s*\\))";
    private final String EXPI_IF = "(\\(\\s*if EXPB (\\s*then EXPLISTI else EXPLISTI|EXPLISTI|EXPLISTI EXPLISTI\\s*)\\))";
    private final String EXPB_WHILE = "(\\(\\s*while \\(\\s*EXPB\\\\s*) EXPLISTI\\s*\\))";
    private final String EXPB_FOR = "(\\(\\s*for \\(\\s*Id EXPI EXPI\\s*\\) EXPLISTI\\s*\\))";

    private Stack<String> reducedStack = new Stack<>();
    private Stack<Token> tokenStack = new Stack<>();


    IdentifierList identifierList = IdentifierList.getInstance();
    TokenList tokenList = TokenList.getInstance();

    private Stack<String> output = new Stack<>();

    public Parser() {
    }// TODO: belki patternler buraya gelebilir

    public void parse() {


        tokenStack.addAll(tokenList.getAllTokens());
        Collections.reverse(tokenStack);

        stackTOStr(tokenStack);

        System.out.println("Token List:" + tokenList.getAllTokens());
        System.out.println("Token Stack:" + tokenStack);

        StringBuilder sb1 = new StringBuilder();

        while (!tokenStack.empty()) {
            StringBuilder sb2 = new StringBuilder();
            // eger stack reduce edilebilir ise reduce et
            sb2.append(sb1);
            System.out.println("sb21:"+sb2.toString());
            Token token = tokenStack.pop();
            sb2.append(token.getTokenVal());
            System.out.println("sb22"+sb2.toString());
            output.push(sb2.toString());

            if (token instanceof Identifier) {
                reducedStack.push("Id");
                sb1.append("Id");
                output.push(sb1.toString());
            } else if (token instanceof ValueBinary) {
                reducedStack.push("BinaryValue");
                sb1.append("BinaryValue");
                output.push(sb1.toString());
            } else if (token instanceof ValueInt) {
                reducedStack.push("IntegerValue");
                sb1.append("IntegerValue");
                output.push(sb1.toString());
            } else {
                reducedStack.push(token.getTokenVal());
            }
            
            reduceStack();

        }

        System.out.println("\nResStack:"+output.toString());
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

    private void reduceStack() {
        // eger bos ise direk don ve elemanı eklet

        try {
            String peek = reducedStack.peek();
            System.out.println("Peek:" + peek);
            if (peek.equals("Id") || peek.equals("IntegerValue")) {
                //System.out.println(tokenList.getAllTokens().get(index)+pk);
                reducedStack.pop();
                reducedStack.push("EXPI");
            } else if (peek.equals("BinaryValue")) {
                reducedStack.pop();
                reducedStack.push("EXPB");
            } else if (peek.equals(")")) {
                // ( '( e kadar stackten cek, yoksa EXCEPTIOOOON
                // exception fırlatabilir
                StringBuilder sb = new StringBuilder();
                while (!reducedStack.peek().equals("(") || reducedStack.peek().equals("'(")) {
                    sb.insert(0, reducedStack.pop().toString());
                    sb.insert(0," ");
                }
                sb.insert(0, reducedStack.pop().toString());
                System.out.println("ReducedStackLast:"+reducedStack.toString());
                System.out.println("Paranthesis SB:" + sb.toString());

                if (canReduce(sb.toString(), EXPI_EXPRESSION)) {
                    reducedStack.push("EXPI");
                    //System.out.println("New Stack:" + reducedStack.toString());
                }else if (canReduce(sb.toString(), EXPB_EXPRESSION)) {
                    reducedStack.push("EXPB");
                    //System.out.println("New Stack:" + reducedStack.toString());
                }

            }


        } catch (EmptyStackException e) {
            System.err.println("Stackte acma parantez bulunamadı kocumm");
        }
    }


    private boolean isInput(String str) {
        if (str.equals("EXPI") | str.equals("EXPILISI"))
            return true;
        return false;
    }

    private boolean canReduce(String str, String pattern) {
        boolean result = false;
        Pattern r = Pattern.compile(pattern);
        Matcher matcher = r.matcher(str);
        return matcher.find();
    }

    private String stackTOStr(Stack<Token> stack){

        System.out.println(stack.peek());
        for(Token token: stack){
            System.out.println(token.getTokenVal());
        }
        return "";
    }
}
