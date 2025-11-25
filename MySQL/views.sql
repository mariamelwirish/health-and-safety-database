-- ========================================
-- VIEW 1: Doctor Activity Summary
-- Shows each doctor with consults + prescriptions count
-- ========================================

CREATE OR REPLACE VIEW v_doctor_activity_summary AS
SELECT
    d.medical_license_no,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    d.specialty AS doctor_specialty,

    COUNT(DISTINCT CONCAT(
        c.citizen_first_name, '|',
        c.citizen_last_name, '|',
        c.citizen_birthdate
    )) AS total_consults,

    COUNT(DISTINCT CONCAT(
        p.citizen_first_name, '|',
        p.citizen_last_name, '|',
        p.citizen_birthdate
    )) AS total_prescriptions

FROM doctor d
LEFT JOIN consult c
    ON c.medical_license_no = d.medical_license_no
LEFT JOIN prescribes p
    ON p.medical_license_no = d.medical_license_no
GROUP BY
    d.medical_license_no,
    doctor_name,
    doctor_specialty;




-- ========================================
-- VIEW 2: Citizen Health History
-- Shows each citizen with their consults + doctor + prescriptions
-- ========================================

CREATE OR REPLACE VIEW v_citizen_health_history AS
SELECT
    ct.first_name,
    ct.last_name,
    ct.birthdate,
    CONCAT(ct.first_name, ' ', ct.last_name) AS citizen_name,

    d.medical_license_no,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    d.specialty AS doctor_specialty,

    CASE
        WHEN p.medical_license_no IS NOT NULL THEN 1
        ELSE 0
    END AS has_prescription_from_doctor

FROM citizen ct
LEFT JOIN consult c
    ON c.citizen_first_name = ct.first_name
   AND c.citizen_last_name  = ct.last_name
   AND c.citizen_birthdate  = ct.birthdate
LEFT JOIN doctor d
    ON d.medical_license_no = c.medical_license_no
LEFT JOIN prescribes p
    ON p.citizen_first_name = ct.first_name
   AND p.citizen_last_name  = ct.last_name
   AND p.citizen_birthdate  = ct.birthdate
   AND p.medical_license_no = c.medical_license_no;



-- ========================================
-- VIEW 3: Incident Full Log
-- Combines hospital, fire, and police responses into one log
-- ========================================

CREATE OR REPLACE VIEW v_incident_full_log AS
-- HOSPITAL PART
SELECT
    i.report_number,
    i.report_date,
    i.location,
    i.type AS incident_type,
    i.severity_level,
    'HOSPITAL' AS source,
    h.code AS organization_id,
    h.name AS organization_name,
    NULL AS station_address,
    i.outcome AS status
FROM incidents i
JOIN hospital_logs hl
    ON hl.report_number = i.report_number
   AND hl.report_date   = i.report_date
JOIN hospital h
    ON h.code = hl.code

UNION ALL

-- FIRE PART
SELECT
    i.report_number,
    i.report_date,
    i.location,
    i.type AS incident_type,
    i.severity_level,
    'FIRE' AS source,
    NULL AS organization_id,
    fl.name AS organization_name,
    fl.address AS station_address,
    NULL AS status
FROM incidents i
JOIN fire_logs fl
    ON fl.report_number = i.report_number
   AND fl.report_date   = i.report_date

UNION ALL

-- POLICE PART
SELECT
    i.report_number,
    i.report_date,
    i.location,
    i.type AS incident_type,
    i.severity_level,
    'POLICE' AS source,
    NULL AS organization_id,
    pl.name AS organization_name,
    pl.address AS station_address,
    NULL AS status
FROM incidents i
JOIN police_logs pl
    ON pl.report_number = i.report_number
   AND pl.report_date   = i.report_date;