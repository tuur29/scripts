# /usr/bin/Rscript

# This R script was made to quickly visualize and offer some simple statistics
# for csv files with a unix timestamp and a corresponding integer value.
#
# This script was made to be run from a R terminal like: ` source("visualizeTimeValuePairs.R") `
# 
# Your csv file should look like this (including header):
# timestamp,value
# 1522491006,19.43
# 1522491606,19.43
# 1522492208,19.43
# 1522492806,19.29
# 

# CONFIG

useSimpelerGraphView <- FALSE # Set this to true if plot isn't showing (also try updating R)


# CODE


# installing necessary libraries & load them
options(warn=1)
list.of.packages <- c("zoom","xts","dygraphs")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library("zoom")
library("xts")
library("dygraphs")


# read data
data <- read.csv(file.choose(), header=TRUE, sep=",");


# show plot of data
if (useSimpelerGraphView) {

    plot(as.POSIXct(data$timestamp, origin="1970-01-01", tz="GMT"), data$value, xlab="Time", ylab="Value", type="h");
    axis(2, tck = 1, lty = 2, col = "#333333", labels = NA)
    zm()

} else {

    xt <- xts(x = data$value, order.by = as.POSIXct(data$timestamp, origin="1970-01-01", tz="GMT"))
    print(dygraph(xt, xlab="Time", ylab="Value") %>% dyRangeSelector())

}


# show summary
cat("\014") # clear console

cat("\n")
cat(paste( "First recorded date: " , as.POSIXct(min(data$timestamp), origin="1970-01-01", tz="GMT") ));
cat("\n")
cat(paste( "Last recorded date: " , as.POSIXct(max(data$timestamp), origin="1970-01-01", tz="GMT") ));
cat("\n\n")
print(summary(data$value));
cat("\n")
