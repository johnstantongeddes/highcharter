library("dplyr")
library("purrr")

df <- data_frame(
  name = c("Animals", "Fruits", "Cars"),
  y = c(5, 2, 4),
  drilldown = tolower(name)
)

df

ds <- list.parse3(df)
names(ds) <- NULL
str(ds)

hc <- highchart() %>% 
  hc_chart(type = "column") %>% 
  hc_title(text = "Basic drilldown") %>% 
  hc_xAxis(type = "category") %>% 
  hc_legend(enabled = FALSE) %>% 
  hc_plotOptions(
    series = list(
      boderWidth = 0,
      dataLabels = list(enabled = TRUE)
    )
  ) %>% 
  hc_add_series(
    name = "Things",
    colorByPoint = TRUE,
    data = ds
  )

dfan <- data_frame(
  name = c("Cats", "Dogs", "Cows", "Sheep", "Pigs"),
  value = c(4, 3, 1, 2, 1)
)

dffru <- data_frame(
  name = c("Apple", "Organes"),
  value = c(4, 2)
)

dfcar <- data_frame(
  name = c("Toyota", "Opel", "Volkswage"),
  value = c(4, 2, 2) 
)

second_el_to_numeric <- function(ls){
  
  map(ls, function(x){
    x[[2]] <- as.numeric(x[[2]])
    x
  })
  
}

dsan <- second_el_to_numeric(list.parse2(dfan))

dsfru <- second_el_to_numeric(list.parse2(dffru))

dscar <- second_el_to_numeric(list.parse2(dfcar))


hc <- hc %>% 
  hc_drilldown(
    allowPointDrilldown = TRUE,
    series = list(
      list(
        id = "animals",
        data = dsan
      ),
      list(
        id = "fruits",
        data = dsfru
      ),
      list(
        id = "cars",
        data = dscar
      )
    )
  )

hc





#' Shorcut for create drilldown charts
#'
#' This function add a time series date to a \code{highchart} object.
#' 
#' This function remove all the existing series in the chart.
#' 
#' @param hc A \code{highchart} \code{htmlwidget} object. 
#' @param df A data frame object with the variables (this function considera all variables)
#' @param percent Show valuesa s counts/percents
#' 
#' @import dplyr
#' 
#' @export
hc_add_series_drilldown <- function(hc, df, percent = FALSE) {
  
  # df <- sample(letters[1:5], prob = 1:5/sum(1:5), replace = TRUE, size = 20)
  if (is.character(df) | is.factor(df)) df <- data_frame(df)
  
  assert_that(is.data.frame(df), nrow(df) > 0)
  
  # data(diamonds, package = "ggplot2")
  # df <- diamonds %>% select(cut, color, clarity)
  # df <- diamonds %>% select(cut, color)
  
  for (n in names(df)) df <- df %>% group_by_(n, add = TRUE)
  
  dfsum <- df %>%
    mutate_("value" = ifelse(percent, 1/nrow(df), 1)) %>% 
    summarize_("value" = "sum(value)") %>% 
    ungroup() %>% 
    map_if(is.factor, as.character) %>% 
    as.data.frame(stringsAsFactors = FALSE) %>% 
    tbl_df()
  
  # data series
  ds <- dfsum %>%
    mutate_("lvl1" = names(df)[1]) %>% 
    group_by_("lvl1") %>%
    summarize_("value" = "sum(value)") %>% 
    mutate_("drilldown" = "paste('lvl1',lvl1, sep = '-')")
  
  hc$x$hc_opts$series <- NULL
  
  # hc <- highchart()
  hc <- hc %>%
    hc_add_series(
      name = names(df)[1],
      colorByPoint =  TRUE,
      data = setNames(list.parse(ds), NULL)
    )
  
  
  #   # drilldown
  #   dd <- df %>% 
  #     group_by_(names(df)[1]) %>% 
  #     do(
  #       id = paste0("id-", as.character(unique(.[[names(df)[1]]]))),
  #       data = apply(count_(., names(df)[2]), 1, function(r){ 
  #         v <- as.vector(r)
  #         list(v[1], as.numeric(v[2]))
  #         })
  #     ) %>% 
  #     select(id, data) %>% 
  #     list.parse2()
  #   
  #   str(dd)
  #   
  # hc <- highchart(debug = TRUE)
  
  hc$x$hc_opts$series <- list(
    list(
      name = names(df)[1],
      colorByPoint =  TRUE,
      data = setNames(list.parse(ds), NULL)
    )
  )
  
  
  hc$x$hc_opts$drilldown <- list(series = setNames(dd, NULL))
  
  
  str(hc$x$hc_opts$drilldown)
  
  hc %>%
    hc_xAxis(type = "category")
  
  hc %>% hc_chart(type = "pie")
  
}

