# Codebook

The script produces a "tidy dataset" as per the project assignment.

This is a CSV file with column headers in the first row.

Every row contains the averages of a number of observations for a given test subject and activity type. 

The columns are


    unnamed first column 
    	  a row number
    "subject"              
    	the number assigned to the test subject
    "set"                
        either "test" or "train", 
        indication to which data set the subject belongs
    "activity"
    	the name of the activity 
    rest of the columns
       feature averages

For a description of the features and activities refer to the explanations in the original data file package (UCI HAR Dataset), especially "activity_labels.txt", "features_info.txt" and "features.txt".

 

