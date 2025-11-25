/* A. Which doctors has each citizen consulted? */
SELECT c.first_name, c.last_name, d.medical_license_no, d.first_name AS doc_first, d.last_name AS doc_last, d.specialty
FROM consult co
JOIN citizen c
  ON c.first_name = co.citizen_first_name AND c.last_name = co.citizen_last_name AND c.birthdate = co.citizen_birthdate
JOIN doctor d
  ON d.medical_license_no = co.medical_license_no
ORDER BY c.last_name, c.first_name, d.last_name;


-- /* B. Prescriptions: which doctor prescribed to which citizen? */
-- SELECT ci.first_name, ci.last_name, d.medical_license_no, d.first_name AS doc_first, d.last_name AS doc_last
-- FROM prescribes p
-- JOIN citizen ci
--   ON ci.first_name = p.citizen_first_name AND ci.last_name = p.citizen_last_name AND ci.birthdate = p.citizen_birthdate
-- JOIN doctor d
--   ON d.medical_license_no = p.medical_license_no
-- ORDER BY ci.last_name, ci.first_name;

-- /* C. Doctors per hospital and per clinic (two lists) */
-- -- Hospital roster
-- SELECT h.code, h.name AS hospital, d.medical_license_no, d.first_name, d.last_name, d.specialty
-- FROM works_in w
-- JOIN hospital h ON h.code = w.code
-- JOIN doctor d   ON d.medical_license_no = w.medical_license_no
-- ORDER BY h.code, d.last_name;

-- -- Clinic roster
-- SELECT pc.name AS clinic, pc.address, d.medical_license_no, d.first_name, d.last_name, d.specialty
-- FROM employ e
-- JOIN private_clinic pc ON pc.name = e.clinic_name AND pc.address = e.clinic_address
-- JOIN doctor d         ON d.medical_license_no = e.medical_license_no
-- ORDER BY pc.name, d.last_name;

-- /* D. Incident 10002 — which agencies logged it? (three joins) */
-- -- Hospitals
-- SELECT 'Hospital' AS agency_type, h.name AS agency_name
-- FROM hospital_logs hl
-- JOIN hospital h ON h.code = hl.code
-- WHERE hl.report_number=10002 AND hl.report_date='2025-10-02'
-- UNION ALL
-- -- Fire Departments
-- SELECT 'Fire Dept', f.name
-- FROM fire_logs fl
-- JOIN fire_department f ON f.name = fl.name AND f.address = fl.address
-- WHERE fl.report_number=10002 AND fl.report_date='2025-10-02'
-- UNION ALL
-- -- Police
-- SELECT 'Police', p.name
-- FROM police_logs pl
-- JOIN police p ON p.name = pl.name AND p.address = pl.address
-- WHERE pl.report_number=10002 AND pl.report_date='2025-10-02';

-- /* E. Who reported each incident? */
-- SELECT i.report_number, i.report_date,
--        i.type, i.severity_level,
--        c.first_name || \' \' || c.last_name AS reported_by
-- FROM incidents i
-- LEFT JOIN citizen c
--   ON c.first_name = i.reported_by_first_name AND c.last_name = i.reported_by_last_name AND c.birthdate = i.reported_by_birthdate
-- ORDER BY i.report_date, i.report_number;

-- /* F. Doctor referral network (who referred to whom) */
-- SELECT d1.medical_license_no AS referrer, d1.first_name || \' \' || d1.last_name AS referrer_name,
--        d2.medical_license_no AS referee,  d2.first_name || \' \' || d2.last_name AS referee_name
-- FROM refers r
-- JOIN doctor d1 ON d1.medical_license_no = r.referrer_medical_license_no
-- JOIN doctor d2 ON d2.medical_license_no = r.referee_medical_license_no
-- ORDER BY referrer, referee;
