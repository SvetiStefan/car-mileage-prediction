#load the following libraries required
library(MASS)
library(car)
library(readr)
library(stringr)
library(stats)
library(ggplot2)

#load the dataframe and name it
carmileage <- read.csv("carMPG.csv",stringsAsFactors = FALSE)

#checkpoint -1
# Aim of the project is as follows:-
#Mycar Dream wants to automate the process of predicting the car mileage 
#which fits the customer preferences, based on the dataset of 
#car features and attributes obtained by market surveys. 

# The aim here is to predict the city-cycle fuel consumption 
# in miles per gallon, in terms of 3 multivalued discrete and 
# 5 continuous attributes


# Checkpoint 2
# View the structure of carmileage and continous variables
str(carmileage)
summary(carmileage$Displacement)
summary(carmileage$Weight)
summary(carmileage$Acceleration)


#Convert the Cylinders data type to factors and
#Bin the cylinders into three different categories
#As the records for 3 cylinder and 5 cylinder are less bin them
# with 4 and 6 cylinders respectively
carmileage$Cylinders <- as.factor(carmileage$Cylinders)
table(carmileage$Cylinders)
levels(carmileage$Cylinders)[1:2] <- c("less cylinders")
levels(carmileage$Cylinders)[2:3] <- c("More cylinders")
levels(carmileage$Cylinders)[3] <- c("High cylinders")
#Create dummy variables for cylinders
dummy_cylinders <- data.frame(model.matrix(~carmileage$Cylinders-1,data=carmileage))
dummy_cylinders <- dummy_cylinders[ ,-1]


#Convert the data type of carmileage to numeric
carmileage$Horsepower <- as.numeric(carmileage$Horsepower)
#Check for number of NA's in horsepower attribute
sum(is.na(carmileage$Horsepower))
#Check for mean and replace NA values with mean
mean(carmileage$Horsepower,na.rm=T)
summary(carmileage$Horsepower)
carmileage$Horsepower[is.na(carmileage$Horsepower)]<-mean(carmileage$Horsepower,na.rm=T)


#Convert the Model years into factor data type
#Bin the values based on length of years
#Create dummy variables after binning them
table(carmileage$Model_year)
unique(carmileage$Model_year)
carmileage$Model_year <- as.factor(carmileage$Model_year)
#As the number of records for each year is less bin them into
#Three different categories for better prediction
levels(carmileage$Model_year)[1:5] <- c("old Model")
levels(carmileage$Model_year)[2:5] <- c("Moderatly New")
levels(carmileage$Model_year)[3:6] <- c("new")
table(carmileage$Model_year)
str(carmileage)
dummy_modelyear <- data.frame(model.matrix(~carmileage$Model_year-1,data=carmileage))
dummy_modelyear <- dummy_modelyear[ ,-1]


#convert the data type of origin to factors
#Create dummy variables from origin
unique(carmileage$Origin)
carmileage$Origin <- as.factor(carmileage$Origin)
dummy_origin <- data.frame(model.matrix(~carmileage$Origin-1,data=carmileage))
dummy_origin <- dummy_origin[ ,-1]

# Check for duplicate observations in the dataframe
unique(carmileage)
# No duplicate observations in the dataframe

#check for NA values in dataframe
sum(is.na(carmileage))
#No NA values found

# Outliers treatment on continous variables
#Based on quantile values. View plot as necessary
#Treat outliers in Displacment
quantile(carmileage$Displacement,seq(0,1,0.01))
boxplot(carmileage$Displacement)
#No outliers found in Displacement

#Treat outliers in Horsepower
quantile(carmileage$Horsepower,seq(0,1,0.01))
carmileage$Horsepower[which(carmileage$Horsepower>198)]<-198
boxplot(carmileage$Horsepower)

#Treat outliers in Weight
quantile(carmileage$Weight,seq(0,1,0.01))
boxplot(carmileage$Weight)
#No outliers found in Weight

#Treat outliers in Acceleration
quantile(carmileage$Acceleration,seq(0,1,0.01))
carmileage$Acceleration[which(carmileage$Acceleration<10)]<-10
carmileage$Acceleration[which(carmileage$Acceleration>20.736)]<-20.736
boxplot(carmileage$Acceleration)

