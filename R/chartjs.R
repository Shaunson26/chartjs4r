#' Chartjs widget
#'
#' Basic Chartjs widget
#'
#' @param data Can be one of: a data.frame, SharedData or list of chartjs options (for a list,
#' see \href{https://www.chartjs.org/docs/latest/getting-started/usage.html}{chartjs usage}).
#' @param ... aesthetic parameters to pass on to chartjs chart types e.g. x, y, group, colors, TODO, ...
#' @param type chartjs type - 'bar', 'scatter', TODO (the others!)
#' @param plugins a list of plugins to include, TODO how make .. include id, and wrap JS code in JS()
#' @param return_data_ids `development` used with a functions in `chartjs.js` to return dataset ids in Shiny
#' @param width,height width and height in pixels (optional, defaults to automatic sizing)
#' @param elementId id of the widget created with this function
#'
#' @return An object of class `htmlwidget`
#'
#' @import htmlwidgets
#'
#' @export
chartjs <- function(data = data.frame(), ..., type = NULL, plugins = NULL, return_data_ids = FALSE, width = NULL, height = NULL, elementId = NULL) {


  if (!is.data.frame(data) && !crosstalk::is.SharedData(data) && !is.list(data)) {
    stop("First argument, `data`, must be a data frame, shared data, or list", call. = FALSE)
  }

  # Type can be null here if add_* will be used later
  stopifnot("type can be only one of: 'bar', 'scatter'" = is.null(type) | type %in% c('bar', 'scatter', 'doughnut', 'pie'))

  # "native" arguments
  if (is.list(data)) {
    x <- data
  }

  # R arguments
  if (is.data.frame(data) || crosstalk::is.SharedData(data)) {

    x <- list()
    x$source_data <- data
    x$type <- type

    dots <- rlang::enquos(...)
    dot_names <- names(dots)
    aes_names <- c('x', 'y', 'group')

    # build chart here
    # check x, y and then group
    data_selector_vars <- c('x', 'y', 'group')
    has_data_selector_vars <- any(data_selector_vars %in% names(dots))

    if (has_data_selector_vars){

      # Expect type if data is given, type value checked above
      stopifnot("type must be specified if plot aesthetics given" = !is.null(type))

      # data prep
      # create x,y,group dataset
      dots_aes <- dots[names(dots) %in% data_selector_vars]
      data_selected <- dplyr::select(data, !!!dots_aes)
      data_selected <- dplyr::arrange(data_selected, x)

      # arrange data by type
      x$data <-
        cjs_structure_data(data_selected, type = type)

      xy_class <-
        list(x = class(data_selected$x),
             y = class(data_selected$y))

      # TODO axes types - TODO general axes type function
      for(xy in names(xy_class)){
        is_datetime <- inherits(xy_class[[xy]], what = c('Date', "POSIXct", "POSIXt"))
        if (is_datetime){
          x$options$scales[[xy]] <- list(type = 'time')
        }
      }
    }
  }

  # add plugins, inhouse + user
  x$plugins <- list(canvasBackgroundColor())

  if (!is.null(plugins)){
    check_plugins(plugins)
    x$plugins <- c(x$plugins, plugins)
  }

  if (return_data_ids){
    x$return_data_ids = return_data_ids
  }

  # Default chartjs4r options
  x$options$maintainAspectRatio = FALSE
  x$options$resizeDelay = 250

  # create widget
  htmlwidgets::createWidget(
    name = 'chartjs',
    x,
    width = width,
    height = height,
    package = 'chartjs4r',
    elementId = elementId,
    sizingPolicy = htmlwidgets::sizingPolicy(
      browser.defaultWidth = NULL,
      browser.defaultHeight = NULL,
      padding = 0,
      defaultWidth = '100%',
      defaultHeight = '100%',
      browser.fill = TRUE,
      knitr.defaultWidth = '100%'
    )
  )
}

chartjs_html <- function(id, style, class, ...){
  htmltools::tags$div(id = id,
                      class = class,
                      style = style,
                      # set attributes as they are 300px from somewhere
                      # TODO find culprit
                      htmltools::tags$canvas(id = paste0(id, '-chartjs'),
                                             height = '100%', width = '100%')
  )
}

#' Shiny bindings for chartjs
#'
#' Output and render functions for using chartjs within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a chartjs
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name chartjs-shiny
#'
#' @export
chartjsOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'chartjs', width, height, package = 'chartjs4r')
}

#' @rdname chartjs-shiny
#' @export
renderChartjs <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, chartjsOutput, env, quoted = TRUE)
}

#' @rdname chartjs-shiny
#'
#' @param id element id
#' @param session shiny session
#' @param deferUntilFlush wait until after the next time Shiny flushes the reactive system
#'
#' @export
chartjsProxy <- function(id, session = shiny::getDefaultReactiveDomain(), deferUntilFlush = TRUE){

  if (is.null(session)) {
    stop("export must be called from the server function of a Shiny app")
  }

  structure(
    list(
      session = session,
      id = id,
      deferUntilFlush = deferUntilFlush,
      dependencies = NULL
    ),
    class = "chartjs_proxy"
  )
}


