package coffee.project;

import coffee.REPL;
import coffee.TokenList;
import coffee.datatypes.Identifier;
import coffee.datatypes.Operator;
import coffee.datatypes.ValueInt;
import coffee.exceptions.InvalidTokenException;

/**
 * Created by ft on 10/14/15.
 */
public class Lexer implements REPL.LineInputCallback {
    @Override
    public String lineInput(String line) {

        try {
            String[] splits = line.split(" ");

            for (String itr : splits) {
                System.out.println("Parse :"+itr);
                parseToken(itr);
            }
            return "empy";
        } catch (Exception e) {
            return e.getMessage();
        }
    }

    public void parseToken(String token) throws InvalidTokenException{
        System.out.println("parseToken is started");

        for(int i=0;i<token.length();++i){
            char ch = token.charAt(i);

            if(Character.isLetter(ch)){
                StringBuilder sb = new StringBuilder();
                sb.append(ch);
                for(int j=i+1;j<token.length();++j){
                    if(Character.isLetter(token.charAt(j))) { // check [a-zA-Z] range
                        sb.append(token.charAt(j));
                        i=j;
                    }else if(token.charAt(j)==')'){
                        // identifier)  status is valid
                        // continue to parsing
                        break;
                    }
                    else throw new InvalidTokenException(token,i);
                }
                System.out.println(sb.toString());
                TokenList.getInstance().addToken(new Identifier(sb.toString()));
            }else if(ch=='-'){
                StringBuilder sb = new StringBuilder();
                sb.append(ch);
                if(i== token.length()-1){ // - den sonra item yoksa
                    System.out.println("Operator - :"+sb.toString());
                    TokenList.getInstance().addToken(new Operator(sb.toString()));
                }else {
                    for (int j = i + 1; j < token.length(); ++j) {
                        if (Character.isDigit(token.charAt(j))) { // check [a-zA-Z] range
                            sb.append(token.charAt(j));
                            i = j;
                        } else if (token.charAt(j) == ')') {
                            // number)  status is valid
                            // continue to parsing
                            break;
                        } else throw new InvalidTokenException(token, i);
                    }
                    System.out.println("Number:" + sb.toString());
                    TokenList.getInstance().addToken(new ValueInt(Integer.valueOf(sb.toString())));
                }
            }else if(ch==')'){
                StringBuilder sb = new StringBuilder();
                sb.append(ch);
                System.out.println("Operator: " + sb.toString());
                TokenList.getInstance().addToken(new Operator(sb.toString()));
            }else if(Character.isDigit(ch)){
                StringBuilder sb = new StringBuilder();
                sb.append(ch);
                for (int j = i + 1; j < token.length(); ++j) {
                    if (Character.isDigit(token.charAt(j))) { // check [a-zA-Z] range
                        sb.append(token.charAt(j));
                        i = j;
                    } else if (token.charAt(j) == ')') {
                        // number)  status is valid
                        // continue to parsing
                        break;
                    } else throw new InvalidTokenException(token, i);
                    System.out.println("Number: " + sb.toString());
                    TokenList.getInstance().addToken(new ValueInt(Integer.valueOf(sb.toString())));
                }
            }



        }



    }
}
