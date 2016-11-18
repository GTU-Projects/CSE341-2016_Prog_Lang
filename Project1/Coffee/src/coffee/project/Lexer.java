package coffee.project;

import coffee.IdentifierList;
import coffee.REPL;
import coffee.TokenList;
import coffee.datatypes.*;
import coffee.exceptions.InvalidTokenException;
import coffee.syntax.Keywords;
import coffee.syntax.Operators;

/**
 * Created by ft on 10/14/15.
 */
public class Lexer implements REPL.LineInputCallback {

    private boolean debugMode = false;

    @Override
    public String lineInput(String line) {
        try {
            String[] splits = line.split(" ");
            for (String itr : splits) {
                if (debugMode) System.out.println("ParseString :" + itr);
                parseToken(itr);
            }
            if (debugMode) System.out.println("--------------------------");
            return "successful";
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
            e.printStackTrace();
            return e.getMessage();
        }
    }

    /**
     * Girilen stringin gecerli keyword, binaryInt tokenini bulur
     * Diğer durumlarda identifier objesi return eder
     *
     * @param str string
     * @return stringin token objesi
     */
    private Token getActualToken(String str) {
        Token token = null;

        if (str.equals(Keywords.AND) || str.equals(Keywords.APPEND) || str.equals(Keywords.CONCAT) ||
                str.equals(Keywords.DEFFUN) || str.equals(Keywords.ELSE) || str.equals(Keywords.EQUAL) ||
                str.equals(Keywords.FOR) || str.equals(Keywords.NOT) || str.equals(Keywords.THEN) ||
                str.equals(Keywords.OR) || str.equals(Keywords.SET) || str.equals(Keywords.WHILE) ||
                str.equals(Keywords.IF) || str.equals(Keywords.NULL))
            token = new Keyword(str);

        else if (str.equals(Keywords.TRUE))
            token = new ValueBinary(true);
        else if (str.equals(Keywords.FALSE))
            token = new ValueBinary(false);

        else token = new Identifier(str);// keyword degilse identifierdir

        return token;
    }

    /**
     * Bir kelime alır id,keyword bakımından kontrol eder
     * [a-zA-Z] aralığını kabul eder
     * Bulduğu tokeni listeye ekler.
     *
     * @param word  analiz edilecek kelime
     * @param index analizin baslayacagi index
     * @return aramanın kaldığı yerden indexi return eder
     * example : asd)) gelirse asd yi token olarak ekler ve 3 return eder
     * a5x gibi hatalı durumda exception fırlatır
     */
    private int analyzeWords(String word, int index) throws InvalidTokenException {
        StringBuilder sb = new StringBuilder();
        int nextIndex = index; // buradan devam edilecek

        sb.append(word.charAt(index)); // ilk karakter kontrol edilmisti stringe ekle
        if (debugMode) System.out.println("Word[0]: " + sb.toString());

        for (int j = nextIndex + 1; j < word.length(); ++j) { // ilk karakter zaten check edildi
            if (Character.isLetter(word.charAt(j))) { // check [a-zA-Z] range
                sb.append(word.charAt(j));
                nextIndex = j;
            } else if (word.charAt(j) == Operators.RIGHT_PARENTHESIS.charAt(0)) {
                // kelimelerden sonra sadece ) gelebilir
                break;
            } else throw new InvalidTokenException(word, j);
        }
        Token token = getActualToken(sb.toString()); // tokeni olusturup listeye ekle
        if (token != null) {
            if (debugMode) System.out.println(token);
            if (token instanceof Identifier)
                IdentifierList.getInstance().addIdentifier(((Identifier) token).getName());
            TokenList.getInstance().addToken(token);
        }
        return nextIndex;
    }

    /**
     * Parametre olarak gelen stringin istenilen indexten itibaren sayı olabilecek
     * kısmını alarak token listesine ekler   -*[0-9]+ regexe yapısna gore calısır
     *
     * @param word  arama yapılacak string
     * @param index aramanın baslama indexi
     * @return aramanın sonlandıgı index
     * @throws InvalidTokenException hatalı token durumunda exceptıon fırlatır
     */
    private int analyzeNumbers(String word, int index) throws InvalidTokenException {
        StringBuilder sb = new StringBuilder();
        int nextIndex = index; // devam edilecek index

        sb.append(word.charAt(index)); // - isaretini yada ilk karakteri eklicez

        for (int j = nextIndex + 1; j < word.length(); ++j) { // sonraki sayilari oku
            if (Character.isDigit(word.charAt(j))) { // check [0-9]+ range
                sb.append(word.charAt(j));
                nextIndex = j;
            } else if (word.charAt(j) == Operators.RIGHT_PARENTHESIS.charAt(0)) {
                // sayilardan sonra sadece ) gelmeli
                break;
            } else throw new InvalidTokenException(word, j);
        }

        Token token = new ValueInt(Integer.valueOf(sb.toString()));
        if (debugMode) System.out.println(token);
        TokenList.getInstance().addToken(token);
        return nextIndex;
    }

    /**
     * Be metod kendisine gelen stringi parse ederek, icindeki tokenleri bulur
     * Bulunan tokenler tokenliste eklenir
     *
     * @param token tokenleri ayrıstırılacak string
     * @throws InvalidTokenException tokenlerde hata varsa fırlatırılır
     */
    private void parseToken(String token) throws InvalidTokenException {
        if (debugMode) System.out.println("parseToken is started");

        for (int i = 0; i < token.length(); ++i) {
            String ch = String.valueOf(token.charAt(i)); // equal kullanımını kolaylastırmak icin string yapıldı
            if (debugMode) System.out.println("ch:" + ch);

            if (Character.isLetter(ch.charAt(0))) {
                i = analyzeWords(token, i); //analize kaldıgı yerden devam etmesi icin indxi guncelle
                //  iden) gibi bir durumda ) operatorunden devam etmeli
            } else if (ch.equals(Operators.MINUS)) { // eger - gelirse
                if (i == token.length() - 1) { // - den sonra item yoksa operator olarak ekle
                    TokenList.getInstance().addToken(new Operator(ch.toString()));
                } else {
                    i = analyzeNumbers(token, i); // negatif sayi kontrolu yap
                    // sayı) gibi bir durumda ) den devam edebilmeli
                }
            } else if (Character.isDigit(ch.charAt(0))) { // pozitif sayi kontrolu check;
                i = analyzeNumbers(token, i);
            } else if (ch.equals(Operators.LEFT_PARENTHESIS)) { // acma parantez
                TokenList.getInstance().addToken(new Operator(ch.toString()));
            } else if (ch.equals(Operators.RIGHT_PARENTHESIS)) { // kapama parantez
                TokenList.getInstance().addToken(new Operator(ch.toString()));
            } else if (ch.equals(Operators.PLUS) || ch.equals(Operators.ASTERISK) || ch.equals(Operators.SLASH)) {
                if (i == token.length() - 1) { // bu op. lerden sonra sadece bosluk gelebilir yani sonda olmalılar
                    TokenList.getInstance().addToken(new Operator(ch.toString()));
                } else throw new InvalidTokenException(token, i + 1);
            } else if (ch.equals(Operators.NAIL)) { // ' operatoru
                TokenList.getInstance().addToken(new Operator(ch.toString()));
            }
        }
    }
}