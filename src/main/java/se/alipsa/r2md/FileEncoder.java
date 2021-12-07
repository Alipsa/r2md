package se.alipsa.r2md;

import org.apache.commons.io.IOUtils;

import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Base64;

public class FileEncoder {

  public static String contentAsBase64(String urlOrFileName) throws IOException {
    if(urlOrFileName == null) {
      throw new IllegalArgumentException("Argument urlOrFileName is null, cannot convert to base64");
    }

    byte[] content;
    if (new File(urlOrFileName).exists()) {
      content = Files.readAllBytes(Paths.get(urlOrFileName));
    } else {
      URL url = new URL(urlOrFileName);
      content = IOUtils.toByteArray(url);
    }
    return "data:image/png;base64," + Base64.getEncoder().encodeToString(content);
  }
}
