SELECT 'citizen' AS table_name, COUNT(*) AS `rows` FROM citizen
UNION ALL
SELECT 'doctor', COUNT(*) FROM doctor
UNION ALL
SELECT 'hospital', COUNT(*) FROM hospital
UNION ALL
SELECT 'private_clinic', COUNT(*) FROM private_clinic
UNION ALL
SELECT 'pharmacy', COUNT(*) FROM pharmacy
UNION ALL
SELECT 'fire_department', COUNT(*) FROM fire_department
UNION ALL
SELECT 'police', COUNT(*) FROM police
UNION ALL
SELECT 'incidents', COUNT(*) FROM incidents
UNION ALL
SELECT 'refers', COUNT(*) FROM refers
UNION ALL
SELECT 'employ', COUNT(*) FROM employ
UNION ALL
SELECT 'works_in', COUNT(*) FROM works_in
UNION ALL
SELECT 'consult', COUNT(*) FROM consult
UNION ALL
SELECT 'prescribes', COUNT(*) FROM prescribes
UNION ALL
SELECT 'hospital_logs', COUNT(*) FROM hospital_logs
UNION ALL
SELECT 'fire_logs', COUNT(*) FROM fire_logs
UNION ALL
SELECT 'police_logs', COUNT(*) FROM police_logs;


