## PSEUDOCODE
# 1. Load 'forecast' package to use ARIMA model
# 2. Read Covid-19 data in Malaysia from first cases to 31 December 2022
# 3. Extract data before 2023 to fit into prediction model
# 4. Convert date to a date object and create time series object from new deaths data
# 5. Build ARIMA model and fit cases time series into the model
# 6. Set "2023-01-01" as start and "2023-03-31" as end date for prediction
# 7. Generate daily predictions for January 2023 to March 2023 using forecast()


# ARIMA (AutoRegressive Integrated Moving Average) model
# Load the 'forecast' package using library()
# To predict new cases on a specific timeline using R
# Utilize time series forecasting techniques
library(forecast)

# Read data into a data frame
covMalaysia = read.csv("covid_malaysia.csv",header=TRUE,sep=",")

# Extract data of date and new cases from feb 2020 onward (2022-12-31)
newdeath = "New_deaths"
date = "Date_reported"
range_row = c(7:1071)
column = c(date, newdeath)
# The final data
df = covMalaysia[range_row, column]

# Convert the date column to a date object
date_obj = as.Date(df$Date_reported)

# Create a time series object
# The frequency of 12 indicates that the data has a monthly pattern
cases_ts = ts(df$New_deaths, frequency = 12)

# build an ARIMA model using the auto.arima() function from the forecast package
# This function automatically selects the best ARIMA model based on the data.
# fit the model using cases time series
model = auto.arima(cases_ts)

# Set the start and end date for prediction
prediction_start = as.Date("2023-01-01")
prediction_end = as.Date("2023-03-31")

# Generate daily predictions for January 2023 to March 2023
prediction = forecast(model, h = as.numeric(prediction_end - prediction_start + 1))

# Extract the daily predicted values
daily_predictions = prediction$mean

# Create a sequence of dates for the prediction period
prediction_dates = seq(prediction_start, prediction_end, by = "day")

# Combine the dates and predicted values into a prediction data frame with new dates
predictions_df = data.frame(date = prediction_dates, cases = round(daily_predictions))

# save prediction of new cases to csv file
write.csv(predictions_df, "/Users/Zul/Desktop/cov_predictDeath_ARIMAmodel.csv", row.names=TRUE)



#################### PLOT simple black graph
# Plot the predictions with actual dates as x-axis labels
plot(predictions_df$date, predictions_df$cases, type = "l", xlab = "Date", ylab = "New Death Cases", main = "Predicted Death Cases for January - March 2023 in Malaysia", xaxt = "n")

# Add x-axis tick labels with actual dates
axis(1, at = predictions_df$date, labels = format(predictions_df$date, "%b %d, %Y"))

#################### Colored graph based on month
# Plot the predictions with colored graph line for each month
plot(predictions_df$date, predictions_df$cases, type = "n", xlab = "Date", ylab = "New Death Cases", main = "Predicted Daily Covid-19 Cases for January - March 2023 in Malaysia", xaxt = "n")

# Get unique months in the predictions data
unique_months = unique(format(predictions_df$date, "%b"))

# Generate a color palette for the unique months
colors = rainbow(length(unique_months))

# Loop through each unique month 
# and plot the corresponding subset of data with the associated color
for (month in unique_months) {
  subset_df <- predictions_df[format(predictions_df$date, "%b") == month, ]
  lines(subset_df$date, subset_df$cases, col = colors[month == unique_months], type = "b")
}

# Add x-axis tick labels with actual dates
axis(1, at = predictions_df$date, labels = format(predictions_df$date, "%b %d, %Y"))

