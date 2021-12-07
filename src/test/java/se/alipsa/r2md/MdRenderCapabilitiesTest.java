package se.alipsa.r2md;

import com.vladsch.flexmark.ext.attributes.AttributesExtension;
import com.vladsch.flexmark.ext.gfm.strikethrough.StrikethroughExtension;
import com.vladsch.flexmark.ext.tables.TablesExtension;
import com.vladsch.flexmark.html.HtmlRenderer;
import com.vladsch.flexmark.parser.Parser;
import com.vladsch.flexmark.util.ast.Node;
import com.vladsch.flexmark.util.data.MutableDataSet;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import java.io.File;
import java.io.IOException;
import java.net.URISyntaxException;
import java.util.Arrays;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

public class MdRenderCapabilitiesTest {

  static Parser parser;
  static HtmlRenderer renderer;

  @BeforeAll
  static void init() {
    MutableDataSet options = new MutableDataSet();

    // set optional extensions
    options.set(Parser.EXTENSIONS, Arrays.asList(
        TablesExtension.create(),
        StrikethroughExtension.create(),
        AttributesExtension.create()));
    // convert soft-breaks to hard breaks
    options.set(HtmlRenderer.SOFT_BREAK, "<br />\n");
    parser = Parser.builder(options).build();
    renderer = HtmlRenderer.builder(options)
        .build();
  }

  @Test
  public void testLinks() {
    assertEquals("<p><a href=\"https://www.alipsa.se\">alipsa</a></p>\n",
        md2html("[alipsa](https://www.alipsa.se)"));

    assertEquals("<p><a href=\"https://www.alipsa.se\" class=\"btn btn-default\">alipsa</a></p>\n",
        md2html("[alipsa](https://www.alipsa.se){class='btn btn-default'}"));

    assertEquals("<p><a href=\"https://www.alipsa.se\" id=\"abc12\" class=\"btn btn-default\">alipsa</a></p>\n",
        md2html("[alipsa](https://www.alipsa.se){id='abc12' class='btn btn-default'}"));
  }

  @Test
  public void testImg() {
    assertEquals("<p><img src=\"http://www.alipsa.se/images/AlipsaDevelopment.png\" alt=\"logo\" /></p>\n",
        md2html("![logo](http://www.alipsa.se/images/AlipsaDevelopment.png)"));
  }

