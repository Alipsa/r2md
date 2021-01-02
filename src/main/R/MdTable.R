md.table <- function(df, htmlattr=NA) {
  df <- format(df)
  table <- "\n"
  headerNames <- paste(trimws(names(df)), collapse = " | ")
  table <- paste0(table, headerNames, "\n")
  headerLines <- paste(rep("---", ncol(df)), collapse = " | ")
  table <- paste0(table, headerLines, "\n")

  rows <- paste(apply(df, 1, paste, collapse=" | "), collapse="\n")
  table <- paste0(table, rows, "\n")

  return(table)
}