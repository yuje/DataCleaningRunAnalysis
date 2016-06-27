

The script "run_analysis.R" downloads the dataset containing the fitness
measurement data collected by smartphone for each of 30 volunteers.

It first downloads the zip file to the current working directory, and then
unzips it. It reads each file within the zip into a dataframe.

After X_test and X_train are read in, the column names for the X data are taken
from the feature names in features.txt. The column names are used verbatim,
except for the following changes:
  * Parentheses are removed or converted, as these characters are not allowed
    in R column names.
  * "()" is removed entirely, so "fBodyAccMag-mean()" -> "fBodyAccMag-mean"
  * Where parentheses enclose variables, underscores are added instead.
    "angle(Z,gravityMean)" -> "angle_Z,gravityMean"

For each measurement inside the "Inertial Signals" folder, a mean and standard
deviation is calculated and merged with the data.

All the test and training data are read separately, merged into test and
training dataframes, and finally, all are merged together into a data
frame called "all_data".

After "all_data" is created, a seperate data frame "summary_data" is created
that contains only the mean and std columns.

Finally, I use the "aggregate()" function to generate a tidy data summary
from the summary.
