# r2md
A Renjin R package that converts R objects and functions into markdown text or html

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

### Images

### Plots

