
#' House of Commons divisions
#'
#' Imports data on House of Commons divisions (votes), either full details
#' on how each member voted, or a summary of vote totals.
#'
#'
#' @param division_id The id of a particular vote. If empty, returns a
#' tibble with information on all commons divisions, subject to all other
#' parameters. Defaults to `NULL`. Only accepts a single division ID
#' at a time, but to return details on a list of division IDs use with
#' `lapply`.
#'
#' @param division_uin The UIN of a particular vote. If empty, returns a
#' tibble with information on all commons divisions, subject to all other
#' parameters. Defaults to `NULL`. Only accepts a single division UIN
#' at a time, but to return details on a list of division UINs use with
#' `lapply`.
#'
#' @param summary If `TRUE`, returns a small tibble summarising a
#' division outcome. Otherwise returns a tibble with details on how each
#' MP voted. Has no effect if `division_id` is empty. Defaults to `FALSE`.
#'
#'
#' @param start_date Only includes divisions on or after this date. Accepts
#' character values in `'YYYY-MM-DD'` format, and objects of class
#' `Date`, `POSIXt`, `POSIXct`, `POSIXlt` or anything
#' else that can be coerced to a date with `as.Date()`. Defaults
#' to `'1900-01-01'`.
#'
#'
#' @param end_date Only includes divisions on or before this date. Accepts
#' character values in `'YYYY-MM-DD'` format, and objects of class
#' `Date`, `POSIXt`, `POSIXct`, `POSIXlt` or anything
#' else that can be coerced to a date with `as.Date()`. Defaults to
#' the current system date.
#'
#' @inheritParams all_answered_questions
#'
#' @return A tibble with the results of divisions in the House of Commons.
#' @export
#' @examples
#' \dontrun{
#'
#' ## All commons divisions
#' x <- commons_divisions()
#'
#' ## Vote breakdown of specific commons division
#' y <- commons_divisions(division_id = 694163, summary = FALSE)
#' }
#'
commons_divisions <- function(division_id = NULL, division_uin = NULL,
                              summary = FALSE,
                              start_date = "1900-01-01",
                              end_date = Sys.Date(), extra_args = NULL,
                              tidy = TRUE, tidy_style = "snake_case",
                              verbose = TRUE) {
  dates <- paste0(
    "&_properties=date&max-date=",
    as.Date(end_date), "&min-date=",
    as.Date(start_date)
  )

  if (is.null(division_id) == TRUE & is.null(division_uin) == TRUE) {
    baseurl <- paste0(url_util, "commonsdivisions")

    if (verbose == TRUE) {
      message("Connecting to API")
    }

    divis <- jsonlite::fromJSON(paste0(
      baseurl, ".json?", dates,
      extra_args, "&_pageSize=1"
    ),
    flatten = TRUE
    )

    jpage <- floor(divis$result$totalResults / 100)

    query <- paste0(
      baseurl, ".json?", dates,
      extra_args, "&_pageSize=100&_page="
    )

    df <- loop_query(query, jpage, verbose) # in utils-loop.R
  } else if (!is.null(division_uin) & is.null(division_id) == TRUE) {
    baseurl <- paste0(url_util, "commonsdivisions.json?uin=")

    if (verbose == TRUE) {
      message("Connecting to API")
    }

    divis <- jsonlite::fromJSON(paste0(
      baseurl, division_uin,
      dates, extra_args
    ),
    flatten = TRUE
    )

    if (summary == TRUE) {
      df <- tibble::tibble(
        abstainCount = divis$result$primaryTopic$AbstainCount$`_value`,
        ayesCount = divis$result$primaryTopic$AyesCount$`_value`,
        noesVoteCount = divis$result$primaryTopic$Noesvotecount$`_value`,
        didNotVoteCount =
          divis$result$primaryTopic$Didnotvotecount$`_value`,
        errorVoteCount =
          divis$result$primaryTopic$Errorvotecount$`_value`,
        nonEligibleCount =
          divis$result$primaryTopic$Noneligiblecount$`_value`,
        suspendedOrExpelledVotesCount =
          divis$result$primaryTopic$Suspendedorexpelledvotescount$`_value`,
        margin = divis$result$primaryTopic$Margin$`_value`,
        date = divis$result$primaryTopic$date$`_value`,
        divisionNumber = divis$result$primaryTopic$divisionNumber,
        session = divis$result$primaryTopic$session[[1]],
        title = divis$result$primaryTopic$title,
        uin = divis$result$primaryTopic$uin
      )
    } else {
      df <- tibble::as_tibble(divis$result$items[["vote"]][[1]])
    }
  } else if (!is.null(division_id) & is.null(division_uin) == TRUE) {
    baseurl <- paste0(url_util, "commonsdivisions/id/")

    if (verbose == TRUE) {
      message("Connecting to API")
    }

    divis <- jsonlite::fromJSON(paste0(
      baseurl, division_id,
      ".json?", dates, extra_args
    ),
    flatten = TRUE
    )

    if (summary == TRUE) {
      df <- tibble::tibble(
        abstainCount = divis$result$primaryTopic$AbstainCount$`_value`,
        ayesCount = divis$result$primaryTopic$AyesCount$`_value`,
        noesVoteCount = divis$result$primaryTopic$Noesvotecount$`_value`,
        didNotVoteCount =
          divis$result$primaryTopic$Didnotvotecount$`_value`,
        errorVoteCount =
          divis$result$primaryTopic$Errorvotecount$`_value`,
        nonEligibleCount =
          divis$result$primaryTopic$Noneligiblecount$`_value`,
        suspendedOrExpelledVotesCount =
          divis$result$primaryTopic$Suspendedorexpelledvotescount$`_value`,
        margin = divis$result$primaryTopic$Margin$`_value`,
        date = divis$result$primaryTopic$date$`_value`,
        divisionNumber = divis$result$primaryTopic$divisionNumber,
        session = divis$result$primaryTopic$session[[1]],
        title = divis$result$primaryTopic$title,
        uin = divis$result$primaryTopic$uin
      )
    } else {
      df <- tibble::as_tibble(divis$result$primaryTopic$vote)
    }
  }

  if (nrow(df) == 0) {
    message("The request did not return any data.
                Please check your parameters.")
  } else {
    if (tidy == TRUE) {
       if (!is.null(division_uin)) {
        df <- cd_tidy(df, tidy_style, division_uin = division_uin, summary)
      } else {
        df <- cd_tidy(df, tidy_style, division_id = division_id, summary)
      }
      ## in utils-commons.R
    }

    df
  }
}


#' @rdname commons_divisions
#' @export
hansard_commons_divisions <- commons_divisions
