/* ============================================================
   PERFORMANCE OPTIMIZATION: INDEXES
   These indexes are designed to speed up specific Complex Queries
   by optimizing filtering (WHERE) and linking (JOIN).
   ============================================================ */

-- 1. Optimize "Difficult" Accessibility Filtering
-- USED IN: Complex Query #8 and #9
-- WHY: These queries filter specifically for 'Difficult' locations. 
-- An index here avoids scanning the entire table to find them.
CREATE INDEX idx_incidents_accessibility ON incidents (location_accessibility);

-- 2. Optimize Citizen History Lookups
-- USED IN: Complex Query #9 and #10
-- WHY: We frequently join CITIZEN to CONSULT. This index on the 
-- Foreign Key in 'consult' speeds up finding a specific person's medical history.
CREATE INDEX idx_consult_citizen ON consult (citizen_first_name, citizen_last_name, citizen_birthdate);

-- 3. Optimize Doctor-to-Facility Links
-- USED IN: Complex Query #5 and #10 ("Regional Magnets")
-- WHY: These queries link doctors to hospitals/clinics. Indexing the 
-- Foreign Keys in the relationship tables speeds up these connections.
CREATE INDEX idx_works_in_code ON works_in (code); -- Search by Hospital Code
CREATE INDEX idx_employ_clinic ON employ (clinic_name, clinic_address); -- Search by Clinic

-- 4. Optimize Emergency Response Analysis
-- USED IN: Complex Query #2 and #6 ("Underserved Areas" & "Multi-Agency")
-- WHY: These queries join INCIDENTS to LOGS. We must index the Foreign Keys
-- in the log tables to instantly find which agencies responded to a specific report.
CREATE INDEX idx_hospital_logs_fk ON hospital_logs (report_number, report_date);
CREATE INDEX idx_fire_logs_fk ON fire_logs (report_number, report_date);
CREATE INDEX idx_police_logs_fk ON police_logs (report_number, report_date);

-- 5. Optimize Doctor Specialty Analysis
-- USED IN: Complex Query #9 (Doctor Revenue/Workload)
-- WHY: Grouping and sorting doctors by specialty is faster if the column is indexed.
CREATE INDEX idx_doctor_specialty ON doctor (specialty);

/* Note: Primary Keys (citizen_id, report_number, etc.) are automatically 
   indexed by MySQL (Clustered Index), so we do not need to re-index them here. */