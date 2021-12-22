#' @param attr a list of name/value pairs that becomes markdown (and eventually html) attributes
#' @param nsmall is the used in format i.e. the minimum number of digits to the right of the decimal point in formatting
#' real/complex numbers in non-scientific formats. Allowed values are 0 <= nsmall <= 20
md.table <- function(df, attr=NULL, nsmall=NULL) {
  if (is.numeric(nsmall)) {
    df <- format(df, nsmall = nsmall)
  } else {
    df <- format(df)
  }
  table <- "\n"
  headerNames <- paste(trimws(names(df)), collapse = " | ")
  table <- paste0(table, headerNames, "\n")
  headerLines <- paste(rep("---", ncol(df)), collapse = " | ")
  table <- paste0(table, headerLines, "\n")

  rows <- paste(apply(df, 1, paste, collapse=" | "), collapse="\n")
  table <- paste0(table, rows, "\n")

  if (is.null(attr) || is.na(attr)) {
    attr <- list ( class = "table" )
  } else if (!"class" %in% names(attr) || !grepl("(?:^|\W)table(?:$|\W)", attr$class)) {
    attr$class <- trimws(paste(attr$class, "table"))
  }
  table <- paste0(table, extAttributes(attr, "\n"))

  return(table)
}