-- Hospital Management Analytics - Database Setup
-- Creates the database, 5 tables with real primary/foreign key
-- constraints, then loads the CSVs. Load order matters because of
-- the foreign keys: patients/doctors first, then appointments,
-- then treatments, then billing.

CREATE DATABASE hospital_management;
GO

USE hospital_management;
GO

CREATE TABLE patients (
    patient_id VARCHAR(10) PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender VARCHAR(5),
    date_of_birth DATE,
    contact_number VARCHAR(20),
    address VARCHAR(255),
    registration_date DATE,
    insurance_provider VARCHAR(50),
    insurance_number VARCHAR(30),
    email VARCHAR(100)
);
GO

CREATE TABLE doctors (
    doctor_id VARCHAR(10) PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    specialization VARCHAR(50),
    phone_number VARCHAR(20),
    years_experience INT,
    hospital_branch VARCHAR(50),
    email VARCHAR(100)
);
GO

CREATE TABLE appointments (
    appointment_id VARCHAR(10) PRIMARY KEY,
    patient_id VARCHAR(10) FOREIGN KEY REFERENCES patients(patient_id),
    doctor_id VARCHAR(10) FOREIGN KEY REFERENCES doctors(doctor_id),
    appointment_date DATE,
    appointment_time TIME,
    reason_for_visit VARCHAR(100),
    status VARCHAR(20)
);
GO

CREATE TABLE treatments (
    treatment_id VARCHAR(10) PRIMARY KEY,
    appointment_id VARCHAR(10) FOREIGN KEY REFERENCES appointments(appointment_id),
    treatment_type VARCHAR(50),
    description VARCHAR(255),
    cost DECIMAL(10,2),
    treatment_date DATE
);
GO

CREATE TABLE billing (
    bill_id VARCHAR(10) PRIMARY KEY,
    patient_id VARCHAR(10) FOREIGN KEY REFERENCES patients(patient_id),
    treatment_id VARCHAR(10) FOREIGN KEY REFERENCES treatments(treatment_id),
    bill_date DATE,
    amount DECIMAL(10,2),
    payment_method VARCHAR(30),
    payment_status VARCHAR(20)
);
GO

-- Load in dependency order
BULK INSERT patients
FROM 'C:\SQLData\hospital\patients.csv'
WITH (FORMAT='CSV', FIRSTROW=2, FIELDQUOTE='"', FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
GO

BULK INSERT doctors
FROM 'C:\SQLData\hospital\doctors.csv'
WITH (FORMAT='CSV', FIRSTROW=2, FIELDQUOTE='"', FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
GO

BULK INSERT appointments
FROM 'C:\SQLData\hospital\appointments.csv'
WITH (FORMAT='CSV', FIRSTROW=2, FIELDQUOTE='"', FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
GO

BULK INSERT treatments
FROM 'C:\SQLData\hospital\treatments.csv'
WITH (FORMAT='CSV', FIRSTROW=2, FIELDQUOTE='"', FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
GO

BULK INSERT billing
FROM 'C:\SQLData\hospital\billing.csv'
WITH (FORMAT='CSV', FIRSTROW=2, FIELDQUOTE='"', FIELDTERMINATOR=',', ROWTERMINATOR='0x0a', TABLOCK);
GO

-- Quick check
SELECT 'patients' AS TableName, COUNT(*) AS Rows FROM patients
UNION ALL
SELECT 'doctors', COUNT(*) FROM doctors
UNION ALL
SELECT 'appointments', COUNT(*) FROM appointments
UNION ALL
SELECT 'treatments', COUNT(*) FROM treatments
UNION ALL
SELECT 'billing', COUNT(*) FROM billing;
-- Expect: 50, 10, 200, 200, 200
