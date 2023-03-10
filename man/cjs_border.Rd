% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cjs_border.R
\name{cjs_border}
\alias{cjs_border}
\title{Border Configuration}
\usage{
cjs_border(
  display = TRUE,
  color = htmlwidgets::JS("Chart.defaults.borderColor"),
  width = 1,
  dash = NULL,
  dashOffset = 0,
  z = 0
)
}
\arguments{
\item{display}{boolean If true, draw a border at the edge between the axis and the chart area.}

\item{color}{The color of the border line. Defaults to Chart.defaults.borderColor}

\item{width}{number   1 The width of the border line.}

\item{dash}{number[] Yes  [] Length and spacing of dashes on grid lines. See MDN}

\item{dashOffset}{number Yes  0 Offset for line dashes. See MDN}

\item{z}{number   0 z-index of the border layer. Values <= 0 are drawn under datasets, > 0 on top.}
}
\value{
a list
}
\description{
Namespace: options.scales|scaleId|.border, it defines options for the border that run perpendicular to the axis.
}