  @Test
  public void testImgEmbedded() throws IOException, URISyntaxException {
    String base64Img = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABIAAAAUCAYAAACAl21KAAAABHNCSVQICAgIfAhkiAAABHRJREFUOI0FwUtv2wQAwPG_X7HzdhI3ydokbdcHbZdqTwZFPLRpEhKgsQtIm8QZceMDcNj34Mh1t0lsQhpiTDtMq8ZQ29F2XZsuafNsmsRNnNixze8nfH13ztcNGUlwqbztMLZ9_LHCZFzDCgsEVBl3LPHRaoambTHouVQbp9y4MsWrzRq1ygBHBnFxPoGGRKM0QLZg5bzBwkqYcEIkmdJIhCRWryxRbg6ZzmeoVBrkJw36A5F_13uMXB8tFEAWkAnJAomwhBcNM5IcdnZNdMkjJSQQ4kFer2_R2a6RfNfkZnEJvZhHksb89GOMZqNJbSQhmx0Hc-CgxYLEROgJNgPTwbZtZi4VaJWrmMc2ubGMvV5nVGrij08QrxaIRlW07BUGb3cRP7k0y9oXV8ks5BgGAwyPhoiuS0AOk0sK6Gmduz_fZuVSHtv2sE5c_P0mk3oEcarAYcskNhoiP_zzJcX5LJmQz62v1qhubnMzHcENRIg6HrpxRv6czng5w7tHO1Q6HoNXDVI9m43N19QO63ihFFJ2Onrf16By3Kb9-D_ePdwnqcqkinnq3TPed-vsbx6w-9cRE5pO23JIJZO0NIuqNYJglHa3iZif10jHw0imR3W3T4cQW0-Pqb48IBORsUyIAtrxGU9KLQQ9Qvx6hsy1AlJgxERa5cNrU8iqFGBntwbWmEk1RDauUz9t8-DBBql8ksN6n5W4wHJ2ggYD3ioWax_41Mo1JEVGEixOa13EzsjntG3juwpDf0w8ESEgyyxeXKBRNul3B-y97RJSA9y-cZmROaZugp5KszA_TSJloBkGcq_eIxKPYg4hG1cICD5z53P8U66gJ2VES-PzlQnmYpOEYhJryyniEYXtrRLncnGE3hm2C_LMdBItGMazfKr7JYpfXqNUPuHNs1Naisfte9c5PxUjKiYZjSQ2dlts91t8cmOB7a1jzhkhkBXEtjlG0ER2jnz0j89Tb_WptgcsJqPk8irlyoDHfxxwXLX4_elLjvoW2XwSIxVEVTT29i3c6GXki8Ulhk6Hy0Wfke_y6MkOz14ccW-1gCqdIC-mqbXm-eW3X0lNhbj9_TJGGizB47QjoighQnIHaXbOvX-438fsO4RTPpqh8PxpjTtrSyieS9kZk45Br11h7Ks8_7uErmssrxZRVY9cTkWwWsijkYdpumjiBK-fvqdQiJKe0DAtl74DxweHHLzZwwkYeFKSiZkMrhaitlem45lEYzobLxoIt74x_IWVDO_ftem1PI6O-wQCEgUhQGtsE8rGKVdtYukMnVYdVZEZDc4IaCJ3friEPRxS2u4hprJBYgioYYWlC3G-_W4WJepTkoa4IQHjXAJ9Mke3VsHpnZGOjVm6MEs4IhCMqIhKGGM6gawnYjSaQ4JegMW0QW9gE5WCeKJNcX6CoC6zt3vE8oUUmUyExKTA1sYZn306hWQPiEViYJvIVg9sPFBFTp0xTcfCFyAW0agNushnbWYKQRYuZmhVqkTUOJNRh0LBIBLWeb5ewjnp8j87B_hjVaSpRAAAAABJRU5ErkJggg";

    assertEquals("<p><img src=\"" + base64Img + "\" alt=\"\" /></p>\n",
        md2html("![](" + base64Img + ")"));

    assertEquals("<h1>An Image</h1>\n<p><img src=\"" + base64Img + "\" alt=\"\" /></p>\n",
        md2html("# An Image\n\n![](" + base64Img + ")"));

    String content = FileEncoder.contentAsBase64("https://upload.wikimedia.org/wikipedia/commons/d/dd/Accounting-icon.png");
    assertTrue(content.startsWith("data:image/png;base64,"));

    File img = new File(getClass().getResource("/Accounting-icon.png").toURI());
    content = FileEncoder.contentAsBase64(img.getAbsolutePath());
    assertTrue(content.startsWith("data:image/png;base64,"));

  }

  @Test
  public void testTables() {
    StringBuilder mdTable = new StringBuilder("num | name | data\n")
        .append("--- | --- | ---\n")
        .append("1 | Per | Foo\n")
        .append("2 | Ian | Bar\n")
        .append("3 | Ida | Baz\n");
    assertEquals("<table>\n" +
        "<thead>\n" +
        "<tr><th>num</th><th>name</th><th>data</th></tr>\n" +
        "</thead>\n" +
        "<tbody>\n" +
        "<tr><td>1</td><td>Per</td><td>Foo</td></tr>\n" +
        "<tr><td>2</td><td>Ian</td><td>Bar</td></tr>\n" +
        "<tr><td>3</td><td>Ida</td><td>Baz</td></tr>\n" +
        "</tbody>\n" +
        "</table>\n",
        md2html(mdTable.toString()));

    // Table with attributes
    mdTable.append("\n{id=\"Foo\" class=\"table table-striped\"}");
    assertEquals("<table id=\"Foo\" class=\"table table-striped\">\n" +
            "<thead>\n" +
            "<tr><th>num</th><th>name</th><th>data</th></tr>\n" +
            "</thead>\n" +
            "<tbody>\n" +
            "<tr><td>1</td><td>Per</td><td>Foo</td></tr>\n" +
            "<tr><td>2</td><td>Ian</td><td>Bar</td></tr>\n" +
            "<tr><td>3</td><td>Ida</td><td>Baz</td></tr>\n" +
            "</tbody>\n" +
            "</table>\n",
        md2html(mdTable.toString()), "markdown '" + mdTable + "' not rendered correctly");

  }

