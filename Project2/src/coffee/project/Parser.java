package coffee.project;

import coffee.IdentifierList;
import coffee.TokenList;
import coffee.datatypes.*;

import java.util.Arrays;
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

        System.out.println("Token List:" + tokenList.getAllTokens());
        System.out.println("Token Stack:" + tokenStack);

        StringBuilder sb1 = new StringBuilder();
        output.push("");

        while (!tokenStack.empty()) {
            System.out.println("------WHILE-----");
            printStack(output);
            StringBuilder sb2 = new StringBuilder();
            // eger stack reduce edilebilir ise reduce et
            sb2.append(output.peek());
            System.out.println("sb2:"+sb2.toString());
            Token token = tokenStack.pop();
            sb2.append(" ").append(token.getTokenVal());
            System.out.println("sb2:"+sb2.toString());
            output.push(sb2.toString());

            if (token instanceof Identifier) {
                reducedStack.push("Id");
                output.push(" "+stackToStr(reducedStack));
            } else if (token instanceof ValueBinary) {
                reducedStack.push("BinaryValue");
                output.push(" "+stackToStr(reducedStack));
            } else if (token instanceof ValueInt) {
                reducedStack.push("IntegerValue");
                output.push(" "+stackToStr(reducedStack));
            } else {
                reducedStack.push(token.getTokenVal());
            }
            reduceStack();
        }

        printStack(output);

    }

    private void reduceStack() {
        // eger bos ise direk don ve elemanı eklet

        try {
            String peek = reducedStack.peek();
            //System.out.println("Peek:" + peek);
            if (peek.equals("Id") || peek.equals("IntegerValue")) {
                reducedStack.pop();
                reducedStack.push("EXPI");
                output.push(" "+stackToStr(reducedStack));
            } else if (peek.equals("BinaryValue")) {
                reducedStack.pop();
                reducedStack.push("EXPB");
                output.push(" "+stackToStr(reducedStack));
            } else if (peek.equals(")")) {
                // ( '( e kadar stackten cek, yoksa EXCEPTIOOOON
                // exception fırlatabilir
                StringBuilder sb = new StringBuilder();
                while (!reducedStack.peek().equals("(") || reducedStack.peek().equals("'(")) {
                    sb.insert(0, reducedStack.pop().toString());
                    sb.insert(0," ");
                }
                sb.insert(0, reducedStack.pop().toString());
                //System.out.println("ReducedStackLast:"+reducedStack.toString());
                System.out.println("Paranthesis SB:" + sb.toString());

                if (canReduce(sb.toString(), EXPI_EXPRESSION)) {
                    reducedStack.push("EXPI");
                    output.push(" "+stackToStr(reducedStack));
                }else if (canReduce(sb.toString(), EXPB_EXPRESSION)) {
                    reducedStack.push("EXPB");
                    System.out.println("hereee");
                    output.push(" "+stackToStr(reducedStack));
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
        Pattern r = Pattern.compile(pattern);
        Matcher matcher = r.matcher(str);
        return matcher.find();
    }

    private void printStack(Stack<String> stack){
        System.out.println("Output:");
        for(int i=stack.size()-1;i>=0;--i){
            System.out.println(stack.get(i));
        }
    }

    private String stackToStr(Stack<String> stack){
        StringBuilder sb= new StringBuilder();
        for(int i=0;i<stack.size();++i){
            sb.append(stack.get(i)).append(" ");
        }
        return sb.toString();
    }
}
