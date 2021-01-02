library('hamcrest')
library('se.alipsa:r2md')

str.beginsWith <- function(expected) {
  if(is.na(expected)) {
    stop("expected is NA, beginsWith NA makes no sense")
  }
  function(actual) {
    startsWith(as.character(actual), as.character(expected))
  }
}

str.endsWith <- function(expected) {
  if(is.na(expected)) {
    stop("expected is NA, beginsWith NA makes no sense")
  }
  function(actual) {
    endsWith(as.character(actual), as.character(expected))
  }
}

test.mdText <- function() {
  md.clear()
  md.add("# Hello")

  assertThat(md.content(), equalTo("# Hello\n"))

  md.clear()
  md.add("# Hello2")$add("Some text")$add("- bullet")
  assertThat(md.content(), equalTo("# Hello2\nSome text\n- bullet\n"))
}

test.dataFrameToTable <- function() {
  employee <- c('John Doe','Peter Smith','Jane Doe')
  salary <- c(21000, 23400, 26800)
  startdate <- as.Date(c('2013-11-1','2018-3-25','2017-3-14'))
  endDate <- as.POSIXct(c('2020-01-10 00:00:00', '2020-04-12 12:10:13', '2020-10-06 10:00:05'), tz='UTC' )
  df <- data.frame(employee, salary, startdate, endDate)
  ## hidden will not be added as an attribute since it is not named
  content <- md.table(df, list(id="myTable", "hidden"))
  #outfile <- paste0(getwd(),"/outfile.md")
  #cat(content, file=outfile)
  #print(paste("test.dataFrameToTable, wrote", outfile))

  assertThat(content, equalTo(paste0(
    "\n",
    "employee | salary | startdate | endDate\n",
    "--- | --- | --- | ---\n",
    "John Doe | 21000 | 2013-11-01 | 2020-01-10 00:00:00\n",
    "Peter Smith | 23400 | 2018-03-25 | 2020-04-12 12:10:13\n",
    "Jane Doe | 26800 | 2017-03-14 | 2020-10-06 10:00:05\n")
  ))
  md <- Markdown$new()
  md$add("# A title")$lf()
  md$add(42)
  md$add(md.table(df))
  #outfile2 <- paste0(getwd(),"/outfile2.md")
  #cat(md$getContent(), file=outfile2)
  #cat(md$getContent())
  #print(paste("test.dataFrameToTable, wrote", outfile2))
  assertThat(md$getContent(), equalTo( paste0(
    "# A title\n",
    "\n",
    "42\n",
    "\n",
    "employee | salary | startdate | endDate\n",
    "--- | --- | --- | ---\n",
    "John Doe | 21000 | 2013-11-01 | 2020-01-10 00:00:00\n",
    "Peter Smith | 23400 | 2018-03-25 | 2020-04-12 12:10:13\n",
    "Jane Doe | 26800 | 2017-03-14 | 2020-10-06 10:00:05\n\n")
  ))
}

test.plotToImage <- function() {
  md.clear()
  md.add("# Barplot")$lf()
  md.add(
    barplot,
    table(mtcars$vs, mtcars$gear),
    main="Car Distribution by Gears and VS",
    col=c("darkblue","red")
  )

  outFile <- paste0(getwd(), "/barplotPlot.md")
  write(md.content(), outFile)
  print(paste("Wrote barplot md to", outFile))

  outFile <- paste0(getwd(), "/barplotPlot.html")
  write(md.asHtml(), outFile)
  print(paste("Wrote barplot html to", outFile))
  assertThat(md.asHtml(), str.beginsWith("<h1>Barplot</h1>\n<p><img src=\"data:image/png;base64,"))
  assertThat(md.asHtml(), str.endsWith("\" alt=\"\" /></p>\n"))

  # Plot a histogram
  md.clear()
  md.add(
    hist,
    PlantGrowth$weight
  )
  outFile <- paste0(getwd(), "/PlantGrowthHist.md")
  write(md.content(), outFile)
  print(paste("Wrote PlantGrowth histogram md to", outFile))
  outFile <- paste0(getwd(), "/PlantGrowthHist.html")
  write(md.asHtml(), outFile)
  print(paste("Wrote PlantGrowth histogram html to", outFile))

  assertThat(md.asHtml(), str.beginsWith("<p><img src=\"data:image/png;base64,"))
  assertThat(md.asHtml(), str.endsWith("\" alt=\"\" /></p>\n"))
}

test.imgUrl <- function() {
  md.clear()
  md.add(md.imgUrl("/common/style.css", list("id" = "mystyle", "class" = "image")))
  assertThat(md.content(), equalTo("![](/common/style.css)\n"))
}

test.matrix <- function() {
  md.clear()
  md.add("## PlantGrowth weight")$lf()
  md.add(format(summary(PlantGrowth)))

  outFile <- paste0(getwd(), "/plantGrowthMatrix.md")
  write(md.content(), outFile)
  print(paste("Wrote PlantGrowth summary md to", outFile))

  outFile <- paste0(getwd(), "/plantGrowthMatrix.html")
  write(md.asHtml(), outFile)
  print(paste("Wrote PlantGrowth summary html to", outFile))
  #print(paste("test.matrix, md ="))
  #cat(md.content())
  #print(paste("test.matrix, html =", md.asHtml()))
  assertThat(md.asHtml(), equalTo("<h2>PlantGrowth weight</h2>
<table>
<thead>
<tr><th>weight</th><th>group</th></tr>
</thead>
<tbody>
<tr><td>Min.   : 3.59</td><td>ctrl:10</td></tr>
<tr><td>1st Qu.: 4.55</td><td>trt1:10</td></tr>
<tr><td>Median :5.155</td><td>trt2:10</td></tr>
<tr><td>Mean   :5.073</td><td>NA</td></tr>
<tr><td>3rd Qu.: 5.53</td><td>NA</td></tr>
<tr><td>Max.   : 6.31</td><td>NA</td></tr>
</tbody>
</table>
"))
}