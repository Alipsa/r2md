# r2md
A Renjin R package that converts R objects and functions into markdown text or html

The approach is similar to [htmlcreator](https://github.com/perNyfelt/htmlcreator) which renders r objects directly into html
whereas this package renders r objects into markdown which can then be exported to html (or pdf or whatever).

r2md is an integral part in the support for the *mdr* file format which is somewhat
similar to *rmd* (r markdown) in the sense that it enables enhancing markdown with r code but
where rmd relies on knitr and "magic rules" for what and how to render r code, mdr puts the responsibility 
to generate markdown text from r code on you - and using r2md this is quite a pleasant 
experience giving you lots of control and power.

## Example usages:

### use md.add() to build your markdown document
```r
library("se.alipsa:r2md")
md.clear()
md.add("# Hello")
```
`md.content()` (which return the markdown as a string (character vector)) will equal `# Hello\n`

### Chained add
Assuming the following markdown:

#### Hello2
Some text
- bullet

This is how you can create that with r2md:
```r
library("se.alipsa:r2md")
md.clear()
md.add("#### Hello2")$add("Some text")$add("- bullet")
# convert the markdown to html and print it
print(md.asHtml())
```
will result in
```html
<h4>Hello2</h4>
<p>Some text</p>
<ul>
<li>bullet</li>
</ul>
```

### Adding a data.frame

The following table:

employee | salary | startdate | endDate
--- | --- | --- | ---
John Doe | 21000 | 2013-11-01 | 2020-01-10 00:00:00
Peter Smith | 23400 | 2018-03-25 | 2020-04-12 12:10:13
Jane Doe | 26800 | 2017-03-14 | 2020-10-06 10:00:05

...can be created as a data.frame in R and converted to markdown: 
```r
library("se.alipsa:r2md")
employee <- c('John Doe','Peter Smith','Jane Doe')
salary <- c(21000, 23400, 26800)
startdate <- as.Date(c('2013-11-1','2018-3-25','2017-3-14'))
endDate <- as.POSIXct(c('2020-01-10 00:00:00', '2020-04-12 12:10:13', '2020-10-06 10:00:05'), tz='UTC' )
df <- data.frame(employee, salary, startdate, endDate)
md.add(df)
```

`md.content()` will equal:
```

employee | salary | startdate | endDate
--- | --- | --- | ---
John Doe | 21000 | 2013-11-01 | 2020-01-10 00:00:00
Peter Smith | 23400 | 2018-03-25 | 2020-04-12 12:10:13
Jane Doe | 26800 | 2017-03-14 | 2020-10-06 10:00:05

```
...and `md.asHtml()` will equal:
```html
<table>
<thead>
<tr><th>employee</th><th>salary</th><th>startdate</th><th>endDate</th></tr>
</thead>
<tbody>
<tr><td>John Doe</td><td>21000</td><td>2013-11-01</td><td>2020-01-10 00:00:00</td></tr>
<tr><td>Peter Smith</td><td>23400</td><td>2018-03-25</td><td>2020-04-12 12:10:13</td></tr>
<tr><td>Jane Doe</td><td>26800</td><td>2017-03-14</td><td>2020-10-06 10:00:05</td></tr>
</tbody>
</table>
```

### Links
Adding links is just as expected: i.e. [Google](http://www.google.se) can be created

```r
md.clear()
md.add("[Google](http://www.google.se)")
```
... and when redered as html it will result in

```html
<p><a href="http://www.google.se">Google</a></p>

```

### Images
An image such as:

![Tree](https://upload.wikimedia.org/wikipedia/commons/e/eb/Ash_Tree_-_geograph.org.uk_-_590710.jpg)

can be referenced using 
```r
md.clear()
md.add("[Tree](https://upload.wikimedia.org/wikipedia/commons/e/eb/Ash_Tree_-_geograph.org.uk_-_590710.jpg)")
```
or, alternatively:

```r
md.clear()
md.add(md.imgUrl("https://upload.wikimedia.org/wikipedia/commons/e/eb/Ash_Tree_-_geograph.org.uk_-_590710.jpg", alt="Tree"))
```
This latter form is useful if you want to add attributes e.g:

```r
md.clear()
md.add(md.imgUrl("https://upload.wikimedia.org/wikipedia/commons/e/eb/Ash_Tree_-_geograph.org.uk_-_590710.jpg", attr=list(id = "mystyle", class = "image")))
```
md.content() will give you
`![](https://upload.wikimedia.org/wikipedia/commons/e/eb/Ash_Tree_-_geograph.org.uk_-_590710.jpg){id = 'mystyle', class = 'image'}\n`

...and md.asHtml() will result in
```html
<p><img src="https://upload.wikimedia.org/wikipedia/commons/e/eb/Ash_Tree_-_geograph.org.uk_-_590710.jpg" alt="" id="mystyle" class="image" /></p>

```

If you want to embed the image content in the file itself (e.g. to create self contained single html files)
you can use md.imgEmbed(fileNameOrUrl) to convert the file or url content to a base64 string, e.g:
```r
md.clear()
md.add(md.imgEmbed("https://upload.wikimedia.org/wikipedia/commons/d/dd/Accounting-icon.png"))
```
md.content() will be: `![](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAE0AAABNCAAAAADGYrZsAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH1gkeAAohA+PvmwAAAMhJREFUWMPtmFEOwiAQRBlKxSt4/zOaolbGDw1qIyEkm0jS2fSnKX3ZwsvSBScfo0eYQsj3if5wjAF+goNnJtdlSbc1LZdzWrNrBuarMwsA2ZDmnWXsiMbdfCksaaGYVx/DftrnK6DsFW1rSKX+9RnYoLHPQa2pqmXD3v5ShrqYoT+ButEw3QFhOm+zaW7Z1BCa0vLANNUQ0fZK4x9yo1ZBtG4aNW+iiSbaj3/ycTsj6qRxhNzw1R2CzwuvTeV9U55w00yiDAPdA+74PJ7jCTFiAAAAAElFTkSuQmCC)\n`

...and md.asHtml() will be: 
```html
<p><img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAE0AAABNCAAAAADGYrZsAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH1gkeAAohA+PvmwAAAMhJREFUWMPtmFEOwiAQRBlKxSt4/zOaolbGDw1qIyEkm0jS2fSnKX3ZwsvSBScfo0eYQsj3if5wjAF+goNnJtdlSbc1LZdzWrNrBuarMwsA2ZDmnWXsiMbdfCksaaGYVx/DftrnK6DsFW1rSKX+9RnYoLHPQa2pqmXD3v5ShrqYoT+ButEw3QFhOm+zaW7Z1BCa0vLANNUQ0fZK4x9yo1ZBtG4aNW+iiSbaj3/ycTsj6qRxhNzw1R2CzwuvTeV9U55w00yiDAPdA+74PJ7jCTFiAAAAAElFTkSuQmCC" alt="" /></p>

```
### Plots

The embedded technique is also used for plots. Behind the scenes the plot is exported to a png file which is
then embedded using the same technique as for md.imgEmbed(). Note thet the function name for the plot
(e.g. plot, barplot, hist etc.) is *separated* from the arguments of the function.
Here is an example of a barplot:

```r
md.clear()
md.add("# Barplot")
md.add(
  barplot,
  table(mtcars$vs, mtcars$gear),
  main="Car Distribution by Gears and VS",
  col=c("darkblue","red")
)
```

