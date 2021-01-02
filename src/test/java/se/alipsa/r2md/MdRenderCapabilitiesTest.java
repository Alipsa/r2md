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

import java.util.Arrays;

import static org.junit.jupiter.api.Assertions.assertEquals;

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
  public void testImgEmbedded() {
    String base64Img = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABIAAAAUCAYAAACAl21KAAAABHNCSVQICAgIfAhkiAAABHRJREFUOI0FwUtv2wQAwPG_X7HzdhI3ydokbdcHbZdqTwZFPLRpEhKgsQtIm8QZceMDcNj34Mh1t0lsQhpiTDtMq8ZQ29F2XZsuafNsmsRNnNixze8nfH13ztcNGUlwqbztMLZ9_LHCZFzDCgsEVBl3LPHRaoambTHouVQbp9y4MsWrzRq1ygBHBnFxPoGGRKM0QLZg5bzBwkqYcEIkmdJIhCRWryxRbg6ZzmeoVBrkJw36A5F_13uMXB8tFEAWkAnJAomwhBcNM5IcdnZNdMkjJSQQ4kFer2_R2a6RfNfkZnEJvZhHksb89GOMZqNJbSQhmx0Hc-CgxYLEROgJNgPTwbZtZi4VaJWrmMc2ubGMvV5nVGrij08QrxaIRlW07BUGb3cRP7k0y9oXV8ks5BgGAwyPhoiuS0AOk0sK6Gmduz_fZuVSHtv2sE5c_P0mk3oEcarAYcskNhoiP_zzJcX5LJmQz62v1qhubnMzHcENRIg6HrpxRv6czng5w7tHO1Q6HoNXDVI9m43N19QO63ihFFJ2Onrf16By3Kb9-D_ePdwnqcqkinnq3TPed-vsbx6w-9cRE5pO23JIJZO0NIuqNYJglHa3iZif10jHw0imR3W3T4cQW0-Pqb48IBORsUyIAtrxGU9KLQQ9Qvx6hsy1AlJgxERa5cNrU8iqFGBntwbWmEk1RDauUz9t8-DBBql8ksN6n5W4wHJ2ggYD3ioWax_41Mo1JEVGEixOa13EzsjntG3juwpDf0w8ESEgyyxeXKBRNul3B-y97RJSA9y-cZmROaZugp5KszA_TSJloBkGcq_eIxKPYg4hG1cICD5z53P8U66gJ2VES-PzlQnmYpOEYhJryyniEYXtrRLncnGE3hm2C_LMdBItGMazfKr7JYpfXqNUPuHNs1Naisfte9c5PxUjKiYZjSQ2dlts91t8cmOB7a1jzhkhkBXEtjlG0ER2jnz0j89Tb_WptgcsJqPk8irlyoDHfxxwXLX4_elLjvoW2XwSIxVEVTT29i3c6GXki8Ulhk6Hy0Wfke_y6MkOz14ccW-1gCqdIC-mqbXm-eW3X0lNhbj9_TJGGizB47QjoighQnIHaXbOvX-438fsO4RTPpqh8PxpjTtrSyieS9kZk45Br11h7Ks8_7uErmssrxZRVY9cTkWwWsijkYdpumjiBK-fvqdQiJKe0DAtl74DxweHHLzZwwkYeFKSiZkMrhaitlem45lEYzobLxoIt74x_IWVDO_ftem1PI6O-wQCEgUhQGtsE8rGKVdtYukMnVYdVZEZDc4IaCJ3friEPRxS2u4hprJBYgioYYWlC3G-_W4WJepTkoa4IQHjXAJ9Mke3VsHpnZGOjVm6MEs4IhCMqIhKGGM6gawnYjSaQ4JegMW0QW9gE5WCeKJNcX6CoC6zt3vE8oUUmUyExKTA1sYZn306hWQPiEViYJvIVg9sPFBFTp0xTcfCFyAW0agNushnbWYKQRYuZmhVqkTUOJNRh0LBIBLWeb5ewjnp8j87B_hjVaSpRAAAAABJRU5ErkJggg";

    assertEquals("<p><img src=\"" + base64Img + "\" alt=\"\" /></p>\n",
        md2html("![](" + base64Img + ")"));

    assertEquals("<h1>An Image</h1>\n<p><img src=\"" + base64Img + "\" alt=\"\" /></p>\n",
        md2html("# An Image\n\n![](" + base64Img + ")"));
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
  }


  public String md2html(String mdContent) {
    Node document = parser.parse(mdContent);
    return renderer.render(document);
  }

}
