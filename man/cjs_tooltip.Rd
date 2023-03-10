% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cjs_tooltip.R
\name{cjs_tooltip}
\alias{cjs_tooltip}
\title{Modify tooltips}
\usage{
cjs_tooltip(
  p,
  label,
  title,
  beforeTitle,
  afterTitle,
  footer,
  beforeFooter,
  afterFooter
)
}
\arguments{
\item{p}{chartjs object}

\item{label}{=}

\item{title}{= 'title_text'}

\item{beforeTitle}{= 'beforeTitle_text'}

\item{afterTitle}{= 'afterTitle_text'}

\item{footer}{= 'footer_text',}

\item{beforeFooter}{= 'beforeFooter_text'}

\item{afterFooter}{= 'afterFooter_text'}
}
\value{
An object of class \code{htmlwidget}
}
\description{
Uses a callback function within chartjs. Reference elements using template literal
notation e.g. 'x value: ${x}, y value: ${y}'.
See \code{vignette('tooltips-and-interaction-modes', package = 'chartjs4r')}
}
