-- ============================================================
-- Project Phase 3
-- REQUIRED SQL QUERIES
-- Tables: citizen, doctor, hospital, incidents
-- Each table includes: INSERT, UPDATE, DELETE, SELECT (TOP 5)
-- ============================================================


/* ------------------------------------------------------------
   1. CITIZEN QUERIES
   ------------------------------------------------------------ */

-- INSERT a new citizen
INSERT INTO citizen (first_name, last_name, birthdate, address, access_nearest_hospital_clinic, no_of_calls_made)
VALUES ('Sara', 'Nasr', '1999-03-10', 'Furn El Chebbak, Beirut', 'Hotel Dieu / Achrafieh Clinic', 1);

-- UPDATE an existing citizen
UPDATE citizen
SET address = 'Hamra, Beirut',
    access_nearest_hospital_clinic = 'AUBMC / Hamra Clinic'
WHERE first_name = 'Rana' AND last_name = 'Khoury' AND birthdate = '1998-04-12';

-- DELETE the newly added citizen
DELETE FROM citizen
WHERE first_name = 'Sara' AND last_name = 'Nasr' AND birthdate = '1999-03-10';

-- SELECT the top 5 citizens
SELECT * FROM citizen
LIMIT 5;



/* ------------------------------------------------------------
   2. DOCTOR QUERIES
   ------------------------------------------------------------ */

-- INSERT a new doctor
INSERT INTO doctor (medical_license_no, first_name, last_name, specialty, availability, consultation_cost)
VALUES ('D2020', 'Lea', 'Hobeika', 'Endocrinology', 'Mon-Fri 9-4', 70.00);

-- UPDATE an existing doctor
UPDATE doctor
SET consultation_cost = 95.00
WHERE medical_license_no = 'D2001';

-- DELETE the newly added doctor
DELETE FROM doctor
WHERE medical_license_no = 'D2020';

-- SELECT the top 5 doctors
SELECT * FROM doctor
LIMIT 5;



/* ------------------------------------------------------------
   3. HOSPITAL QUERIES
   ------------------------------------------------------------ */

-- INSERT a new hospital
INSERT INTO hospital (code, name, address, bed_capacity, has_emergency_department, avg_wait_time, accreditation, coverage_area, doctor_count, staff_to_patient_ratio)
VALUES ('H020', 'Aley Governmental Hospital', 'Aley - Main Road', 180, 1, 55, 'MoH', 'Aley District', 90, 0.1300);

-- UPDATE an existing hospital
UPDATE hospital
SET avg_wait_time = 30
WHERE code = 'H012';

-- DELETE the newly added hospital
DELETE FROM hospital
WHERE code = 'H020';

-- SELECT the top 5 hospitals
SELECT * FROM hospital
LIMIT 5;



/* ------------------------------------------------------------
   4. INCIDENTS QUERIES
   ------------------------------------------------------------ */

-- INSERT a new incident
INSERT INTO incidents (
    report_number, report_date, type, severity_level, resources_mobilized,
    location_accessibility, location, outcome,
    reported_by_first_name, reported_by_last_name, reported_by_birthdate
)
VALUES (
    20001, '2025-07-10', 'Minor Injury', 1,
    'Ambulance', 'Easy', 'Furn El Chebbak, Beirut', 'Treated On Scene',
    'Rana', 'Khoury', '1998-04-12'
);

-- UPDATE the newly added incident
UPDATE incidents
SET outcome = 'No Further Action Required'
WHERE report_number = 20001 AND report_date = '2025-07-10';

-- DELETE the newly added incident
DELETE FROM incidents
WHERE report_number = 20001 AND report_date = '2025-07-10';

-- SELECT the top 5 incidents
SELECT * FROM incidents
LIMIT 5;
