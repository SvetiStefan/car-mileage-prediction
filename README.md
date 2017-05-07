# Prediction of car mileage using Linear Regression


**Company Information**
An automobile consultancy firm “Mycar Dream” provides assistance to its clients in making appropriate car deals, based on their requirements.
 
Based on various market surveys, the firm has gathered a large dataset of different types of cars and their attributes across the world. The business model of the company is solely based on consumer interest, aiming to provide the most appropriate car to their clients and hence maximise the customer satisfaction.
 
**Problem Statement:**
Nowadays, the automobile market has become very dynamic as the buyers have varied preferences. Customers look for various features (brand value, mileage, model_year etc) in their dream car. In order to fulfil it's customer requirement, Mycar Dream wants to automate the process of predicting the car mileage which fits the customer preferences, based on the dataset of car features and attributes obtained by market surveys. 
 
The aim here is to predict the city-cycle fuel consumption in miles per gallon, in terms of 3 multivalued discrete and 5 continuous attributes. 

**The goal of this assignment:-**
we will develop a predictive model which can follow these three constraints thoroughly:-
* The model should not contain more than 5 variables.
* According to the business needs, set the VIF to 2. 
* The model should be highly predictive in nature i.e it should show 80% (R squared) of accuracy.

**step 1: Business Understanding and Data Understanding**
This is the most important stage of solving any problem. In this step, we will get well versed with the dataset. 
 
**step 2: Data Cleaning and Preparation**
After Business understanding, the next important step is data preparation.  Data preparation takes the highest amount of time and effort. It is estimated that 60-80% of the time in any model building process is typically spent in preparing and cleaning data. 
* First stage: Variables Formatting  
Check the structure of “carmileage” dataset and change the type of variable as per the business understanding if required.
* Second Stage: Data Cleaning 
Clean the data set for any anomalies it might have. Treat the missing values (if any) and the outliers (if any) at this stage.
* Third Stage: Variables Transformation
Adding more meaningful variables in the modeling process. These could be transformed variables. If done correctly, these variables can add tremendous power to your analysis.
 (“Car_Name” variable level should be reduced to under 30 - 35 dummy variables)
 
**step 3: Model Development**
Once the data preparation is over we will move on to the model development phase. In this checkpoint,we will consider the below points while developing the model. 
* Multicollinearity 
* p-value 
* R square metric
 
**step 4: Model Evaluation and Testing**
Once the model is developed, we will apply our model to the test dataset. we will calculate the test R-squared to know whether your model has good predictive ability or not. 

**step 5: Model acceptance or Rejection**
we will make sure that all the goals of this project are met, which are:- 
* The model should not contain more than 5 variables.
* The model should be highly predictive in nature i.e it should show 80% (R squared) of accuracy.
* The model should give high accuracy (test R-squared ) when tested it on the test dataset.

**In addition to the R code, a pdf file is also included in the repository which will further explain the methodology and analyze the results**