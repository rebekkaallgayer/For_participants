##Data exploration and Visualisation 
#Material written by Dr. Alex Douglas at Aberdeen University
#you can find the instructions here: https://alexd106.github.io/QUADstatR/exercise_4.html for more details and background

#set your working directory
setwd() #this is the path to where you have stored the data
#for example, if you saved your data in Documents/workshop, your path would be "C:\Documents\workshop"

#this first section is covering basic plots in base R


#Import the ‘squid1.txt’ file into R using the read.table() function and assign it to a variable named squid. 
squid <- read.table("squid1.txt", header=T)

#These data were originally collected as part of a study published in Aquatic Living Resources1 in 2005. 
#The aim of the study was to investigate the seasonal patterns of investment in somatic and reproductive tissues 
#in the long finned squid Loligo forbesi caught in Scottish waters. 
#Squid were caught monthly from December 1989 - July 1991 (month and year variables). 
#After capture, each squid was given a unique specimen code, weighed (weight) and the sex determined (sex - only female squid are included here). 
#The size of individuals was also measured as the dorsal mantle length (DML) and the mantle weight measured without internal organs (eviscerate.weight). 
#The gonads were weighed (ovary.weight) along with the accessory reproductive organ (the nidamental gland, nid.weight, nid.length). 
#Each individual was also assigned a categorical measure of maturity (maturity.stage, ranging from 1 to 5 with 1 = immature, 5 = mature). 
#The digestive gland weight (dig.weight) was also recorded to assess nutritional status of the individual

#Use the str() function to display the structure of the dataset and the summary() function to summarise the dataset. 

str(squid)

summary(squid)
#How many observations are in this dataset? How many variables? 


#The year, month and maturity.stage variables were coded as integers in the original dataset. 
#Here we would like to code them as factors. 
#Create a new variable for each of these variables in the squid dataframe and recode them as factors. 

#factors are categories. these might be treatments, years, sites, etc
#imagine that you want to compare trends across years, sites, etc. this is easier to do with factors
squid$Year_f <- as.factor(squid$year)
squid$month_f <- as.factor(squid$month)
squid$maturity.stage_f <- as.factor(squid$maturity.stage)

#Use the str() function again to check the coding of these new variables.
str(squid)


############DOTCHARTS ############
#The humble cleveland dotplot is a great way of identifying if you have potential outliers in continuous variables. 
#Create dotplots (using the dotchart() function) for the following variables; DML, weight, nid.length and ovary.weight. 

dotchart(squid$DML)
dotchart(squid$weight)
dotchart(squid$nid.length)
dotchart(squid$ovary.weight)
#Do these variables contain any unusually large or small observations? 

#it looks like nid.length does! this turned out to be a recording error, and we can fix it
which(squid$nid.length > 400) #this gives the row of the value that is the outlier
squid$nid.length[11]
#then we can go in and change it
squid$nid.length[11] <- 43.2
#see if it worked
dotchart(squid$nid.length)

#you can play with different things like colours
dotchart(squid$DML, col="blue")

#or symbols
dotchart(squid$DML, pch=16)

#combine the two
dotchart(squid$DML, pch=16, col="blue")

#you can find all the pch values here: http://www.sthda.com/english/wiki/r-plot-pch-symbols-the-different-point-shapes-available-in-r


#If you prefer to create a single figure with all 4 plots you can always split your plotting device into 2 rows and 2 columns. 
par(mfrow=c(2,2))
dotchart(squid$DML, main="DML")
dotchart(squid$weight, main="Weight")
dotchart(squid$nid.length, main="nid.length")
dotchart(squid$ovary.weight, main="ovary weight")


#########HISTOGRAMS########

#When exploring your data it is often useful to visualise the distribution of continuous variables. 
#create histograms for the variables; DML, weight, eviscerate.weight and ovary.weight using the hist() function

par(mfrow=c(2,2))
hist(squid$DML, main="DML")
hist(squid$weight, main="Weight")
hist(squid$eviscerate.weight, main="Eviscerate.weight")
hist(squid$ovary.weight, main="Ovary.weight")


######SCATTERPLOTS #######

#Scatterplots are great for visualising relationships between two continuous variables. 
#Plot the relationship between DML on the x axis and weight on the y axis. 
par(mfrow=c(1,1))
plot(x=squid$DML, y=squid$weight)

#How would you describe this relationship? Is it linear? 


#####BOXPLOTS ######
#When visualising differences in a continuous variable between levels of a factor (categorical variable) then a boxplot is your friend 
#Create a boxplot to visualise the differences in DML at each maturity stage (don’t forget to use the recoded version of this variable you created)
boxplot(DML ~ maturity.stage_f, data = squid, ylab = "DML", xlab = "Maturity stage")

