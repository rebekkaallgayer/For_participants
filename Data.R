#Yogyakarta workshop: reading in your data


setwd() #set your working directory

#reading in a text file
#you've already read a text file in during this workshop, but let's do it again
squid <- read.table("squid1.txt", header=T) 
#here, we've told R that the first row in the data file contains the column names and 
#should NOT be considered data

#let's look at what kind of data type this is
class(squid)
#it says it's a dataframe, which means it can contain many different types of data
#integers, strings, factors, etc

# To examine the contents of the dataframe, one option would be to use the head() function 
#to display the first 5 rows of your dataframe.

head(squid)

#Another option would be to use the names() function which will return a vector of variable names from your dataset. 
names(squid)

#However, all you get are the names of the variables but no other information. 
#A much, much better option is to use the str()

str(squid)

#let's explore read.table()
?read.table()
#there are many things you could change so that it reads your data in properly


##reading in a csv file
gig <- read.csv("Gigartina.csv", header=T)
head(gig)
names(gig)
str(gig)

#if you are working from an excel file, I recommend either saving it from Excel as a tab delimited file (.txt)
#or a comma separated file (.csv) and read it in. it's much simpler!


#Summarising and manipulating dataframes is a key skill to acquire when learning R. 
#Although there are many ways to do this, we will concentrate on using the square bracket [ ] notation

#Extract all the elements of the first 10 rows and the first 4 columns of the squid dataframe and assign to a new variable called squid.sub.

squid.sub <- squid[1:10, 1:4] #so the [] are subsetting the data and because a dataframe is 2D, we have to specify rows and columns
#you always index a dataframe with row, column
squid.sub

#Next, extract all observations (remember - rows) from the dataframe and the columns month, weight and nid.length and assign to a variable called squid.len
#so those values are in columns 4, 5 and 11
squid.len <- squid[ , c(4,5,11)] 
#so we want all the rows, therefore we don't need to specify row numbers
#we still need the comma! otherwise R doesn't know we are specifying columns
#and we want multiple columns so we make a vector out of the three column numbers

#Extract all rows except the first 10 rows and all columns except the last column. 
# excluding first 10 rows and last column using negative indexing

#if you can't remember how many columns there are, use this:
ncol(squid)

squid.last <- squid[-c(1:10), -13]
#you could also write this as :
squid.last <- squid[-c(1:10), -c(ncol(squid))]

#Now, extract the first 12 rows and all columns from the original dataframe and assign to a variable squid.89
squid.89 <- squid[1:12, ]
#so here, we specify the rows, but want all columns so leave it blank but STILL NEED THE COMMA!

#there's a better way to do this! with conditional statements
squid.89 <- squid[squid$year == 1989,] 
#so we specify which column in squid using the $ symbol
#and the condition is "equal to", notice that it's ==, not only one!
#and you do this before the , !

#subset the data to get squid with DML > 200
squid.200 <- squid[squid$DML > 200, ] 

#you can also combine conditional statements
squid.200.stage2 <- squid[squid$DML >200 & squid$maturity.stage==2,]


#Another approach is to use the subset() function (see ?subset or search the Introduction to R book for the term ‘subset’for more details). Use the subset() function to extract all rows in ’May’ with a time at station less than 1000 minutes and a depth greater than 1000 m. Also use subset() to extract data collected in ‘October’ from latitudes greater than 61 degrees but only include the columns month, latitude, longitude and number.whales.

squid.200.sub <- subset(squid, DML >200 & maturity.stage==2)

##you can save any of these dataframes with write.table() or write.csv()
write.table(squid.200.sub, file ="Squid_200_stage2.txt", quote=FALSE)
#this creates a txt file with the data

write.csv(squid.200.sub, file ="Squid_200_stage2.csv", quote=FALSE)
#this creates a csv file

#you can do simple stats on the columns
mean(squid$DML)

##try reading in your own data and play with it for a while! 
##start here with your own code, don't change the code above!