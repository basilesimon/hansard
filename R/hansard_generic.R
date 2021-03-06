

# Hansard - Generic API Function
#
# A semi-generic function for the parliamentary API. Provides greater
# flexibility, including any newly released features or data not yet
# included in the individual functions of the hansard package.
#
# Users must specify '.json?' in their path. The function uses the default
# of 10 items per page, to include more include `'&_pageSize=[number]'`,
# e.g. `'&_pageSize=100'` to specifiy the maximum amount of
# 500 items per page.
#
# This function does not tidy any variable names.
#
#
#
# @param path The url path to the data you wish to retrieve.
#
# @export
# @examples \dontrun{
# x <- hansard_generic('elections.json?')
#
# y <- hansard_generic('elections.json?electionType=General Election')
# }


hansard_generic <- function(path) {
  .Defunct(package = NULL, msg = "Please use specific functions")

  url <- paste0("http://lda.data.parliament.uk/", utils::URLencode(path))

  mydata <- jsonlite::fromJSON(url)

  jpage <- floor(mydata$result$totalResults / mydata$result$itemsPerPage)

  seq_list <- seq(from = 0, to = jpage, by = 1)

  pages <- list()

  for (i in seq_along(seq_list)) {
    mydata <- jsonlite::fromJSON(paste0(url, "&_page=", i), flatten = TRUE)
    # message("Retrieving page ", i + 1, " of ", genericJPages + 1)
    pages[[i + 1]] <- mydata$result$items
  }

  df <- tibble::as_tibble(dplyr::bind_rows(pages))

  df
}
