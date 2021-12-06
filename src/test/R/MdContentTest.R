library('hamcrest')
library('se.alipsa:r2md')

str.beginsWith <- function(expected) {
  if(is.na(expected)) {
    stop("expected is NA, str.beginsWith NA makes no sense")
  }
  function(actual) {
    startsWith(as.character(actual), as.character(expected))
  }
}

str.endsWith <- function(expected) {
  if(is.na(expected)) {
    stop("expected is NA, str.endsWith NA makes no sense")
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
  assertThat(md.asHtml(), equalTo("<h1>Hello2</h1>\n<p>Some text</p>\n<ul>\n<li>bullet</li>\n</ul>\n"))
}

test.dataFrameToTable <- function() {
  employee <- c('John Doe','Peter Smith','Jane Doe')
  salary <- c(21000, 23400, 26800)
  startdate <- as.Date(c('2013-11-1','2018-3-25','2017-3-14'))
  endDate <- as.POSIXct(c('2020-01-10 00:00:00', '2020-04-12 12:10:13', '2020-10-06 10:00:05'), tz='UTC' )
  df <- data.frame(employee, salary, startdate, endDate)
  ## hidden will not be added as an attribute since it is not named
  content <- md.table(df, attr=list(id="myTable", "hidden"))
  #outfile <- paste0(getwd(),"/outfile.md")
  #cat(content, file=outfile)
  #print(paste("test.dataFrameToTable, wrote", outfile))

  assertThat(content, equalTo(paste0(
    "\n",
    "employee | salary | startdate | endDate\n",
    "--- | --- | --- | ---\n",
    "John Doe | 21000 | 2013-11-01 | 2020-01-10 00:00:00\n",
    "Peter Smith | 23400 | 2018-03-25 | 2020-04-12 12:10:13\n",
    "Jane Doe | 26800 | 2017-03-14 | 2020-10-06 10:00:05\n",
    "{id=\"myTable\"}\n")
  ))
  assertThat(md.renderHtml(content), equalTo(
"<table id=\"myTable\">
<thead>
<tr><th>employee</th><th>salary</th><th>startdate</th><th>endDate</th></tr>
</thead>
<tbody>
<tr><td>John Doe</td><td>21000</td><td>2013-11-01</td><td>2020-01-10 00:00:00</td></tr>
<tr><td>Peter Smith</td><td>23400</td><td>2018-03-25</td><td>2020-04-12 12:10:13</td></tr>
<tr><td>Jane Doe</td><td>26800</td><td>2017-03-14</td><td>2020-10-06 10:00:05</td></tr>
</tbody>
</table>
"))


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
  md.add("# Barplot")
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
  
  md.clear()
  md.addPlot({
    plot(mtcars$mpg ~ mtcars$hp)
    abline(h = mean(mtcars$mpg))
  })
  outFile <- paste0(getwd(), "/mtcars.html")
  write(md.asHtml(), outFile)
  print(paste("Wrote mtcars plot html to", outFile))
  assertThat(md.asHtml(), str.beginsWith("<p><img src=\"data:image/png;base64,"))
  assertThat(md.asHtml(), str.endsWith("\" alt=\"\" /></p>\n"))
}

test.links <- function() {
  md.clear()
  md.add("[Google](http://www.google.se)")
  assertThat(md.asHtml(), equalTo("<p><a href=\"http://www.google.se\">Google</a></p>\n"))
}

test.imgUrl <- function() {
  md.clear()
  md.add(md.imgUrl("https://upload.wikimedia.org/wikipedia/commons/e/eb/Ash_Tree_-_geograph.org.uk_-_590710.jpg", alt="Tree"))
  assertThat(md.content(), equalTo("![Tree](https://upload.wikimedia.org/wikipedia/commons/e/eb/Ash_Tree_-_geograph.org.uk_-_590710.jpg)\n"))


  md.clear()
  md.add(md.imgUrl("https://upload.wikimedia.org/wikipedia/commons/e/eb/Ash_Tree_-_geograph.org.uk_-_590710.jpg", attr=list("id" = "mystyle", "class" = "image")))
  assertThat(md.content(), equalTo("![](https://upload.wikimedia.org/wikipedia/commons/e/eb/Ash_Tree_-_geograph.org.uk_-_590710.jpg){id=\"mystyle\" class=\"image\"}\n"))
  assertThat(md.asHtml(), equalTo(
"<p><img src=\"https://upload.wikimedia.org/wikipedia/commons/e/eb/Ash_Tree_-_geograph.org.uk_-_590710.jpg\" alt=\"\" id=\"mystyle\" class=\"image\" /></p>\n"
  ))
}

test.imgEmbed <- function() {
  md.clear()
  md.add(md.imgEmbed("https://upload.wikimedia.org/wikipedia/commons/d/dd/Accounting-icon.png"))
  assertThat(md.content(), equalTo("![](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAE0AAABNCAAAAADGYrZsAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH1gkeAAohA+PvmwAAAMhJREFUWMPtmFEOwiAQRBlKxSt4/zOaolbGDw1qIyEkm0jS2fSnKX3ZwsvSBScfo0eYQsj3if5wjAF+goNnJtdlSbc1LZdzWrNrBuarMwsA2ZDmnWXsiMbdfCksaaGYVx/DftrnK6DsFW1rSKX+9RnYoLHPQa2pqmXD3v5ShrqYoT+ButEw3QFhOm+zaW7Z1BCa0vLANNUQ0fZK4x9yo1ZBtG4aNW+iiSbaj3/ycTsj6qRxhNzw1R2CzwuvTeV9U55w00yiDAPdA+74PJ7jCTFiAAAAAElFTkSuQmCC)\n"))
  assertThat(md.asHtml(), equalTo("<p><img src=\"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAE0AAABNCAAAAADGYrZsAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH1gkeAAohA+PvmwAAAMhJREFUWMPtmFEOwiAQRBlKxSt4/zOaolbGDw1qIyEkm0jS2fSnKX3ZwsvSBScfo0eYQsj3if5wjAF+goNnJtdlSbc1LZdzWrNrBuarMwsA2ZDmnWXsiMbdfCksaaGYVx/DftrnK6DsFW1rSKX+9RnYoLHPQa2pqmXD3v5ShrqYoT+ButEw3QFhOm+zaW7Z1BCa0vLANNUQ0fZK4x9yo1ZBtG4aNW+iiSbaj3/ycTsj6qRxhNzw1R2CzwuvTeV9U55w00yiDAPdA+74PJ7jCTFiAAAAAElFTkSuQmCC\" alt=\"\" /></p>\n"))
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

test.asCharacter <- function() {
  md.clear()
  assertThat(as.character(md.add("# Title")), equalTo("# Title\n"))

  assertThat(paste0(md.getInstance(), "\n"), equalTo("# Title\n\n"))
}

test.md.new <- function() {
  md.new(paste("As stated before, 2 + 5 * pi ≈", round(2 + 5 * pi)))
  assertThat(md.content(), equalTo("As stated before, 2 + 5 * pi ≈ 18\n"))


  md.new()$add(paste("As stated before, 2 + 5 * pi ≈", round(2 + 5 * pi)))
  assertThat(md.content(), equalTo("As stated before, 2 + 5 * pi ≈ 18\n"))
}