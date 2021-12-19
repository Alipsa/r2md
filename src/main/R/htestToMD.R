md.htest <- function(x, digits = getOption("digits"), prefix = "### ", ...) {
  s <- "\n"
  s <- paste0(s, strwrap(x$method, prefix = prefix), sep = "\n")
  s <- paste0(s, "\n")
  s <- paste0(s, "data:  ", x$data.name, "\n", sep = "")
  out <- character()
  if(!is.null(x$statistic))
    out <- c(out, paste(names(x$statistic), "=",
                        format(signif(x$statistic, max(1L, digits - 2L)))))
  if(!is.null(x$parameter))
    out <- c(out, paste(names(x$parameter), "=",
                        format(signif(x$parameter, max(1L, digits - 2L)))))
  if(!is.null(x$p.value)) {
    fp <- format.pval(x$p.value, digits = max(1L, digits - 3L))
    out <- c(out, paste("p-value",
                        if(substr(fp, 1L, 1L) == "<") fp else paste("=",fp)))
  }
  s <- paste0(s, strwrap(paste(out, collapse = ", ")), sep = "\n")

  if(!is.null(x$alternative)) {
    s <- paste0(s, "alternative hypothesis: ")
    if(!is.null(x$null.value)) {
      if(length(x$null.value) == 1L) {
        alt.char <-
          switch(x$alternative,
                 two.sided = "not equal to",
                 less = "less than",
                 greater = "greater than")
        s <- paste0(s, "true ", names(x$null.value), " is ", alt.char, " ",
                    x$null.value, "\n", sep = "")
      }
      else {
        s <- paste0(s, x$alternative, "\nnull values:\n", sep = "")
        s <- paste0(s, x$null.value, digits=digits, ...)
      }
    }
    else s <- paste0(s, x$alternative, "\n", sep = "")
  }
  if(!is.null(x$conf.int)) {
    s <- paste0(s, format(100 * attr(x$conf.int, "conf.level")),
                " percent confidence interval:\n", " ",
                paste(format(c(x$conf.int[1L], x$conf.int[2L])), collapse = " "),
                "\n", sep = "")
  }
  if(!is.null(x$estimate)) {
    s <- paste0(s, "sample estimates:\n")
    for (i in seq_along(x$estimate)) {
      s <- paste0(s, paste(names(x$estimate[i]), round(x$estimate[i], digits), sep=": ", collapse=": "), sep="\n", collapse="\n")
    }
  }
  s <- paste0(s, "\n")
  s
}