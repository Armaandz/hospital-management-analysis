-- Hospital Management Analytics - Analysis Queries
-- Dataset: Hospital Management Dataset (Kaggle), 5 related tables
-- patients (50), doctors (10), appointments (200), treatments (200), billing (200)
-- All tables have real PRIMARY KEY / FOREIGN KEY constraints

USE hospital_management;
GO


-- Q1: Full appointment list with patient and doctor names (3-table join)
SELECT 
    a.appointment_id,
    p.first_name + ' ' + p.last_name AS patient_name,
    d.first_name + ' ' + d.last_name AS doctor_name,
    d.specialization,
    a.appointment_date,
    a.status
FROM appointments a
INNER JOIN patients p ON a.patient_id = p.patient_id
INNER JOIN doctors d ON a.doctor_id = d.doctor_id
ORDER BY a.appointment_date;


-- Q2: No-show rate by doctor and specialization
SELECT 
    d.specialization,
    d.first_name + ' ' + d.last_name AS doctor_name,
    COUNT(*) AS TotalAppointments,
    SUM(CASE WHEN a.status = 'No-show' THEN 1 ELSE 0 END) AS NoShows,
    ROUND(SUM(CASE WHEN a.status = 'No-show' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS NoShowRate
FROM appointments a
INNER JOIN doctors d ON a.doctor_id = d.doctor_id
GROUP BY d.specialization, d.first_name, d.last_name
ORDER BY NoShowRate DESC;


-- Q3: Treatment cost and payment status by treatment type (4-table join)
SELECT 
    t.treatment_type,
    COUNT(*) AS TotalTreatments,
    ROUND(AVG(t.cost), 2) AS AvgCost,
    SUM(CASE WHEN b.payment_status = 'Paid' THEN 1 ELSE 0 END) AS PaidCount,
    SUM(CASE WHEN b.payment_status = 'Failed' THEN 1 ELSE 0 END) AS FailedCount,
    SUM(CASE WHEN b.payment_status = 'Pending' THEN 1 ELSE 0 END) AS PendingCount
FROM treatments t
INNER JOIN billing b ON t.treatment_id = b.treatment_id
GROUP BY t.treatment_type
ORDER BY AvgCost DESC;


-- Q4: Payment failure rate by payment method
SELECT 
    b.payment_method,
    COUNT(*) AS TotalBills,
    SUM(CASE WHEN b.payment_status = 'Paid' THEN 1 ELSE 0 END) AS Paid,
    SUM(CASE WHEN b.payment_status = 'Failed' THEN 1 ELSE 0 END) AS Failed,
    ROUND(SUM(CASE WHEN b.payment_status = 'Failed' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS FailedRate
FROM billing b
GROUP BY b.payment_method
ORDER BY FailedRate DESC;


-- Q5: Visit count per patient, including patients with zero visits (LEFT JOIN)
SELECT 
    p.patient_id,
    p.first_name + ' ' + p.last_name AS patient_name,
    COUNT(a.appointment_id) AS TotalVisits
FROM patients p
LEFT JOIN appointments a ON p.patient_id = a.patient_id
GROUP BY p.patient_id, p.first_name, p.last_name
ORDER BY TotalVisits DESC;


-- Q6: Patients above the average number of visits (CTE)
WITH PatientVisits AS (
    SELECT 
        p.patient_id,
        p.first_name + ' ' + p.last_name AS patient_name,
        COUNT(a.appointment_id) AS TotalVisits
    FROM patients p
    LEFT JOIN appointments a ON p.patient_id = a.patient_id
    GROUP BY p.patient_id, p.first_name, p.last_name
)
SELECT *
FROM PatientVisits
WHERE TotalVisits > (SELECT AVG(TotalVisits) FROM PatientVisits)
ORDER BY TotalVisits DESC;
