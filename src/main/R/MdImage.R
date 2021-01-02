md.imgPlot <- function(plotFunction, ..., htmlattr=NA) {
  outFile <- tempfile("plot", fileext = ".png")
  png(outFile)
  # alt
  # height: exists both in img and barplot
  plotFunction(...)
  dev.off()
  imgContent <- FileEncoder$contentAsBase64(outFile)
  file.remove(outFile)
  paste0("![](", imgContent, ")")
}

mdimgFile <- function(fileName, htmlattr=NA) {
  imgContent <- FileEncoder$contentAsBase64(fileName)
  # TODO, handle additional attributes
  paste0("![](", imgContent, ")")
}

md.imgUrl <- function(url, htmlattr=NA) {
  # TODO, handle additional attributes
  paste0("![](", url, ")")
}