# To reduce the number of car_names variables extract
#the company names from model names 
carmileage$car_cat <- gsub("\\ .*","",carmileage$Car_Name)
unique(carmileage$car_cat)
#Clean the data by correcting the company names
#This will further reduce the number of variables
carmileage$car_cat[which(carmileage$car_cat==c("chevroelt"))] <- c("chevrolet")
carmileage$car_cat[which(carmileage$car_cat==c("vokswagen"))] <- c("volkswagen")
carmileage$car_cat[which(carmileage$car_cat==c("mercedes-benz"))] <- c("mercedes")
carmileage$car_cat[which(carmileage$car_cat==c("maxda"))] <- c("mazda")
carmileage$car_cat[which(carmileage$car_cat==c("toyouta"))] <- c("toyota")
carmileage$car_cat[which(carmileage$car_cat==c("vw"))] <- c("volkswagen")
#Create dummy variables 
dummy_carname <- data.frame(model.matrix(~carmileage$car_cat-1,data=carmileage))
dummy_carname <- dummy_carname[ ,-1]

#Combine the dummy variables created with the carmileage dataframe
carmileage <- cbind(carmileage[,-c(2,7,8,9,10)],dummy_carname,dummy_cylinders,
                    dummy_modelyear,dummy_origin)

#Normalize the continous variables created 
#To bring them to the same scale
carmileage$Displacement <- scale(carmileage$Displacement)
carmileage$Horsepower <- scale(carmileage$Horsepower)
carmileage$Weight <- scale(carmileage$Weight)
carmileage$Acceleration <- scale(carmileage$Acceleration)


#Set seed to generate the same results every time
#Divide the carmileage dataframe into training and test data randomly
#The train and test data is divided into 70% and 30% respectively
set.seed(100)
train_random <- sample(1:nrow(carmileage),0.7*nrow(carmileage))
train <- carmileage[train_random,]
test <- carmileage[-train_random,]

#Finally view the structure to see
#If all the variables are numeric
str(train)
#_______________________________________________________________________________________________
#checkpoint 3
#Create a linear model with all the variables
#and View summary
model_1 <- lm(MPG~.,data=train)
summary(model_1)

#Do stepwise selection for selecting the
#significant variables
step <- stepAIC(model_1,direction='both')
step$call


#Create a model from the variables
#selected from the stepwise selection method
model_2 <- lm(formula = MPG ~ Horsepower + Weight + carmileage.car_catdatsun + 
                carmileage.car_catford + carmileage.car_catplymouth + carmileage.car_catpontiac + 
                carmileage.car_catrenault + carmileage.car_cattriumph + carmileage.car_catvolkswagen + 
                carmileage.CylindersMore.cylinders + carmileage.Model_yearModeratly.New + 
                carmileage.Model_yearnew + carmileage.Origin3, data = train)
summary(model_2)
vif(model_2)

#Remove catford as the variable is not significant
model_3 <- lm(formula = MPG ~ Horsepower + Weight + carmileage.car_catdatsun + 
                carmileage.car_catplymouth + carmileage.car_catpontiac + 
                carmileage.car_catrenault + carmileage.car_cattriumph + carmileage.car_catvolkswagen + 
                carmileage.CylindersMore.cylinders + carmileage.Model_yearModeratly.New + 
                carmileage.Model_yearnew + carmileage.Origin3, data = train)
summary(model_3)
vif(model_3)

#Remove Renault as the variable is not significant
model_4<- lm(formula = MPG ~ Horsepower + Weight + carmileage.car_catdatsun + 
                carmileage.car_catplymouth + carmileage.car_catpontiac + 
                carmileage.car_cattriumph + carmileage.car_catvolkswagen + 
                carmileage.CylindersMore.cylinders + carmileage.Model_yearModeratly.New + 
                carmileage.Model_yearnew + carmileage.Origin3, data = train)
summary(model_4)
vif(model_4)

#As the variables Horsepower and weight are in sync with each other
#Find the correlation between them
cor(train$Horsepower,train$Weight)
#Remove Horsepower as the correlation is very high
model_5<- lm(formula = MPG ~  Weight + carmileage.car_catdatsun + 
               carmileage.car_catplymouth + carmileage.car_catpontiac + 
               carmileage.car_cattriumph + carmileage.car_catvolkswagen + 
               carmileage.CylindersMore.cylinders + carmileage.Model_yearModeratly.New + 
               carmileage.Model_yearnew + carmileage.Origin3, data = train)
summary(model_5)
vif(model_5)

#Remove Plymouth as the attribute is insignificant
model_6<- lm(formula = MPG ~  Weight + carmileage.car_catdatsun + 
               carmileage.car_catpontiac + 
               carmileage.car_cattriumph + carmileage.car_catvolkswagen + 
               carmileage.CylindersMore.cylinders + carmileage.Model_yearModeratly.New + 
               carmileage.Model_yearnew + carmileage.Origin3, data = train)
