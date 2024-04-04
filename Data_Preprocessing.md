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


Attribute	Explanation	Data Type	Original Table
gender	gender (0 for males, 1 for females)	Binary	patients
age	age	Numeric	patients
marital_status	marital status	Nominal	patients
race	Race	Nominal	patients
AMIhistory_count	times that a person had heart attacks before their latest AMI diagnosis record	Numeric	diagnoses_icd, admissions
congestive_heart_failure	comorbidity during AMI (0 for no, 1 for yes)	Binary	diagnoses_icd
peripheral_vascular_disease	comorbidity during AMI (0 for no, 1 for yes)	Binary	diagnoses_icd
cerebrovascular_disease	comorbidity during AMI (0 for no, 1 for yes)	Binary	diagnoses_icd
dementia	comorbidity during AMI (0 for no, 1 for yes)	Binary	diagnoses_icd
chronic_pulmonary_disease	comorbidity during AMI (0 for no, 1 for yes)	Binary	diagnoses_icd
rheumatic_disease	comorbidity during AMI (0 for no, 1 for yes)	Binary	diagnoses_icd
peptic_ulcer_disease	comorbidity during AMI (0 for no, 1 for yes)	Binary	diagnoses_icd
mild_liver_disease	comorbidity during AMI (0 for no, 1 for yes)	Binary	diagnoses_icd
diabetes_without_cc	comorbidity during AMI (0 for no, 1 for yes)	Binary	diagnoses_icd
diabetes_with_cc	comorbidity during AMI (0 for no, 1 for yes)	Binary	diagnoses_icd
paraplegia	comorbidity during AMI (0 for no, 1 for yes)	Binary	diagnoses_icd
renal_disease	comorbidity during AMI (0 for no, 1 for yes)	Binary	diagnoses_icd
malignan_cancer	comorbidity during AMI (0 for no, 1 for yes)	Binary	diagnoses_icd
severe_liver_disease	comorbidity during AMI (0 for no, 1 for yes)	Binary	diagnoses_icd
metastatic_solid_tumor	comorbidity during AMI (0 for no, 1 for yes)	Binary	diagnoses_icd
aids	comorbidity during AMI (0 for no, 1 for yes)	Binary	diagnoses_icd
heart_rate	average Heart Rate (bpm) in first 3 days	Numeric	chartevents
sbp	average Systolic Blood Pressure (mmHg) in first 3 days	Numeric	chartevents
dbp	average Diastolic Blood Pressure (mmHg) in first 3 days	Numeric	chartevents
mbp	average Mean Arterial Pressure (mmHg) in first 3 days	Numeric	chartevents
resp_rate	average Respiratory Rate (insp/min) in first 3 days	Numeric	chartevents
temperature	average Temperature Celsius in first 3 days	Numeric	chartevents
spo2	average Arterial O2 Saturation (%) in first 3 days	Numeric	chartevents
tropini_t	average Troponin T (ng/ml) in first 3 days	Numeric	labevents
ck_mb	average Creatine Kinase MB Isoenzyme (ng/ml) in first 3 days	Numeric	labevents
aniongap	average Anion Gap (mEq/L) in first 3 days	Numeric	labevents
bicarbonate	average Bicarbonate (mEq/L) in first 3 days	Numeric	labevents
bun	average Blood Urea Nitrogen (mg/dL) in first 3 days	Numeric	labevents
calcium	average Calcium (mg/dL) in first 3 days	Numeric	labevents
chloride	average Chloride (mEq/L) in first 3 days	Numeric	labevents
creatinine	average Creatinine (mg/dL) in first 3 days	Numeric	labevents
glucose	average Glucose (mg/dL) in first 3 days	Numeric	labevents
sodium	average Sodium (mEq/L) in first 3 days	Numeric	labevents
potassium	average Potassium (mEq/L) in first 3 days	Numeric	labevents
admission_type	how patients enter hospital (0 for elective, 1 for emergency)	Nominal	admissions
status	status of patient in 90 days (0 for alive, 1 for dead)	Binary	patients, admissions

