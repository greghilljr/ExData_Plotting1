# Load packages
library(tidyverse)
library(here)

# Download and unzip dataset
file <- here('ext','household_power_consumption.txt')
if (!file.exists(file)){
    dir.create('ext')
    URL <-
        'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
    download.file(URL, 'ext/Dataset.zip')
    unzip(
        'ext/Dataset.zip',
        files = NULL,
        list = FALSE,
        overwrite = TRUE,
        junkpaths = FALSE,
        exdir = 'ext',
        unzip = 'internal',
        setTimes = FALSE
    )
    ## Cleanup files
    file.remove('ext/Dataset.zip')
    rm(URL)
}
exists('data')
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
# Set device
png(file = "plot4.png")

# Set columns & margins
par(mfcol= c(2,2), mar = c(4,4,3,2))

# Panel 1
with(
    data,
    plot(
        datetime,
        Global_active_power,
        type = 'l',
        xlab = '',
        ylab = 'Global Active Power'
    )
)

# Panel 2
with(data,
     plot(
         datetime,
         Sub_metering_1,
         type = 'l',
         xlab = '',
         ylab = 'Energy sub metering'
     ))
with(data,
     lines(datetime,
           Sub_metering_2,
           type = 'l',
           col = 'red'))
with(data, lines(datetime,
                 Sub_metering_3,
                 type = 'l',
                 col = 'blue'))
with(data, legend(
    'topright',
    c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'),
    col = c('black', 'red', 'blue'),
    lty = c(1, 1, 1),
    box.lwd = 0 # No box around key
))

# Panel 3
with(data,
     plot(datetime,
          Voltage,
          type = 'l'))

# Panel 4
with(data,
     plot(datetime,
          Global_reactive_power,
          type = 'l'))

dev.off()