summary(model_6)
vif(model_6)

#Remove datsun as the attribute is insignificant
model_7 <- lm(formula = MPG ~  Weight + 
               carmileage.car_catpontiac + 
               carmileage.car_cattriumph + carmileage.car_catvolkswagen + 
               carmileage.CylindersMore.cylinders + carmileage.Model_yearModeratly.New + 
               carmileage.Model_yearnew + carmileage.Origin3, data = train)
summary(model_7)
vif(model_7)

#Remove triumph as the attribute is insignificant
model_8 <- lm(formula = MPG ~  Weight + 
                carmileage.car_catpontiac + 
                carmileage.car_catvolkswagen + 
                carmileage.CylindersMore.cylinders + carmileage.Model_yearModeratly.New + 
                carmileage.Model_yearnew + carmileage.Origin3, data = train)
summary(model_8)
vif(model_8)

#Remove volkswagen as the attribute is insignificant
model_9 <- lm(formula = MPG ~  Weight + 
                carmileage.car_catpontiac + 
                carmileage.CylindersMore.cylinders + carmileage.Model_yearModeratly.New + 
                carmileage.Model_yearnew + carmileage.Origin3, data = train)
summary(model_9)
vif(model_9)

#Remove origin3 as the attribute is insignificant
model_10 <- lm(formula = MPG ~  Weight + 
                carmileage.car_catpontiac + 
                carmileage.CylindersMore.cylinders + carmileage.Model_yearModeratly.New + 
                carmileage.Model_yearnew , data = train)
summary(model_10)
vif(model_10)

#Apply the model on the test data
#and check the R squared value
verify_model_10 <- lm(formula = MPG ~  Weight + 
                 carmileage.car_catpontiac + 
                 carmileage.CylindersMore.cylinders + carmileage.Model_yearModeratly.New + 
                 carmileage.Model_yearnew , data = test)
summary(verify_model_10)
vif(verify_model_10)

#Evaluate and test the model 
# Based on the model predict MPG for the test data
#Check the R squared value for predicted values and actual values
#of test data. If the R squared value is high than the model is good
Predict <- predict(model_10,test)
cor(test$MPG,Predict)^2


#Check point5 - Model Acceptance
# The model does not consist of more than 5 variables
# The Vif of all variables is less than 2
# The R squared value on the train dataset is 81.8%
# The R squared value on the test dataset is 81.68%
# The R squared value for predicted and actual values of MPG for test data is 81.36%
# As the model has high predictive ability it is accepted.

#Plot the graph for residuals Vs fitted values
#Check for linearity
#Red line indicates  a smooth fit to the Residuals

par(mfrow = c(2,2))
plot(model_10)

#As the Red line  is nonlinear, add a non-linear term to the multiple linear regression
#For better model accuracy 
#Remove insignificant attributes

model_11 <- lm(formula = MPG ~  Weight + I(Weight^2)+
                 carmileage.Model_yearnew+
                 carmileage.Model_yearModeratly.New, data = train)
                 
summary(model_11)
vif(model_11)

#verify the model on test data
ver_model_11 <- lm(formula = MPG ~  Weight + I(Weight^2)+
                 carmileage.Model_yearnew+
                 carmileage.Model_yearModeratly.New, data = test)
                 
summary(ver_model_11)
vif(ver_model_11)

par(mfrow = c(2,2))
plot(model_11)

#Evaluate and test the model 
# Based on the model predict MPG for the test data
#Check the R squared value for predicted values and actual values
#of test data. If the R squared value is high than the model is good
Predict_1 <- predict(model_11,test)
cor(test$MPG,Predict_1)^2

#Check point5 - Model Acceptance
# The model does not consist of more than 5 variables
# The Vif of all variables is less than 2
# The R squared value on the train dataset is 84.43%
# The R squared value on the test dataset is 85.25%
# The R squared value for predicted and actual values of MPG for test data is 85.13%
# As the model has high predictive ability it is accepted.



#Plot the graphs for checking the correlation visually
#plot correlation between weight and MPG of test data 
mpg_weight <- ggplot(test,aes(x=Weight,y=MPG))+geom_point(col="blue")
#plot correlation between predict and actual values of MPG of test data
Predict_actual_test <- ggplot(test,aes(x=Predict,y=MPG))+geom_point(col="blue")

#End of Assignment


























