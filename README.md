# Hospital Management Analysis

![Dashboard](screenshots/operations_overview.png)

Tools: SQL Server, Power BI, DAX

## Objective

I wanted a project built on a dataset with several related tables instead of one flat file, so I could practice joins properly in both SQL and Power BI.

The data is the [Hospital Management Dataset](https://www.kaggle.com/datasets/kanakbaghel/hospital-management-dataset) from Kaggle. It has 5 tables: patients (50 rows), doctors (10), appointments (200), treatments (200) and billing (200), all linked through foreign keys.

## What I did

**Database.** I set up the database in SQL Server with real primary and foreign key constraints (patients/doctors → appointments → treatments → billing). The schema is in [hospital_schema.sql](sql/hospital_schema.sql). The dataset had no missing values, and since the foreign keys are enforced, there are no broken references between tables.

**SQL queries.** I wrote queries that join 2 to 4 tables at a time. Two of them: a LEFT JOIN to find patients with zero appointments, and a CTE to find patients whose visit count is above the average. All queries are in [hospital_analysis_queries.sql](sql/hospital_analysis_queries.sql).

**Power BI dashboard.** I built a 3-page dashboard on top of the database:

- Operations Overview: appointment volume, no-show rate, status breakdown, no-shows by day of week
- Doctor Performance: no-show rate and appointment counts per doctor
- Financial Analysis: treatment costs, payment status, revenue by payment method

Screenshots are in the [screenshots](screenshots) folder.

Because the SQL tables had real foreign keys, Power BI detected most of the relationships by itself, which saved a lot of work in the model view.

**A problem I ran into.** A cost measure showed the same value for every doctor. The cause was two different paths between appointments and patients in the model. Power BI picked one and deactivated the appointments-treatments relationship. I fixed it by deactivating the billing-patients relationship instead, which removed the ambiguity.

## What I found

Full notes are in [hospital_business_insights.md](reports/hospital_business_insights.md). The main points:

- The overall no-show rate is around 26%, but it varies a lot by doctor. Two Pediatrics doctors were at 4.8% and 35.7%, so the doctor seems to matter more than the specialty. With only about 20 appointments per doctor, these percentages move a lot, so I wouldn't lean on them too hard.
- No-shows are highest on Sundays (42.3%).
- Failed payments are high (30-38%) for every payment method, so it may be a general billing problem and not something tied to insurance.
- Chemotherapy has the most pending payments. I didn't test why.
- 2 of the 50 patients never booked an appointment. One patient visited 10 times, double anyone else.

## What I would do with this

- Send reminders for Sunday appointments, since that's where no-shows peak.
- Look at the billing process as a whole before looking at individual payment methods.
- Check why some doctors have much higher no-show rates than others in the same specialty.

## Limitations

The dataset is small and most likely synthetic, so the results show how I approached the analysis and shouldn't be read as real-world patterns.

## How to run it

1. Download the dataset from Kaggle.
2. Run [hospital_schema.sql](sql/hospital_schema.sql) to create the tables and load the data. Order matters because of the foreign keys: patients and doctors first, then appointments, then treatments, then billing.
3. Run the queries in [hospital_analysis_queries.sql](sql/hospital_analysis_queries.sql) if you want to reproduce the analysis.
4. Open the [Power BI file](dashboard/Hospital_Management_Dashboard.pbix) (download it from GitHub) and point it at your SQL Server instance.

## Files

```
├── README.md
├── sql/
│   ├── hospital_schema.sql
│   └── hospital_analysis_queries.sql
├── reports/
│   └── hospital_business_insights.md
├── dashboard/
│   └── Hospital_Management_Dashboard.pbix
└── screenshots/
```
