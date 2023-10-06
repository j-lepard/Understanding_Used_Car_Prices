# Analysis of Car Listings
This is a group project completed by:
- [Dylan Fernandes](https://github.com/DylJFern)
- [Jamie Lepard](https://github.com/j-lepard)
- [Kieran Anson-Cartwright](https://github.com/kansonc)

## <br>Introduction
### Purpose
The purpose of this project is to combine and practice implementing what has been learned thus far by leveraging data to explore a problem and present our findings. 

### <br>Objective
The objective is to define a specific problem and thoroughly investigate it using various data analysis techniques, such as data retrieval, exploratory data analysis, and statistical modelling in Python. This analysis will be presented through a visualization dashboard, aiming to showcase key insights and propose potential solutions. Additionally, a user-friendly procedure will be developed, enabling non-technical users to easily interact with and utilize the dashboard.

## <br>Process
### Project Planning
- The selected dataset is based on the '[100,000 UK Used Car Dataset](https://www.kaggle.com/datasets/adityadesai13/used-car-dataset-ford-and-mercedes/)'.
- We will be focusing on the cleaned csv files of the different brands (this excludes brand specific ones like cclass.csv and focus.csv).

### <br>Project Setup
- Create a collaborative project on GitHub.

### <br>Project Workflow
#### Step 1
- Familiarize ourselves with the dataset, this includes:
  -  Learning the relevant terms.
  -  What kind of information the dataset contains.
  -  The kind of questions can we answer with the dataset.
  -  The insights we can gain and business problem we can define.
#### Step 2
- Initial exploration into the types of visualization we may want to include to answer our business problem.
- Initial examination of the data (e.g. the number of rows contain in each file).
#### Step 3
- Creating DataFrames (individual and combined) from the individual csv files of interest.
  - Implement data cleaning strategies.
  - Verifying data integrity.
- Feature engineering (e.g. add the associated brand and country identifiers).
#### Step 4
- EDA process: 
  - Additional cleaning procedures.
  - Data distribution (histograms) and normalization using logarithmic transformations.
  - Different outlier identification methods (boxplots) to showcase price's dependency on multiple factors.
  - Correlation analysis (heatmap) to better understand the features.
  - Multivariable regression analysis to quantify the relationship between multiple predictors (features) and price.
#### Step 5
- Tableau  

...

...

### <br>Project Development
- Utilize communication tools (e.g. Google documents, Discord) to discuss and share ideas.

## <br>Results
The dataset contains characteristics related to the vehicle:
- model: The specific designation given to a particular type or version of a vehicle made by a manufacturer.
- year: The year in which the vehicile was manufactured or registered. 
- price: The monetary value associated with buying or selling the vehicle.
- transmission: Determines how power is transmitted from the engine to the wheels using gears.
- mileage: The total distance (in miles) the vehicle has travelled (indicates how much it has been used).
- fuelType: The type of fuel the vehicle uses to generate power and operate.
- tax: The tax amount associated with owning or using the vehicle (can depend on emissions, vehicle type, or government regulations).
- mpg: The miles per gallon; a measure of a vehicle's fuel efficiency, representing the number of miles it can travel using one gallon of fuel.
- engineSize: The size or capacity of the vehicle's engine (in litres), it provides an indication of the engine's power and performance capabilities.

### <br>Data Cleaning and Exploratory Data Analysis
#### Data Cleaning
- The string data in the csv files would contain whitespace which made it difficult to reference specific columns and display particular rows. For example, the following code would return an empty DataFrame, even though we knew there existed multiple entries of a Ford Fiesta.
```python
data[(data['brand'] == 'Ford') & (data['model'] == 'Fiesta')]
```

- The numeric data 'tax' contained a mix of US dollars and pounds, in some csv's the column would be displayed as either tax or tax(£). This was fixed by checking if the column 'tax(£)' existed in the csv DataFrame and then accordingly replacing it with 'tax' and with a multipler (based on the conversion rate at the time) for each the corresponding row.
```python
# convert pounds to US dollars
if 'tax(£)' in csv_file_df.columns:
  # assume conversion rate of 1.22
  csv_file_df.insert(8, 'tax', csv_file_df['tax(£)'] * 1.22)
  csv_file_df.drop('tax(£)', axis = 1, inplace = True)
```

- The corresponding country and brand were added to the DataFrame as it was being created (using a for-loop) from the entries of each csv file.
  - The csv file name was extracted and inserted as a column with appropriate capitalization applied.
  - The country was mapped (using a pre-defined dictionary) to the file name (or vehicle 'brand') and inserted as a column with appropriate capitalization applied.
```python
# extract the brand name from csv file name
brand_name = os.path.splitext(os.path.basename(csv_file))[0]
if brand_name.lower() == 'mercedes-benz':
  brand_name = 'Mercedes-Benz'
elif brand_name.lower() == 'bmw':
  brand_name = 'BMW'
else:
  brand_name = brand_name.capitalize()
                  
# add a column for the "country" based on brand_name as the first column
csv_file_df.insert(0, 'country', brand_country_mapping.get(brand_name, None))
        
# add a column for the "brand" as the second column with all other columns preceding it
csv_file_df.insert(1, 'brand', brand_name)
```

#### <br> Exploratory Data Analysis
- From initial inspection of the rows, we notice that the data contained
  - 1 count of 'year' equal to 2060 (assumed to be a typo based on comparison with other 2006 Ford Fiesta's, value changed to 2006).
  - 2 counts of 'year' equal to 1970 (removed due to gap between 'year' value and next sequential 'year' equal to 1996).

- Initial insights obtained in information gathering stage helped us formulate the hypothesis that 'price' is dependent on all other predictors.
##### Histograms
- Visualize the distribution of each numerical variable in our data.

![img3](https://github.com/j-lepard/LHL-MidtermProject/assets/128000630/e17c5743-9006-4bdc-9c14-f28e805f9b55)

- From the histograms we noticed that all the numeric data had a skewed distribution. To stabilize variance and make the data more normally distributed we applied the logarithmic function (to all numeric data types except 'year').
```python
for col in columns_to_transform:
    # get the index location of a particular column in the original DataFrame
    original_col_index = used_cars_log_df.columns.get_loc(col)
    # insert the transformed column following the original column
    used_cars_log_df.insert(original_col_index + 1, col + '_log', np.log(used_cars_log_df[col] + 1)) # add 1 to handle zero values (log10(0) = null and log10(1) = 0)
```

- By applying the logarithmic transformation, we were able to convert the data to a more normal distribution. We can then use this to examine potential outliers that may exist by plotting variations of the transformed price.  
  - Plotted the transformed price evaluated by year.  
  - Plotted the transformed price dependence on the transformed predictor mileage evaluated by year.

![img4](https://github.com/j-lepard/LHL-MidtermProject/assets/128000630/fc298e16-9588-4c98-b68d-853cd50d3b8e)

![img5](https://github.com/j-lepard/LHL-MidtermProject/assets/128000630/1b0e6015-f4c6-43fc-98e5-911b50097c8a)

- Through this process we explored different ways of identifying potential outliers that exist within the data. However, we did not "handle" them since the process did not provide any conclusive evidence. In other words, it was observed that the complexities of 'price' could not be captured by any single variable alone (e.g. price per mileage, although 'mileage' is an important factor, it certainly is not the only determinant of a vehicle's price), but rather is influenced by a multitude of possible predictors including 'year', 'engineSize', 'brand', etc. and eliminating the outliers based on 'price' alone would not make sense. In this case, we turned to correlation and regression to see if it could help us better understand and quantify the relationships between features (predictors) and price.

### <br>Correlation Analysis
- The goal is to construct a heatmap to show the correlation(s) in our data.
- The data contains categorical variables and numerical values.
- In general, converting categorical variables to numerical values can be useful for analysis.
  - This assumes they are ordinal or at least represent some kind of order.
- There are three possible methods we can consider:
  - Label encoding
  - One-hot encoding
  - Direct key-mapping
- Encoding is a process of converting categorical data (non-numeric) into a numeric format that can be used by machine learning models. There are several ways to perform encoding, two common methods being "one-hot encoding" and "label encoding".

#### Label encoding
Used when the categorical feature is assumed to be ordinal, implying some form of order or ranking, although it might not be accurate in practice. Assigns a unique numerical label to each category. It is commonly utilized when preserving space is a priority or when the data has a clear ordinal relationship. But may introduce a misleading ordinal relationship, which can lead to misinterpretations by some machine learning algorithms.

The categorical variable 'transmission' in the dataset is represented as either "manual". "automatic", "semi-auto", or "other". In label encoding, this categorical variable would aggregate the different categories into a single column 'transmission' with numeric labels.

For example, for the categorical variable 'transmission' for label encoding would be represented as follows:
- 'transmission_encoded'




In the case of the direct key-mapping, although we are creating numeric labels, they are separate and inherently does not provide a meaningful relationship.

    - Compared to the direct mapping (previously described), it does not inherently make the data ordinal (or provide a meaningful relationship between the categories). It would also create multiple


- In such as case, a possible mapping may look like the following.
 
![img2](https://github.com/j-lepard/LHL-MidtermProject/assets/128000630/9b6863fd-f0c5-4cf8-bc5e-7f4634910752)



#### One-hot encoding (also known as dummy encoding)
Used when categorical feature is nominal, meaning there's not inherent order or ranking between categories. It creates new binary columns for each category and represents the presence or absence of a category with a 1 or 0, respectively. It avoids introducing false ordinal relationships.

For example, for the categorical variable 'transmission', it would create four separate binary columns (dummy variables):
- 'transmission_manual': [1, 0, 0, 0]
- 'transmission_automatic': [0, 1, 0, 0]
- 'transmission_semi-auto': [0, 0, 1, 0]
- 'transmission_other': [0, 0, 0, 1]

In the case of the direct key-mapping, we are creating four separate numeric labels which assigns a set of numerical representations for the categories without implying any specfic relationship. This would not produce the kind of relationship we would want.



- However, since variables like 'transmission' and 'fuelType' are not, converting them to numerical values may introduce misleading information.






    - the numerical labels are not 
-
- like one-hot encoding which will represent each category as a binary (0 or 1) value in separate columns. This way, you won't introduce any false numerical relationships between categories. For the heatmap and correlation analysis, consider using one-hot encoded columns for 'transmission' and 'fuelType' instead of their numerical representations. This will provide a more accurate representation of the correlation between these variables and other numerical columns in your dataset.
  - One-hot encoding is typically used when dealing with categorical variables that don't have an inherent order or numerical relationship. 
  - One-hot encoding involves creating binary columns for each category within a categorical variable. Each binary column represents the presence or absence of that category. This is useful when dealing with non-ordinal categorical variables, as it avoids introducing false numerical relationships between categories.

### <br>Multivariable Regression Analysis

## <br>Challenges
- Time.
- Coordinating different schedules and timezones.
- 
- 
## <br>Future Considerations
