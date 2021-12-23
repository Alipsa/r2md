package se.alipsa.r2md;

import java.util.Arrays;

public class TableMatcher {

  // Renjin does not support negative lookahead and i could not make strsplit work so doing this is java

  public static boolean find(String text) {
    return Arrays.asList(text.split(" ", 0)).contains("table");
  }
}