  @Test
  public void testImageDistance() {
    String md = "# Barplot\n" +
        "![](data:image/png;base64,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AdgADGAASwAGsAHYACwAA9gAbACWAAxgA7ABWAAGsAHYACwBGMAABjCAASwAA9gAbACWAAxgAAMYwBKAAWwANgBLADYAAxjAEoABbAA2AAvAADYAG4AlAAPYAGwAFoABbAA2AEsABjCAAWwAFoABbAA2AEsABjCAAQxgCcAANgAbgCUAG4ABDGAJwAA2ABuABWAAG4ANwBKAAWwANgALwAA2ABuAJQADGMAANgALwAA2ABuAJQADGMAABrAEYAAbgA3AEoANwAAGsARgABuADcACcM7Ftr09IJ9/DWADsAFYAE5+tXr21wA2ABuABWAAG4ANwNIzAX5/u7r3rWsAAxjAAJYA7BWwAdgALADnI+w3YRmADcDSYICzX1UDGMAANgALwAA2ABuAJQADGMAABrAEYAAbgA3AEoANwAAGsARgABuADcACMIANwAZgCcAANgAbgAVgABuADcASgAEMYAAbgAVgABuADcASgAEMYAADWAIwgA3ABmAJwAZgAANYAjCADcAGYAEYwAZgA7AEYAAbgA3AAjCADcAGYAnAAAYwgA3AAjCADcAGYAnAAAYwgAEsARjABmADsARgkAEYwACWAAxgA7ABWAAGsAHYACwBGMAGYAOwAAxgA7ABWAIwgAEMYAOwAAxgA7ABWAIwgAEMYABLAAawAdgALAEYYgAGMIAlAAPYAGwAFoABbAA2AEsABrAB2AAsAAPYAGwAlgAMYAAD2AAsAAPYAGwAlgAMYAADGMASgAFsADYASwAGMIABDGAJwAA2ABuABWAAG4BBBmAJwAA2ABuABeA4MLfXg7J1PDAABjCADcACcAO+e38NYAOwAVgATgI4AlMAAxjABmABOBngz7est84HDcAABjCApcd+D9hb0AZgA7AAPOonCn4VC2AAA9gALACP/kUDGMAANgALwAA2ABuAJQADGMAABrAEYAAbgA3AEoABDGAAA1gCMIANwAZgARjABmCIAVgCMIANwAZgARjABmADsARgAAMYwAZgARjABmADsARgAAMYwACWAAxgA7ABWAIwgAEMYABLAAawAdgALAAD2AAMYABLAAawAdgALAAD2ABsAJYADGAAA9gALAAD2ABsAJYADGAAAxjAEoABbAA2AEsABjCAAQzgznvDVh6AAWwAtkUB9jF2NgAMYAC7ZA3ABmAAG4ANwAZgAAMYwC5Zl6yz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)\n" +
        "\n";
    String html = md2html(md);
    assertTrue(html.startsWith("<h1>Barplot</h1>\n<p><img src=\"data:image/png;base64,"), "Markdown was not rendered correctly");
    assertTrue(html.endsWith("\" alt=\"\" /></p>\n"), "Markdown was not rendered correctly");
  }


  public String md2html(String mdContent) {
    Node document = parser.parse(mdContent);
    return renderer.render(document);
  }

}
