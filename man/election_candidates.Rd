% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/election_candidates.R
\name{election_candidates}
\alias{election_candidates}
\alias{hansard_election_candidates}
\title{Election candidate details}
\usage{
election_candidates(ID = NULL, constit_details = FALSE,
  extra_args = NULL, tidy = TRUE, tidy_style = "snake_case",
  verbose = TRUE)

hansard_election_candidates(ID = NULL, constit_details = FALSE,
  extra_args = NULL, tidy = TRUE, tidy_style = "snake_case",
  verbose = TRUE)
}
\arguments{
\item{ID}{Accepts an ID for a general or by-election from the 2010 General
Election onwards, and returns the results. If \code{NULL}, returns all
available election results. Defaults to \code{NULL}.}

\item{constit_details}{If \code{TRUE}, returns additional details on each
constituency, including its GSS (Government Statistical Service) code.
Defaults to \code{FALSE}.}

\item{extra_args}{Additional parameters and queries to pass to API. These
queries must be strings and start with "&". See the
\href{http://explore.data.parliament.uk/}{API documentation}
or the package vignette for more details. Defaults to \code{NULL}.}

\item{tidy}{Logical parameter. If \code{TRUE}, fixes the variable names
in the tibble to remove special characters and superfluous text, and
converts the variable names to a consistent style. Defaults to \code{TRUE}.}

\item{tidy_style}{The style to convert variable names to, if
\code{tidy = TRUE}. Accepts one of \code{'snake_case'}, \code{'camelCase'}
and \code{'period.case'}. Defaults to \code{'snake_case'}.}

\item{verbose}{If \code{TRUE}, displayes messages on the console on the
progress of the API request. Defaults to \code{TRUE}.}
}
\description{
Returns the name and party of all candidates standing in an election, for
each constituency. Note that for general elections this can return a very
large tibble with hundreds of variables.
}
\examples{
\dontrun{
x <- election_candidates(ID = 382037)

y <- election_candidates()

z <- election_candidates(constit_details = TRUE)
}

}
\seealso{
\code{\link[=elections]{elections()}}

\code{\link[=election_results]{election_results()}}
}
