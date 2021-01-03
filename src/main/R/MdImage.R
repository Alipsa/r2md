md.imgPlot <- function(plotFunction, ..., alt="", attr=NA) {
  outFile <- tempfile("plot", fileext = ".png")
  png(outFile)
  # alt
  # height: exists both in img and barplot
  plotFunction(...)
  dev.off()
  imgContent <- FileEncoder$contentAsBase64(outFile)
  file.remove(outFile)
  paste0("![", alt, "](", imgContent, ")", extAttributes(attr))
}

md.imgEmbed <- function(fileNameOrUrl, alt="", attr=NA) {
  imgContent <- FileEncoder$contentAsBase64(fileNameOrUrl)
  # TODO, handle additional attributes
  paste0("![", alt, "](", imgContent, ")", extAttributes(attr))
}

md.imgUrl <- function(url, alt="", attr=NA) {
  # TODO, handle additional attributes
  paste0("![", alt, "](", url, ")", extAttributes(attr))
}