#The thick horizontal line in the middle of the box is the median value of DML. 
#The upper line of the box is the upper quartile (75th percentile) and the lower line is the lower quartile (25th percentile). 
#The distance between the upper and lower quartiles is known as the inter quartile range and represents the values of weight for 50% of the data. 
#The dotted vertical lines are called the whiskers and their length is determined as 1.5 x the inter quartile range. 
#Data points that are plotted outside the the whiskers represent potential unusual observations. 


##linear models if you're looking at relationships
## this is a linear relationship of the format y=mx+b
lm1 <- lm(weight ~ DML, data=squid) #this format is response variable ~ explanatory variable, so y ~ x
summary(lm1)
#under coefficients, your (Intercept) Estimate is your b (-407.71171)
#and your DML estimate is your slope (m), (3.23068)

#let's see how it looks on top of our data
plot(weight ~ DML, data=squid)
lines(x=squid$DML, y=summary(lm1)$coefficients[1] +summary(lm1)$coefficients[2]*squid$DML, col="red")
mtext(paste("Adj R2= ", round(summary(lm1)$adj.r.squared,digits=2) ,sep=""), side=1, line=-2, adj=1)
#the R2 value measures how well the linear model predicts the real data

#it is always important to inspect the diagnostics plots for your linear models to make sure you are not violating any assumptions
par(mfrow=c(2,2))
plot(lm1)

#the top left plot is testing whether the residuals exhibit non-linear patterns, we want it to be roughly horizontal
#the top right plot is testing whether the residuals are normally distributed
#the bottom left plot is testing equal variance, if the red line is about horizontal, then assumption of equal variance is met
#the bottom right plot is looking at influential values, so if any values fall outside of Cook's distance, it is an influential data point

#the residuals are the differences between the real data point and the line of the linear model

#these plots don't look quite right
#top left is not horizontal, and bottom left is not horizontal
#the Normal QQ plot looks a little bit off, the points should follow the dotted line (although in real data, it is rare that this is perfect!)

#let's see if we can linearise it
#One approach to linearising relationships is to apply a transformation on one or both variables. 
#Try transforming the weight variable with either a natural log (log()) or square root (sqrt()) transformation. 
#I suggest you create new variables in the squid dataframe for your transformed variables
squid$weight_log <- log(squid$weight)
par(mfrow=c(1,1))
plot(x=squid$DML, y=squid$weight_log)
#that looks a bit different!

#let's try the lm again
lm2 <- lm(weight_log ~ DML, data=squid)
summary(lm2)

par(mfrow=c(2,2))
plot(lm2)
#that's a bit better!
#they are still not perfect but real data is rarely perfect! we have made it better and can accept assumptions of linear models

#we can try the square root
squid$weight_sqrt <- sqrt(squid$weight)
par(mfrow=c(1,1))
plot(x=squid$DML, y=squid$weight_sqrt)
#that looks a bit different!

#let's try the lm again
lm3 <- lm(weight_sqrt ~ DML, data=squid)
summary(lm3)

par(mfrow=c(2,2))
plot(lm3)

#this might be the best transformation so let's plot the data with the linear model
par(mfrow=c(1,1))
plot(weight_sqrt ~ DML, data=squid)
lines(x=squid$DML, y=summary(lm3)$coefficients[1] +summary(lm3)$coefficients[2]*squid$DML, col="red")
mtext(paste("Adj R2= ", round(summary(lm3)$adj.r.squared,digits=2) ,sep=""), side=1, line=-2, adj=1)


##### USING GGPLOT2 ########
#These figures are perfectly fine to include in a paper, but often, using ggplot creates "nicer" figures
install.packages("ggplot2")
library("ggplot2")

hist_figure <- ggplot(squid, aes(x=DML)) + #we name our plot so that we can call it at any time
  #the + here is very important! This is how you add elements to your plot
  geom_histogram() + #so here, we are saying "make a ggplot object" AND create a histogram from the data
  labs(title="DML", x="DML", y="Frequency")
  

plot(hist_figure)

#you can make multiple histograms for DML by maturity stage
hist_4 <- hist_figure + #and now we can take the data from figure1 AND add the multiple panels
  facet_wrap(~ maturity.stage_f, nrow = 2) +
  theme_minimal() #this removes the grey background

plot(hist_4)


#create a boxplot
box_figure<- ggplot(squid, aes(x=maturity.stage_f, y=DML)) +
  geom_boxplot() +
  theme_minimal()

plot(box_figure)

##you can do a lot with gggplot, you can find more details for boxplots here: http://www.sthda.com/english/wiki/ggplot2-box-plot-quick-start-guide-r-software-and-data-visualization

##one of the best things about ggplot is that it's easy to save a high resolution figure 
ggsave("boxplot_DML.jpeg", box_figure, device="jpeg", dpi=1500 )
#the dpi is "dots per inch" and is your resolution. journals require high res images
#you can change jpeg to png if you want too!

