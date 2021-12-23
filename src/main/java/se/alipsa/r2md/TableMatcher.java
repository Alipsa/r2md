package se.alipsa.r2md;

import org.renjin.sexp.SEXP;
import org.renjin.sexp.StringArrayVector;

import java.util.Arrays;

/** Renjin does not support negative lookahead so doing this is java.
 *  The findWord method in MdTable seems to work now so this is not used.
 *
 *  Example usage: if (TableMatcher$find(attr[["class"]])) print("has table in the class attribute")
 */
public class TableMatcher {

  /** in case something weird is sent to find, we overload with a "catch all" */
  public static boolean find(SEXP text) {
    if (text instanceof StringArrayVector) {
      return find(text.asString());
    }
    return false;
  }

  /** determine whether the text contains the word table */
  public static boolean find(String text) {
    if (text == null) {
      return false;
    }
    return Arrays.asList(text.split(" ", 0)).contains("table");
  }
}
