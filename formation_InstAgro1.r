
# Loading package #####

library(tidyverse)

#where am I in my computer? where will R look for files and save objects?

getwd() #get your working directory

#set your own working directory

setwd("your path") #windows wants slash like this /, not \ !


# loading data ######

iris

#save your data in an object (it will appear on the "environment" square on the right)

mydata <- iris


# Look at your data ########

## head 
head(mydata)
head(mydata,n = 10)

## str
str(mydata)

## summary
summary(mydata)
## Ways to select one column 

mydata$Petal.Length
mydata[,1]
mydata[,"Species"]

# Table function = Number of rows per value of a factor
table(mydata$Species)


## mean= moyenne
mean(mydata$Sepal.Length)

summary(mydata$Sepal.Length)
mean(mydata$Petal.Width, na.rm = TRUE)

##check for missing data (returns TRUE if there are missing observations)

is.na(mydata)
is.na(mydata$Sepal.Length)

#  Boolean test########

# test ####

## > 
mydata$Sepal.Length > 6 
## != 
mydata$Species == "virginica"
mydata$Species != "virginica"
## which ####
which(mydata$Species == "virginica")
which(is.na(mydata$Sepal.Length)) # identify which observation is missing (if any)

#let's create some missing data
myobs <- data.frame(6 , 4, 1.5 , NA, NA)
names(myobs) <- c("Sepal.Length" , "Sepal.Width",  "Petal.Length", "Petal.Width",  "Species")
mydata2 <- rbind(mydata, myobs)

mean(mydata2$Petal.Width) #returns NA because R can't calculate mean if there are missing data 
is.na(mydata2$Petal.Width)
which(is.na(mydata2$Petal.Width))

mean(mydata2$Petal.Width, na.rm = TRUE) #unless you remove them!
 


# Dplyr ########
# select()  ########
select(mydata, Sepal.Length, Species)

mydata %>%
  select(Sepal.Length, Species)

#select all but the ones specified (-)
mydata %>%
  select(-Species, -Sepal.Length)



# mutate() ######## = create a new column
mydata %>%
  select(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width ) %>%
  mutate(sepal.ratio = Sepal.Length/Sepal.Width  ) 


# without the pipes

mutate(select(mydata,Sepal.Length, Sepal.Width, Petal.Length, Petal.Width), sepal.ratio = Sepal.Length/Sepal.Width)

# filter()  ########
mydata %>%
  select(Sepal.Length, Sepal.Width) %>%
  mutate(sepal.ratio = Sepal.Length/Sepal.Width ) %>%
  filter(sepal.ratio <= 2)

# without the pipes
filter(mutate(select(mydata,Sepal.Length, Sepal.Width, Petal.Length, Petal.Width), sepal.ratio = Sepal.Length/Sepal.Width),sepal.ratio <= 2)

#if you want to store this new column
mydata3 <- mydata %>%
  mutate(sepal.ratio = Sepal.Length/Sepal.Width )

#OR
mydata3 <- mydata #duplicate dataset
mydata3$sepal.ratio <- mydata$Sepal.Length/mydata$Sepal.Width



# arrange()  ######## = To oreder a line
mydata %>%
  select(Sepal.Length, Sepal.Width) %>%
  mutate(sepal.ratio = Sepal.Length/Sepal.Width ) %>%
  filter(sepal.ratio <= 2)%>%
  arrange(desc(sepal.ratio))

# without the pipes
arrange(filter(mutate(select(mydata,Sepal.Length, Sepal.Width, Petal.Length, Petal.Width), sepal.ratio = Sepal.Length/Sepal.Width),sepal.ratio <= 2),desc(sepal.ratio))

# group_by()  ######## = Group the data
mydata %>%
  select(Sepal.Length, Sepal.Width, Species) %>%
  mutate(sepal.ratio = Sepal.Length/Sepal.Width ) %>%
  filter(sepal.ratio <= 2)%>%
  arrange(desc(sepal.ratio))%>%
  group_by(Species)


table(mydata$Species)


# summarise()  ########
#calculate the mean of your variable by group
mydata %>%
  select(Sepal.Length, Sepal.Width, Species) %>%
  mutate(sepal.ratio = Sepal.Length/Sepal.Width ) %>%
  filter(sepal.ratio <= 2)%>%
  arrange(desc(sepal.ratio))%>%
  group_by(Species)%>%
  summarise(my_min = min(sepal.ratio, na.rm = T))


#without tidyverse...

mytab <- mydata[,c("Sepal.Length", "Sepal.Width", "Species")] #create a subset of your dataset (select function)
mytab$sepal.ratio <- mytab$Sepal.Length / mytab$Sepal.Width #create a new column, combining two (mutate function)
mytab <- mytab[mytab$sepal.ratio <= 2,] #filter observations <= 2
mytab <- na.omit(mytab) #remove missing data
c(Se = min(mytab$sepal.ratio[mytab$Species == "setosa"]),
  Ve = min(mytab$sepal.ratio[mytab$Species == "versicolor"]),
  Vi = min(mytab$sepal.ratio[mytab$Species == "virginica"])) #calculate the minimum for each species

#without the pipes
summarise(group_by(arrange(filter(mutate(select(mydata,Sepal.Length, Sepal.Width, Petal.Length, Petal.Width, Species), sepal.ratio = Sepal.Length/Sepal.Width),sepal.ratio <= 2),desc(sepal.ratio)),Species),my_min = min(sepal.ratio, na.rm = T))



# Tidyr ########
# pivot_longer ######
mydata.longer <- mydata %>%
  select(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width, Species ) %>%
  na.omit() %>%
  pivot_longer(cols = Sepal.Length:Petal.Width,names_to = "measure",values_to = "values")

? pivot_longer

 
# pivot_wider ######

mydata.longer %>%
  distinct() %>%
  pivot_wider(names_from = measure, values_from = values)    #Warning message: Values from `values` are not uniquely identified!

#duplicate dataset and add a identification value for each observation
mydata2 <- mydata
mydata2$ID <- c(1:150)

mydata.longer <- mydata2 %>%
  select(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width, Species, ID ) %>%
  na.omit() %>%
  pivot_longer(cols = Sepal.Length:Petal.Width,names_to =  "measure",values_to = "values")

? pivot_wider

#go back from longer to wider

mydata.longer %>%
  distinct() %>%
  pivot_wider(names_from = measure, values_from = values) # Now Values from `values` are  uniquely identified

#that's it for today! ------------------------------------------------------------
