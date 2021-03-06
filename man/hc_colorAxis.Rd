% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/api-hc.R
\name{hc_colorAxis}
\alias{hc_colorAxis}
\title{Adding Color Axis options to highchart objects}
\usage{
hc_colorAxis(hc, ...)
}
\arguments{
\item{hc}{A \code{highchart} \code{htmlwidget} object.}

\item{...}{Arguments are defined in \url{http://api.highcharts.com/highmaps#colorAxis}.}
}
\description{
Function to set the axis color to highcharts objects.
}
\examples{


nyears <- 5

df <- expand.grid(seq(12) - 1, seq(nyears) - 1)
df$value <- abs(seq(nrow(df)) + 10 * rnorm(nrow(df))) + 10
df$value <- round(df$value, 2)
ds <- list.parse2(df)


hc <- highchart() \%>\% 
  hc_chart(type = "heatmap") \%>\% 
  hc_title(text = "Simulated values by years and months") \%>\% 
  hc_xAxis(categories = month.abb) \%>\% 
  hc_yAxis(categories = 2016 - nyears + seq(nyears)) \%>\% 
  hc_add_series(name = "value", data = ds)

hc_colorAxis(hc, minColor = "#FFFFFF", maxColor = "#434348")

hc_colorAxis(hc, minColor = "#FFFFFF", maxColor = "#434348",
             type = "logarithmic") 


require("viridisLite")

n <- 4
stops <- data.frame(q = 0:n/n,
                    c = substring(viridis(n + 1), 0, 7),
                    stringsAsFactors = FALSE)
stops <- list.parse2(stops)

hc_colorAxis(hc, stops = stops, max = 75) 

}

