# Data Preprocessing

As mentioned above, only patients with AMI are studied in this project. Thus, the corresponding operation is to search the entire dataset, select the wanted patient samples and choose the input variables. Five steps are included in the data preprocessing to establish a sub-dataset for ML. The SQL codes for the five steps are attached in a separate file together with this report.

## Step 1 Generate a list of patients diagnosed with AMI
Starting from MIMIC-IV v2.0, the Date of Death (dod) field was updated to include out-of-hospital mortality information sourced from state death records. After conducting calculations on the mortality rates of patients with AMI at various intervals following hospitalization, it was discovered that the mortality rate was 7.2% after 7 days, progressively rising to 20.3% after 90 days, and further increasing to 24% within 180 days. This underscores the critical necessity of closely monitoring these patients, particularly during the initial 90-day period. Consequently, for this project, the dod was employed to tally instances of AMI patients’ status within a 90-day timeframe, without differentiation based on their duration of hospitalization. Hospital admission relevant with AMI are filtered first using the diagnosis code. Patients died within 90 days are further filtered according to dod.

## Step 2 Create input feature variables
First, I extract demographics as input variables, including gender, age, marital status and race of the patients. Then I count the numbers that a patient had AMI before the latest AMI diagnosis record and identify the admission type for the latest hospitalization. 

Second, I extract the comorbidities that a patient diagnosed during AMI hospitalization, including congestive heart failure, peripheral vascular disease, cerebrovascular disease, dementia, chronic pulmonary disease, rheumatic disease, peptic ulcer disease, mild liver disease, diabetes without complications or comorbidities, diabetes with complications or comorbidities, paraplegia, renal disease, malignant cancer, severe liver disease, metastatic solid tumor, aids. 

Third, I collect the average measurements of vital signs during the initial three days from chart events. These measurements encompass heart rate, systolic blood pressure, diastolic blood pressure, mean arterial pressure, respiratory rate, body temperature, and arterial oxygen saturation.

Additionally, I extract the average clinic measurements related to AMI during the initial three days from lab events. These measurements include Troponin T, Creatine Kinase MB Isoenzyme, Anion Gap, Bicarbonate, Blood Urea Nitrogen, Calcium, Chloride, Creatinine, Glucose, Sodium and Potassium.

## Step 3 Create dependent variable
The mortality status (alive or death) of the patients is taken as the dependent variable. Binary values are used to represent the dependent variable, with 0 for alive and 1 for death. 

## Step 4 Join tables
During this procedure, all attributes are combined into a single table consisting of 9703 observations, 40 independent variables, and 1 dependent variable.
 
## Step 5 Clean data
For marital status, patients are grouped into single (1), married (2), divorced (3), widowed (4) and unknown (5).
For race, patients are grouped into Hispanic or Latino (1), Black or African American (2), White or European (3), Asian (4) and others (5). For admission, patients are grouped into emergency (1) and elective (2) groups. For clinical measurements, missing values are replaced with the mean value based on the patient's condition. For instance, if the patient is alive, I substitute missing values with the mean calculated from all measurements of alive patients. 

The prepared dataset contains 40 input variables and 1 dependent variable (status of the patients). 
