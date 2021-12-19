library('hamcrest')
library('se.alipsa:r2md')

test.pdfExport <- function() {
  md.new("# An mtcars table")
  md.add(mtcars)
  filename <- paste0(getwd(), "/mtcars.pdf")
  md.renderPdf(md.content(), filename)
  assertThat(file.exists(filename), identicalTo(TRUE))
}