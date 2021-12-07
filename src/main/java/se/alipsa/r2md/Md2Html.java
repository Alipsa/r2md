package se.alipsa.r2md;

import com.vladsch.flexmark.ext.attributes.AttributesExtension;
import com.vladsch.flexmark.ext.gfm.strikethrough.StrikethroughExtension;
import com.vladsch.flexmark.ext.tables.TablesExtension;
import com.vladsch.flexmark.html.HtmlRenderer;
import com.vladsch.flexmark.parser.Parser;
import com.vladsch.flexmark.util.ast.Node;
import com.vladsch.flexmark.util.data.MutableDataSet;
import org.renjin.sexp.StringArrayVector;

import java.util.Arrays;

public class Md2Html {

  Parser parser;
  HtmlRenderer renderer;

  public Md2Html() {
    MutableDataSet options = new MutableDataSet();

    // add extensions
    options.set(Parser.EXTENSIONS, Arrays.asList(
        TablesExtension.create(),
        StrikethroughExtension.create(),
        AttributesExtension.create())
    );
    // convert soft-breaks to hard breaks
    options.set(HtmlRenderer.SOFT_BREAK, "<br />\n");
    parser = Parser.builder(options).build();
    renderer = HtmlRenderer.builder(options)
        .build();
  }

  public String render(Object content) {
    //System.out.println(content.getClass());
    if (content instanceof StringArrayVector) {
      return render(((StringArrayVector) content).asString());
    }
    return render(String.valueOf(content));
  }

  public String render(String mdContent) {
    //System.out.println("Rendering " + mdContent);
    Node document = parser.parse(mdContent);
    return renderer.render(document);
  }

}
