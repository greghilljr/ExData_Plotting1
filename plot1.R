# Load packages
library(tidyverse)
library(here)

# Download and unzip dataset
file <- here('ext','household_power_consumption.txt')
if (!file.exists(file)){
    dir.create("ext")
    URL <-
        'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
    download.file(URL, 'ext/Dataset.zip')
    unzip(
        'ext/Dataset.zip',
        files = NULL,
        list = FALSE,
        overwrite = TRUE,
        junkpaths = FALSE,
        exdir = "ext",
        unzip = "internal",
        setTimes = FALSE
    )
    ## Cleanup files
    file.remove('ext/Dataset.zip')
    rm(URL)
}
if(exists('data') &&
   is.data.frame(get('data')) == FALSE) {
    data <- read.table(
        file,
        header = TRUE,
        sep = ";",
        na.strings = "?",
        stringsAsFactors = FALSE
    )
    data <- data %>% filter(Date %in% c('1/2/2007', '2/2/2007'))
    data <-
        data %>% mutate(datetime = lubridate::dmy_hms(paste(Date, Time)))
}
# Make plot
png(filename = "plot1.png")
with(data,
     hist(
         Global_active_power,
         col = 'red',
         main = 'Global Active Power',
         xlab = 'Global Active Power (kilowatts)'
     ))
dev.off()
