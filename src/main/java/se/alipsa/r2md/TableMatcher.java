package se.alipsa.r2md;

import org.renjin.sexp.SEXP;
import org.renjin.sexp.StringArrayVector;

import java.util.Arrays;

public class TableMatcher {

  // Renjin does not support negative lookahead so doing this is java

  public static boolean find(SEXP text) {
    if (text instanceof StringArrayVector) {
      return find(text.asString());
    }
    return false;
  }

  public static boolean find(String text) {
    if (text == null) {
      return false;
    }
    return Arrays.asList(text.split(" ", 0)).contains("table");
  }
}
