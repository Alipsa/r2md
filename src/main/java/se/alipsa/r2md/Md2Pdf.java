package se.alipsa.r2md;

import com.vladsch.flexmark.ext.toc.TocExtension;
import com.vladsch.flexmark.pdf.converter.PdfConverterExtension;
import com.vladsch.flexmark.profile.pegdown.Extensions;
import com.vladsch.flexmark.profile.pegdown.PegdownOptionsAdapter;
import com.vladsch.flexmark.util.data.DataHolder;

public class Md2Pdf {

  static final DataHolder OPTIONS = PegdownOptionsAdapter.flexmarkOptions(
          Extensions.ALL & ~(Extensions.ANCHORLINKS | Extensions.EXTANCHORLINKS_WRAP)
          , TocExtension.create()).toMutable()
      .set(TocExtension.LIST_CLASS, PdfConverterExtension.DEFAULT_TOC_LIST_CLASS)
      .toImmutable();

  public static void render(String html, String fileName) {
    if (html == null) {
      System.err.println("html parameter is null, nothing to render");
      return;
    }
    if (fileName == null) {
      System.err.println("fileName parameter is null, nothing to do here");
      return;
    }
    if (!fileName.toLowerCase().endsWith(".pdf")) {
      fileName = fileName + ".pdf";
    }
    PdfConverterExtension.exportToPdf(fileName, html, "", OPTIONS);
  }
}
