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
      } else if (class(prime) == "htest") {
        mdString <- md.htest(prime, ...)
      } else {
        mdString <- paste0(as.character(prime), collapse = "")
      }
      content <<- paste0(content, mdString, "\n")
      invisible(.self)
    },

    addPlot = function(func, ...) {
      mdString <- md.imgPlotComplex(func, ...)
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

# we to the matching in the Markdown class so accept any object to the md.add generic
setMethod('md.add', signature("ANY"),
   function(x, ...) {
     checkVar()
     .r2mdEnv$md$add(x, ...)
   }
)

md.addPlot <- function(x, ...) {
  if (!is.call(substitute(x))) {
    # this is not a 100% guarantee that the code plock is a plot but we want the flexibility to
    # call ggplot2, lattice etc. so cannot do better than this check
    stop(paste("first argument is not an anonymous code block, this does not look correct"))
  }
  checkVar()
  .r2mdEnv$md$addPlot(x, ...)
}

md.new <- function(content=NULL, ...) {
  md.clear()
  if (!is.null(content)) {
    md.add(content, ...)
  }
  .r2mdEnv$md
}

md.clear <- function() {
  checkVar()
  .r2mdEnv$md <- Markdown$new()
  #assign("html", html, envir = .GlobalEnv)
  .r2mdEnv$md
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

md.getInstance <- function() {
  checkVar()
  .r2mdEnv$md
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