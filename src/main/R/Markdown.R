Markdown <- setRefClass(
  Class = "Markdown",
  fields = list(
    content = "character"
  ),
  methods = list(

    initialize = function() {
      content <<- ""
    },

    add = function(prime, ...) {
      if (is.function(prime)) {
        mdString <- md.imgPlot(prime, ...)
      } else if (is.data.frame(prime)) {
        mdString <- ""
        if (!endsWith(content, "\n\n")) {
          mdString <- "\n"
        }
        mdString <- paste0(mdString, md.table(prime, ...))
      } else if (is.matrix(prime)) {
        mdString <- ""
        if (!endsWith(content, "\n\n")) {
          mdString <- "\n"
        }
        mdString <- paste0(mdString, md.table(as.data.frame(prime), ...))
      } else if (is.table(prime)) {
        mdString <- ""
        if (!endsWith(content, "\n\n")) {
          mdString <- "\n"
        }
        mdString <- paste0(mdString, md.table(as.data.frame(as.array(prime)), ...))
      }  else {
        mdString <- paste0(as.character(prime), collapse = "")
      }
      content <<- paste0(content, mdString, "\n")
      invisible(.self)
    },

    addImageFile = function(fileName) {
      if (!file.exists(fileName)) {
        stop(paste("File", fileName, "does not exist"))
      }
      content <<- paste0(content, md.imgFile(fileName))
      invisible(.self)
    },

    lf = function() {
      content <<- paste0(content,"\n")
    },

    clear = function() {
      content <<- ""
      invisible(.self)
    },

    getContent = function() {
      content
    },

    asHtml = function() {
      md.asHtml()
    },

    show = function(...) {
      cat(content)
      invisible(.self)
    }
  )
)

checkVar <- function() {
  if (!exists(".r2mdEnv", mode = "environment")) {
    .r2mdEnv <- new.env()
    assign(".r2mdEnv", .r2mdEnv, envir = .GlobalEnv)
  }
  if (!exists("md", envir = .r2mdEnv)) {
    .r2mdEnv$md <- Markdown$new()
    #assign("html", html, envir = r2md)
  }
}

setGeneric("md.add", function(x, ...) standardGeneric("md.add"))

setMethod('md.add', signature("character"),
  function(x) {
    checkVar()
    .r2mdEnv$md$add(x)
  }
)

setMethod('md.add', signature("numeric"),
  function(x) {
    checkVar()
    .r2mdEnv$md$add(x)
  }
)

setMethod('md.add', signature("data.frame"),
  function(x, ...) {
    checkVar()
    .r2mdEnv$md$add(x, ...)
  }
)

setMethod('md.add', signature("table"),
          function(x, ...) {
            checkVar()
            .r2mdEnv$md$add(x, ...)
          }
)

setMethod('md.add', signature("matrix"),
  function(x, ...) {
    checkVar()
    .r2mdEnv$md$add(x, ...)
  }
)

# arguments that the generic dispatches on can’t be lazily evaluated (http://adv-r.had.co.nz/S4.html)
# so we work around this by separating the function and its arguments, otherwise the signature to match on
# would be the result of the plot/hist call e.g. numeric which is not what we want
setMethod('md.add', signature("function"),
  function(x, ...) {
    checkVar()
    .r2mdEnv$md$add(x, ...)
  }
)

md.clear <- function() {
  checkVar()
  .r2mdEnv$md <- Markdown$new()
  #assign("html", html, envir = .GlobalEnv)
}

setMethod('as.vector', signature("Markdown"),
  function(x) {
    x$getContent()
  }
)

setMethod('as.character', signature("Markdown"),
  function(x) {
    x$getContent()
  }
)

setMethod('format', signature("Markdown"),
  function(x) {
    x$getContent()
  }
)

md.content <- function() {
  checkVar()
  .r2mdEnv$md$getContent()
}

md.asHtml <- function() {
  .getMd2html()$render(.r2mdEnv$md$getContent())
}

.getMd2html <- function() {
  checkVar()
  if (!exists("md2html", envir = .r2mdEnv)) {
    md2html <- Md2Html$new()
    assign("md2html", md2html, envir = .r2mdEnv)
  }
  .r2mdEnv$md2html
}

md.renderHtml <- function(mdText) {
  .getMd2html()$render(mdText)
}

extAttributes <- function(attr, endString="") {
  if (!is.list(attr)) {
    return("")
  }
  # we drop all list item that are not named so if you want to add an attribute like hidden, you need to do hidden="hidden"
  attr <- attr[names(attr) != ""]
  htmlattr <- paste(paste0(names(attr), '="', unlist(attr), '"'), collapse = " ")
  return(paste0("{", htmlattr, "}", endString))
}