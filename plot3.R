# This is the third of four scripts for project 1 of the Coursera "Exploratory Data Analysis" class.
# This script reads the "Electric power consumption" dataset from the UC Irvine Machine 
# Learning Repository. 
#
# This is a stand-alone script which will download the data if it is not present,
# read the data and produce the plots.  No functions have been created to break 
# out the common parts of the four scripts so that each scrip can be used by 
# itself. This script can be run by typing 'source("plot3.R")' into the R console
#
# The dataset URL is: 
#   https://d396qusza40orc.cloudfront.net/exdata_data_household_power_consumption.zip
#
# After reading the data, this script generates a plot of three line graphs
# showing Energy use for the three sub_metering variables
# dates Feb 1, 2007 and Feb 2, 2007
#
# The result is stored in a png image called "plot3.png".

# A debug variable to cause print messages about program progress to be displayed.
dprint=FALSE

# some basic file locations/names.
fileurl="https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zipfile="exdata_data_household_power_consumption.zip"
filename="household_power_consumption.txt"

# First, get the zip file if it's not already in the current directory.
if (!file.exists(zipfile)) {
  if (dprint) { print("zipfile not found, downloading...") }
  download.file(fileurl,zipfile,method="curl")
}


# This opens a connection that read.csv2 can use reads the datafile from inside of 
# the zipfile, instead of executing the unzip and then reading the datafile from 
# the filesystem and taking up extra filesystem space.
file=unz(zipfile,filename)

# Now, read the first line of the data to get the column headings, which will be
# used below to set the column names of the final data.frame.
if (dprint) { print("reading headers") }
headers=as.character(read.csv2(file,header=FALSE,nrows=1,stringsAsFactors=FALSE))

# Recreate the connection because the first read destroys it.
file=unz(zipfile,filename)

# Next, read the actual data from the file. By manual inspection, it has been learned
# that the data of interest starts on line 66638 and there are 2880 entries that we want.
# (That's one entry per minute * 60 minutes * 24 hours, or 1440 per day for two days.)
# The classes of the data in each column were also determined this way, so cut down on
# the amount of work that read.csv2 does. I found that I needed to use dec="." for some
# reason, even though it should be the default, otherwise there was an error trying to
# read the real numbers.
# Only the data that is of interest ends up in the powerData data.frame

colclasses = c('Date','character',rep('numeric',7))
if (dprint) { print("reading data...")}
powerData=read.csv2(file,
             col.names=headers, colClasses=colclasses,
             skip=66637, nrows=2880,
             header=FALSE,
             dec=".")

# Finally, create the plot
png("plot3.png")  # The defaults for png are just right in this case.

# The main plot with the first set of data
plot(powerData$Sub_metering_1,
     type="l",
     col="black",
     ylab="Energy sub metering",
     xaxt="n",
     xlab="")

# Add the second dataset in red.
lines(powerData$Sub_metering_2,
      col="red")

# Add the third dataset in Blue
lines(powerData$Sub_metering_3,
      col="blue")

# Insert the legend
legend("topright",
       c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       col=c("black","red","blue"),
       lwd=1)

# Finally, add the X-axis with day names as the labels at the beginning, middle and end.
axis(1,at=c(0,1440,2880),labels=c("Thu","Fri","Sat"))

# ... and close the device.
dev.off()
