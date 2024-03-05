##Yogyakarta workshop: creating maps in R

#libraries
install.packages("terra")
install.packages("sf")
#install.packages("ggplot2")
library("terra")
library("ggplot2")
library("sf")
#you can explore all the possible layers in ggplot2 here : https://ggplot2.tidyverse.org/reference/index.html

#set your working directory
setwd() #this is the path to where you have stored the data
#for example, if you saved your data in Documents/workshop, your path would be "C:\Documents\workshop"

##read in a shape file and plot in terra
#the map of Indonesia came from https://gadm.org/download_country.html

indo_0 <- vect("gadm41_IDN_shp/gadm41_IDN_0.shp") 
plot(indo_0)

#more detail, districts
indo_1<- vect("gadm41_IDN_shp/gadm41_IDN_1.shp")
plot(indo_1)

#EVEN more detail
indo_2<- vect("gadm41_IDN_shp/gadm41_IDN_2.shp")
plot(indo_2)


##we will continue on with indo_0
#to make our lives easier, we turn this into an sf object
#you don't need to worry about why, it is for conserving latitude/longitude
indo_sf <- st_as_sf(indo_0)


#we are using the package ggplot2 which creates very nice publication-quality figures
#and is very flexible 

#we can plot all of Indonesia in a basic plot
figure1 <-  #we name our plot so that we can call it at any time
  
  ggplot() + #this is the basic ggplot object. you need to call this anytime you make a new ggplot
            #the + here is very important! This is how you add elements to your plot
             #so here, we are saying "make a ggplot object" AND take data from indo_0, with these colours
  geom_sf(data = indo_sf, # sf format
          color = "black",
          fill = "gray90"
  )

#

plot(figure1)

#and now we add elements that we like

#maybe we don't want the whole country, maybe we want only one island
#let's say we want Java

figure2 <- figure1 + #and now we can take the data from figure1 AND add coord_sf details
  
  coord_sf(xlim = c(100, 130), #x axis coordinates (longitude)
           ylim = c(-11, -5), #y axis coordinates (latitude)
           expand = FALSE)

plot(figure2)


#you have your map!
#now we can play with what it looks like

#how about making it print the degree symbols on the axes

figure3 <- figure2 + #take figure2 AND edit the axes
  
  scale_y_continuous(labels = ~ paste0(.x, "°", "N")) + #the scale_x_continuous() object will edit the x axis
  
  scale_x_continuous(labels = ~ paste0(.x, "°", "E")) #the scale_y_continuous() object will edit the y axis

plot(figure3)
  

##If we want to get rid of the grey background

figure4<- figure3 +
  
  theme(panel.background = element_blank(), #this gets rid of the background
        axis.line = element_line(), #this makes sure the axis line is still there
        panel.border = element_rect(colour = "black", fill=NA, linewidth=1)) #add a box around it

plot(figure4)

###there are many MANY things you can edit in ggplot
#if you are curious, you can go to this site: https://www.rdocumentation.org/packages/ggplot2/versions/3.5.0
#if you scroll down, there is a long list of functions you can add for specific things


#we will play with a couple more

#adding study sites

#create a dataframe of your coordinates you want to plot
sites<- data.frame(Lat=c(-7, -7.5), Long=c(110,113)) 

figure5 <- figure4 +
  geom_point(data = sites,
             aes(x = Long,
                 y = Lat),
             size = 2, #how big are the dots?
             shape = 21, #21 is the code for dots
             fill = "black" #colour
  )
plot(figure5)

#you can play with the size, shape and colour!


#let's add some text to your map

figure6 <- figure5 +
  annotate("text",
         label = c("JAVA"),
         x = c(105),
         y = c(-9),
         color = "gray48",
         size = 5.5)
plot(figure6)



##ok we've seen some of the basics, let's save our plot in high resolution
ggsave("Java.jpeg", figure6, device="jpeg", dpi=1500 )
#the dpi is "dots per inch" and is your resolution. journals require high res images
#you can change jpeg to png if you want too!


##if you want to get really fancy, you can create this Java map with an inset of the larger Indonesia map


#first we create the insert
inset_map <- indo_sf %>%
  ggplot() + #it gets its own ggplot object
  
  geom_sf() + 
  
  geom_rect(aes(xmin = 100, #we create a rectangle within Indonesia that shows where Java is
                xmax = 130,
                ymin =-11,
                ymax = -5),
            color = "red",
            linewidth = 1,
            fill = NA) +
  
  labs(x = NULL,
       y = NULL) +
  
  #and we play with all the theme elements, getting rid of axes etc 
  theme(axis.text = element_blank(),
        axis.ticks = element_blank(),
        axis.ticks.length = unit(0, "pt"),
        axis.title=element_blank(),
        plot.margin = margin(0, 0, 0, 0, "cm"),
        panel.grid.major = element_blank(),
        panel.background = element_rect(fill = "lightskyblue"),
        panel.border = element_rect(fill = NA,
                                    linewidth = 1),
        
  ) +
  
  scale_x_continuous(expand=c(0,0)) +
  scale_y_continuous(expand=c(0,0)) +
  
  #and add a label
  annotate("text",
           label = "INDONESIA",
           x = c(125),
           y = c(4),
           color = "black",
           size = c(3),
           fontface = "bold"
  )
  
  
#then we simply add it to our figure6 in the correct place

figure7 <- figure6 +
  inset_element(inset_map,
                left = 0.7,
                bottom = 0.7,
                right = 1,
                top = 1,
                align_to = "full"
  )


figure7 <- figure6 +
  inset_element(inset_map,
                left = 0.75,
                bottom = 0.7,
                right = 1,
                top = 1,
                align="plot"
  )

  plot(figure7)

#and save!
ggsave("Java_insert.jpeg", figure7, device="jpeg", dpi=1500 )
#remember to change it to figure7!! and to change the name of the file, otherwise it will overwrite the previous one

java_ext<- ext(100,130,-11,-5)
java_crop <- crop(indo_0,java_ext)
plot(java_crop)

###


new_fig<-  #we name our plot so that we can call it at any time
  
  ggplot() + #this is the basic ggplot object. you need to call this anytime you make a new ggplot
  #the + here is very important! This is how you add elements to your plot
  #so here, we are saying "make a ggplot object" AND take data from indo_0, with these colours
  geom_sf(data = indo_sf, # sf format
          color = "black",
          fill = "gray90"
  )+
  coord_sf(xlim = c(100, 130), #x axis coordinates (longitude)
           ylim = c(-11, -5), #y axis coordinates (latitude)
           expand = FALSE) +
  
