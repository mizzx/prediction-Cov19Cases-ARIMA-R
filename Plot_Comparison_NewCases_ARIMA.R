##PLOT NEW CASES ARIMA MODEL VS ACTUAL

# read actual new cases
actual = read.csv("cov_actualCase_malaysia.csv",header=TRUE,sep=",")
actual = actual[,-1]

# read predicted new cases
predict = read.csv("cov_predictCase_ARIMAmodel.csv",header=TRUE,sep=",")
predict = predict[,-1]

# create new data frame to combine predict and actual 
df_predict_actual = predict[, c("date", "cases")]
df_predict_actual = cbind(df_predict_actual, column3 = actual$New_cases)

# rename column for predict and actual new cases
colnames(df_predict_actual)[2] ="Predicted_New_Case"
colnames(df_predict_actual)[3] ="Actual_New_Case"

# import libraries to plot graph
library(ggplot2)
library(scales)
library(lubridate)

# store date, predicted and actual cases to variables
dates = as.Date(df_predict_actual$date)
pred = df_predict_actual$Predicted_New_Case
cases = df_predict_actual$Actual_New_Case


# plot graph line of predicted and actual new cases for comparison

colors = c("Predicted" = "blue", "Actual" = "red")

ggplot(df_predict_actual,aes(x=dates))+
  geom_line(aes(y=pred,color="Predicted"), linewidth = 1)+
  geom_line(aes(y=cases,color="Actual"),  linewidth = 1)+
  labs(x = "Date", y = "New Daily Cases", color = "Legend")+
  scale_y_continuous(limits = c(0, 2500), breaks = seq(0, 2500, by = 500))+
  ggtitle("Covid-19 Predicted New Cases vs Actual New Cases for Jan-Mar 2023 in Malaysia")+
  theme(plot.title = element_text(hjust = 0.5))

