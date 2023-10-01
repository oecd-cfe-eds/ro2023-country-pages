# use rvest to read the html file, and then extract the first table

#' Read HTML table and render it nicely with Quarto
#' @importFrom rvest read_html html_elements
#' @importFrom stringr str_replace_all str_trim
#' @importFrom htmltools HTML
#' @param ctry country code
#' @param table table number (default: 1)
#' @return HTML table
#' @export
read_html_table <- function(ctry, table = 1L) {
  finp <- list.files(path = "revisited_drafts", pattern = ".html", full.names = TRUE)
  finp <- finp[grepl(ctry, finp)]

  tbl <- html_elements(read_html(finp), "table")[[1]]
  tbl <- as.character(tbl)
  tbl <- str_replace_all(tbl, "\\(unitary/federal\\)|\\(number\\)|\\(i.e, amount\\)|<em>\\(specify date\\)<\\/em>", "")
  tbl <- str_replace_all(tbl, "\\s+", " ")
  # tbl <- str_replace_all(tbl, "\\* ", "\u2022 ")
  tbl <- str_replace_all(tbl, "<li> <p>", "<li>")
  tbl <- str_replace_all(tbl, "</p> </li>", "</li>")
  tbl <- str_replace_all(tbl, "<blockquote> <p>", "")
  tbl <- str_replace_all(tbl, "</p> </blockquote>", "")

  # find text between "* " and "<ul>", replace with "<ul><li> ... </li></ul>"
  pos <- gregexpr("\\* .*<ul>", tbl)

  for (i in seq_along(pos)) {
    if (pos[[i]][1] > 0) {
      # find the first <ul> after "* "
      tbl2 <- substr(tbl, pos[[i]][1], nchar(tbl))
      pos2 <- gregexpr("<ul>", tbl2)[[1]][1]

      # replace the "* " in the position pos[[i]][1] with "<ul><li>"
      tbl <- paste0(substr(tbl, 1, pos[[i]][1] - 1), "<ul><li>", substr(tbl, pos[[i]][1] + 2, nchar(tbl)))

      # replace the "<ul>" in the position pos[[i]][1] + pos2 with "</li></ul><ul>"
      tbl <- paste0(substr(tbl, 1, pos[[i]][1] + pos2 + 3), "</li></ul>", substr(tbl, pos[[i]][1] + pos2 + 4, nchar(tbl)))
    }
  }

  tbl <- str_trim(tbl)

  tbl <- HTML(tbl)

  return(tbl)
}

#' Read HTML policy development text and render it nicely with Quarto
#' @param ctry country code
#' @importFrom htmltools HTML
#' @return Text for policy developments
#' @export
read_html_text <- function(ctry) {
  finp <- list.files(path = "revisited_drafts", pattern = ".html", full.names = TRUE)
  finp <- finp[grepl(ctry, finp)]

  txt <- readLines(finp)
  # delete all lines before "<p>Recent policy developments</p>"
  pos <- grep("Recent policy developments", txt)
  if (length(pos) == 0) {
    stop("No <p>Recent policy developments</p> found in ", finp)
  }
  txt <- txt[(pos + 1):length(txt)]

  # delete all lines after "</body>"
  pos2 <- grep("</body>", txt)
  if (!is.null(pos2)) {
    txt <- txt[1:(pos2 - 1)]
  }

  # put all lines together
  # txt <- paste(txt, collapse = "\n")
  txt <- HTML(txt)

  return(txt)
}
