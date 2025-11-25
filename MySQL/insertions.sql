USE city_health_safety;

/* --------- CORE ENTITIES --------- */

/* Citizens */
INSERT INTO citizen (first_name, last_name, birthdate, address, access_nearest_hospital_clinic, no_of_calls_made) VALUES
('Rana', 'Khoury', '1998-04-12', 'Hamra, Beirut', 'AUBMC / Hamra Clinic', 4),
('Hadi', 'Mansour', '2000-09-23', 'Achrafieh, Beirut', 'Hotel Dieu / Achrafieh Clinic', 2),
('Nour', 'Habib', '1997-02-15', 'Clemenceau, Beirut', 'Clemenceau Medical Center', 1),
('Fares', 'Youssef', '1995-12-01', 'Tripoli - Al Mina', 'Tripoli Governmental Hospital', 3),
('Layan', 'Chidiac', '2002-06-30', 'Saida - Serail Area', 'Saida Governmental Hospital', 0),
('Omar', 'Daher', '1999-11-17', 'Zahle - Ksara', 'Zahle Governmental Hospital', 5),
('Tania', 'Hammoud', '1996-03-05', 'Tyre - Old Souk', 'Tyre Governmental Hospital', 2),
('Elie', 'Sarkis', '1994-10-09', 'Jounieh - Maameltein', 'Hôpital Notre Dame du Liban (Jounieh)', 1),
('Racha', 'Barakat', '1998-08-21', 'Baalbek - Ras El Ain', 'Baalbek Governmental Hospital', 6),
('Ghassan', 'Issa', '1993-07-14', 'Hazmieh - Mar Takla', 'Geitaoui Hospital / Hazmieh Clinic', 3);


/* Doctors */
INSERT INTO doctor (medical_license_no,first_name,last_name,specialty,availability,consultation_cost) VALUES
('D2001', 'Karim', 'Haddad', 'Cardiology', 'Mon-Thu 9:00-15:00', 85.00),
('D2002', 'Maya', 'Sleiman', 'Emergency Medicine', 'Daily 8:00-20:00', 60.00),
('D2003', 'Jad', 'Khoury', 'Pediatrics', 'Tue-Fri 10:00-17:00', 50.00),
('D2004', 'Nour', 'Fakhoury', 'Neurology', 'Mon-Wed 9:00-14:00', 90.00),
('D2005', 'Rami', 'Issa', 'Family Medicine', 'Mon-Sat 9:00-18:00', 45.00),
('D2006', 'Tala', 'Barakat', 'Orthopedics', 'Wed-Sat 11:00-17:00', 70.00),
('D2007', 'Elie', 'Chami', 'Dermatology', 'Tue-Fri 9:00-15:00', 55.00),
('D2008', 'Hana', 'Mansour', 'ENT', 'Mon-Thu 12:00-18:00', 50.00),
('D2009', 'Fares', 'Youssef', 'General Surgery', 'Daily 7:00-15:00', 100.00),
('D2010', 'Racha', 'Saade', 'Internal Medicine', 'Mon-Fri 10:00-16:00', 65.00);

/* Hospitals */
INSERT INTO hospital (code, name, address, bed_capacity, has_emergency_department, avg_wait_time, accreditation, coverage_area, doctor_count, staff_to_patient_ratio) VALUES
('H010', 'Hotel Dieu de France', 'Achrafieh, Beirut', 400, 1, 40, 'JCI', 'Beirut', 220, 0.1400),
('H011', 'Saint George Hospital University Medical Center', 'Ashrafieh, Beirut', 360, 1, 45, 'MoH', 'Beirut', 200, 0.1500),
('H012', 'Clemenceau Medical Center', 'Clemenceau, Beirut', 250, 1, 35, 'JCI', 'Beirut', 180, 0.1600),
('H013', 'Geitaoui Hospital', 'Achrafieh, Beirut', 210, 1, 50, 'MoH', 'Beirut', 140, 0.1300),
('H014', 'Tripoli Governmental Hospital', 'Tripoli - Al Mina', 300, 1, 55, 'MoH', 'North Lebanon', 160, 0.1200),
('H015', 'Saida Governmental Hospital', 'Saida - Serail Area', 280, 1, 60, 'MoH', 'South Lebanon', 150, 0.1100),
('H016', 'Zahle Governmental Hospital', 'Zahle - Ksara', 260, 1, 65, 'MoH', 'Bekaa', 130, 0.1250),
('H017', 'Hôpital Notre Dame du Liban', 'Jounieh - Maameltein', 230, 1, 45, 'ISO', 'Keserwan', 145, 0.1500),
('H018', 'Baalbek Governmental Hospital', 'Baalbek - Ras El Ain', 240, 1, 70, 'MoH', 'Bekaa', 120, 0.1050),
('H019', 'Tyre Governmental Hospital', 'Tyre - Old Souk', 220, 1, 72, 'MoH', 'South Lebanon', 110, 0.1150);


/* Private clinics */
INSERT INTO private_clinic (name, address, specialty, phone, email, opening_hours, has_emergency, doctor_count, referral_rate) VALUES
('Hamra Family Care Clinic', 'Hamra, Beirut', 'General Practice', '+961-1-555111', 'contact@hamrafamilycare.lb', 'Mon-Sat 9-6', 0, 12, 0.1500),
('Achrafieh Heart & Vascular Clinic', 'Achrafieh, Beirut', 'Cardiology', '+961-1-558822', 'info@achrafiehheart.lb', 'Mon-Fri 9-5', 0, 8, 0.1800),
('Clemenceau Neurology Center', 'Clemenceau, Beirut', 'Neurology', '+961-1-520100', 'hello@clemenceauneuro.lb', 'Mon-Fri 10-6', 0, 6, 0.1600),
('Tripoli Ortho & Spine Clinic', 'Tripoli - Al Mina', 'Orthopedics', '+961-6-442200', 'admin@tripoliorhto.lb', 'Mon-Sat 9-5', 0, 10, 0.1200),
('Saida Wellness Clinic', 'Saida - Serail Area', 'Internal Medicine', '+961-7-333555', 'contact@saidawellness.lb', 'Mon-Fri 9-4', 0, 7, 0.0900),
('Zahle Family Health Center', 'Zahle - Ksara', 'Family Medicine', '+961-8-990011', 'info@zahlefhc.lb', 'Mon-Sat 8-5', 0, 14, 0.1300),
('Tyre Dermatology & Laser Clinic', 'Tyre - Old Souk', 'Dermatology', '+961-7-778899', 'skin@tyrederma.lb', 'Tue-Sat 10-6', 0, 5, 0.2000),
('Jounieh Women\'s Health Clinic', 'Jounieh - Maameltein', 'Gynecology', '+961-9-660044', 'care@jouniehwomenhealth.lb', 'Mon-Fri 9-4', 0, 9, 0.1700),
('Baalbek Respiratory Clinic', 'Baalbek - Ras El Ain', 'Pulmonology', '+961-8-550077', 'resp@baalbekclinic.lb', 'Wed-Sun 9-3', 0, 4, 0.1000),
('Hazmieh ENT & Allergy Center', 'Hazmieh - Mar Takla', 'ENT', '+961-5-725511', 'contact@hazmiehent.lb', 'Mon-Sat 9-6', 0, 11, 0.1400);


/* Pharmacies */
INSERT INTO pharmacy (name, address, phone, email, opening_hours, emergency_availability, services_offered, medicine_provided, pct_medicine_out_of_stock) VALUES
('WellCare Pharmacy', 'Hamra, Beirut', '+961-1-441221', 'info@wellcarehamra.lb', 'Daily 8-11', 1, 'Vaccines; BP check; Home Delivery', 'Rx & OTC', 5.50),
('CityMed Pharmacy', 'Achrafieh, Beirut', '+961-1-331144', 'contact@citymedachrafieh.lb', 'Daily 8-10', 0, 'BP check; Glucose test', 'Rx & OTC', 8.00),
('Tripoli Health Pharmacy', 'Tripoli - Al Mina', '+961-6-441100', 'hello@tripolihealthpharmacy.lb', 'Daily 8-10', 1, 'Vaccines; BP check', 'Rx & OTC', 6.20),
('Saida Central Pharmacy', 'Saida - Serail Area', '+961-7-771122', 'contact@saidacentralph.lb', 'Daily 8-11', 0, 'BP check', 'Rx & OTC', 9.00),
('Zahle MedPlus Pharmacy', 'Zahle - Ksara', '+961-8-888022', 'support@zahlemedplus.lb', 'Mon-Sun 9-10', 1, 'Vaccines; BP check; Nebulizer Rental', 'Rx & OTC', 4.80),
('Tyre Coastal Pharmacy', 'Tyre - Old Souk', '+961-7-331099', 'info@tyrecoastalph.lb', 'Daily 8-9', 0, 'BP check; Children Medication Counseling', 'Rx & OTC', 7.30),
('Jounieh Wellness Pharmacy', 'Jounieh - Maameltein', '+961-9-660331', 'sales@jouniehwellnessph.lb', 'Daily 8-10', 1, 'BP check; Vaccines', 'Rx & OTC', 3.90),
('Baalbek Care Pharmacy', 'Baalbek - Ras El Ain', '+961-8-771500', 'info@baalbekcareph.lb', 'Daily 8-9', 0, 'Glucose test; Elderly Support', 'Rx & OTC', 11.20),
('Hazmieh GreenLife Pharmacy', 'Hazmieh - Mar Takla', '+961-5-555444', 'hello@greenlifehazmieh.lb', 'Daily 8-11', 1, 'Vaccines; BP check; Supplements Advice', 'Rx & OTC', 6.70),
('Dora Express Pharmacy', 'Dora, Beirut', '+961-1-252525', 'contact@doraexpressph.lb', 'Mon-Sun 8-12', 1, 'BP check; Home Delivery; Rapid Tests', 'Rx & OTC', 2.90);

/* Fire Department */
INSERT INTO fire_department (name, address, phone, station_type, coverage_area, avg_response_time, no_of_functioning_fire_vehicles, water_supply) VALUES
('FD Beirut Central', 'Clemenceau, Beirut', '125', 'Urban', 'Beirut', 8, 8, 'Adequate'),
('FD Hamra Station', 'Hamra, Beirut', '125', 'Urban', 'Ras Beirut', 9, 6, 'Adequate'),
('FD Achrafieh Unit', 'Achrafieh, Beirut', '125', 'Urban', 'East Beirut', 10, 5, 'Adequate'),
('FD Tripoli North', 'Tripoli - Al Mina', '125', 'Urban', 'North Lebanon', 11, 7, 'Strong'),
('FD Saida South', 'Saida - Serail Area', '125', 'Urban', 'South Lebanon', 12, 5, 'Adequate'),
('FD Zahle Bekaa', 'Zahle - Ksara', '125', 'Rural', 'Bekaa', 13, 4, 'Adequate'),
('FD Tyre Coastal', 'Tyre - Old Souk', '125', 'Urban', 'South Lebanon', 11, 6, 'Limited'),
('FD Jounieh Keserwan', 'Jounieh - Maameltein', '125', 'Urban', 'Keserwan', 9, 7, 'Adequate'),
('FD Baalbek Station', 'Baalbek - Ras El Ain', '125', 'Rural', 'Bekaa', 14, 3, 'Limited'),
('FD Dora Industrial', 'Dora, Beirut', '125', 'Urban', 'Metn', 8, 9, 'Strong');

/* Police */
INSERT INTO police (name, address, station_type, coverage_area, officers_count, avg_response_time, incidents_handled_per_citizen_ratio, officer_to_population_ratio) VALUES
('Beirut Central Police Station', 'Clemenceau, Beirut', 'Urban', 'Beirut', 520, 11, 0.002600, 0.001900),
('Hamra District Police', 'Hamra, Beirut', 'Urban', 'Ras Beirut', 310, 12, 0.003000, 0.002200),
('Achrafieh Police Command', 'Achrafieh, Beirut', 'Urban', 'East Beirut', 280, 14, 0.003200, 0.002400),
('Tripoli North Police', 'Tripoli - Al Mina', 'Urban', 'North Lebanon', 450, 15, 0.002900, 0.001700),
('Saida South Police', 'Saida - Serail Area', 'Urban', 'South Lebanon', 270, 13, 0.003100, 0.002100),
('Zahle Bekaa Police', 'Zahle - Ksara', 'Urban', 'Bekaa', 220, 16, 0.003500, 0.002800),
('Tyre Coastal Police', 'Tyre - Old Souk', 'Urban', 'South Lebanon', 240, 12, 0.002700, 0.001600),
('Jounieh Keserwan Police', 'Jounieh - Maameltein', 'Urban', 'Keserwan', 260, 11, 0.002900, 0.001800),
('Baalbek Regional Police', 'Baalbek - Ras El Ain', 'Rural', 'Bekaa', 180, 17, 0.003800, 0.002900),
('Dora Industrial Police Station', 'Dora, Beirut', 'Urban', 'Metn', 300, 10, 0.002400, 0.001500);

/* Incidents (note: reported_by_* must match an existing citizen or be NULL) */
INSERT INTO incidents (report_number, report_date, type, severity_level, resources_mobilized, location_accessibility, location, outcome, reported_by_first_name, reported_by_last_name, reported_by_birthdate) VALUES
(10001, '2025-01-12', 'Traffic Accident', 3, 'Ambulance; Police', 'Moderate', 'Hamra Main Road, Beirut', 'Stabilized', 'Rana', 'Khoury', '1998-04-12'),
(10002, '2025-02-03', 'Gas Leak Report', 4, 'Fire Department; Police', 'Easy', 'Achrafieh, Beirut', 'Evacuated Safely', 'Hadi', 'Mansour', '2000-09-23'),
(10003, '2025-02-19', 'Residential Fire', 5, 'Fire Brigade; Ambulance', 'Difficult', 'Clemenceau, Beirut', 'Controlled', 'Nour', 'Habib', '1997-02-15'),
(10004, '2025-03-07', 'Medical Emergency', 2, 'Ambulance', 'Easy', 'Tripoli - Al Mina', 'Treated On Scene', 'Fares', 'Youssef', '1995-12-01'),
(10005, '2025-03-28', 'Flooding from Heavy Rain', 3, 'Civil Defense; Police', 'Moderate', 'Saida - Serail Area', 'Resolved', 'Layan', 'Chidiac', '2002-06-30'),
(10006, '2025-04-14', 'Power Generator Explosion', 4, 'Fire Brigade; Ambulance', 'Difficult', 'Zahle - Ksara', 'Stabilized', 'Omar', 'Daher', '1999-11-17'),
(10007, '2025-05-01', 'Highway Collision', 3, 'Ambulance; Police; Fire Brigade', 'Moderate', 'Tyre Highway Entrance', 'Transported to Hospital', 'Tania', 'Hammoud', '1996-03-05'),
(10008, '2025-05-18', 'Elevator Malfunction', 2, 'Civil Defense', 'Easy', 'Jounieh - Maameltein', 'Resolved', 'Elie', 'Sarkis', '1994-10-09'),
(10009, '2025-06-09', 'Construction Site Injury', 4, 'Ambulance; Police', 'Moderate', 'Baalbek - Ras El Ain', 'Hospitalized', 'Racha', 'Barakat', '1998-08-21'),
(10010, '2025-06-27', 'Market Fire Incident', 5, 'Fire Brigade; Civil Defense; Ambulance', 'Difficult', 'Hazmieh - Mar Takla', 'Contained', 'Ghassan', 'Issa', '1993-07-14');

/* --------- RELATIONSHIPS --------- */

/* Refers (doctor -> doctor) */
INSERT INTO refers (referrer_medical_license_no, referee_medical_license_no) VALUES
('D2005', 'D2001'), -- Family Medicine → Cardiology
('D2005', 'D2004'), -- Family Medicine → Neurology
('D2003', 'D2006'), -- Pediatrics → Orthopedics
('D2003', 'D2007'), -- Pediatrics → Dermatology
('D2002', 'D2009'), -- Emergency → General Surgery
('D2002', 'D2010'), -- Emergency → Internal Medicine
('D2008', 'D2004'), -- ENT → Neurology
('D2001', 'D2010'), -- Cardiology → Internal Medicine
('D2006', 'D2009'), -- Orthopedics → General Surgery
('D2007', 'D2008'); -- Dermatology → ENT


INSERT INTO employ (medical_license_no, clinic_name, clinic_address) VALUES
('D2005', 'Hamra Family Care Clinic', 'Hamra, Beirut'),
('D2003', 'Hamra Family Care Clinic', 'Hamra, Beirut'),  -- pediatrics fits

('D2001', 'Achrafieh Heart & Vascular Clinic', 'Achrafieh, Beirut'), -- cardiologist

('D2004', 'Clemenceau Neurology Center', 'Clemenceau, Beirut'),   -- neurologist
('D2002', 'Clemenceau Neurology Center', 'Clemenceau, Beirut'),   -- emergency (works sessions)

('D2006', 'Tripoli Ortho & Spine Clinic', 'Tripoli - Al Mina'),   -- orthopedics

('D2005', 'Zahle Family Health Center', 'Zahle - Ksara'),          -- family medicine
('D2010', 'Zahle Family Health Center', 'Zahle - Ksara'),          -- internal medicine

('D2007', 'Tyre Dermatology & Laser Clinic', 'Tyre - Old Souk'),   -- dermatologist

('D2008', 'Hazmieh ENT & Allergy Center', 'Hazmieh - Mar Takla'),  -- ENT

('D2010', 'Saida Wellness Clinic', 'Saida - Serail Area'),         -- internal medicine
('D2009', 'Saida Wellness Clinic', 'Saida - Serail Area'),         -- general surgery consult

('D2008', 'Jounieh Women\'s Health Clinic', 'Jounieh - Maameltein'), -- ENT support
('D2003', 'Jounieh Women\'s Health Clinic', 'Jounieh - Maameltein'); -- pediatrics support


/* Works_in (hospital <-> doctor) */
INSERT INTO works_in (medical_license_no, code) VALUES
('D2001', 'H010'), -- Cardiologist at Hotel Dieu
('D2001', 'H011'), -- Also at Saint George UMC

('D2002', 'H012'), -- Emergency Medicine at CMC
('D2002', 'H015'), -- Also supports Saida ER

('D2003', 'H011'), -- Pediatrics at Saint George
('D2003', 'H014'), -- Pediatric rounds in Tripoli

('D2004', 'H012'), -- Neurologist at CMC
('D2004', 'H013'), -- Neurology consults at Geitaoui

('D2005', 'H016'), -- Family Medicine at Zahle Gov
('D2005', 'H018'), -- Occasional rounds at Baalbek Gov

('D2006', 'H014'), -- Orthopedics in Tripoli Gov
('D2006', 'H017'), -- Ortho consults in Jounieh

('D2007', 'H019'), -- Dermatology consults in Tyre
('D2007', 'H010'); -- Dermatology clinic hours at Hotel Dieu


/* Consult (citizen <-> doctor) */
INSERT INTO consult (citizen_first_name, citizen_last_name, citizen_birthdate, medical_license_no) VALUES
('Rana', 'Khoury', '1998-04-12', 'D2005'), -- family medicine
('Rana', 'Khoury', '1998-04-12', 'D2007'), -- dermatology

('Hadi', 'Mansour', '2000-09-23', 'D2005'), -- family medicine
('Hadi', 'Mansour', '2000-09-23', 'D2002'), -- emergency after incident

('Nour', 'Habib', '1997-02-15', 'D2010'), -- internal medicine
('Nour', 'Habib', '1997-02-15', 'D2004'), -- neurology

('Fares', 'Youssef', '1995-12-01', 'D2006'), -- orthopedics
('Fares', 'Youssef', '1995-12-01', 'D2001'), -- cardiology check-up

('Layan', 'Chidiac', '2002-06-30', 'D2003'), -- pediatrics follow-up (young adult)
('Layan', 'Chidiac', '2002-06-30', 'D2008'), -- ENT

('Omar', 'Daher', '1999-11-17', 'D2010'), -- internal medicine
('Omar', 'Daher', '1999-11-17', 'D2002'), -- emergency-related

('Tania', 'Hammoud', '1996-03-05', 'D2007'), -- dermatology
('Tania', 'Hammoud', '1996-03-05', 'D2005'), -- general family medicine

('Elie', 'Sarkis', '1994-10-09', 'D2008'), -- ENT
('Elie', 'Sarkis', '1994-10-09', 'D2004'), -- neurology

('Racha', 'Barakat', '1998-08-21', 'D2010'), -- internal medicine
('Racha', 'Barakat', '1998-08-21', 'D2009'), -- surgery consult after incident

('Ghassan', 'Issa', '1993-07-14', 'D2001'), -- cardiology
('Ghassan', 'Issa', '1993-07-14', 'D2005'); -- family medicine


/* Prescribes (citizen <-> doctor) */
INSERT INTO prescribes (citizen_first_name, citizen_last_name, citizen_birthdate, medical_license_no) VALUES
('Rana', 'Khoury', '1998-04-12', 'D2005'), -- family medicine prescription
('Rana', 'Khoury', '1998-04-12', 'D2007'), -- dermatology cream

('Hadi', 'Mansour', '2000-09-23', 'D2005'), -- GP follow-up
('Hadi', 'Mansour', '2000-09-23', 'D2002'), -- emergency medication

('Nour', 'Habib', '1997-02-15', 'D2010'), -- internal medicine chronic meds
('Nour', 'Habib', '1997-02-15', 'D2004'), -- neurology medication (migraine)

('Fares', 'Youssef', '1995-12-01', 'D2006'), -- orthopedic pain management
('Fares', 'Youssef', '1995-12-01', 'D2001'), -- cardiology check-up meds

('Layan', 'Chidiac', '2002-06-30', 'D2003'), -- pediatric/young adult meds

('Omar', 'Daher', '1999-11-17', 'D2010'), -- internal medicine for follow-up

('Tania', 'Hammoud', '1996-03-05', 'D2007'), -- dermatology topical treatment

('Racha', 'Barakat', '1998-08-21', 'D2009'); -- surgery-related prescription


/* Logs (agency <-> incident) */
INSERT INTO hospital_logs (report_number, report_date, code) VALUES
(10001, '2025-01-12', 'H010'), -- Hamra → Hotel Dieu
(10002, '2025-02-03', 'H011'), -- Achrafieh → Saint George UMC
(10003, '2025-02-19', 'H012'), -- Clemenceau → CMC
(10004, '2025-03-07', 'H014'), -- Tripoli
(10005, '2025-03-28', 'H015'), -- Saida
(10006, '2025-04-14', 'H016'), -- Zahle
(10007, '2025-05-01', 'H019'), -- Tyre
(10008, '2025-05-18', 'H017'), -- Jounieh
(10009, '2025-06-09', 'H018'), -- Baalbek
(10010, '2025-06-27', 'H013'); -- Hazmieh → Geitaoui


INSERT INTO fire_logs (report_number, report_date, name, address) VALUES
-- 10001: Hamra Traffic Accident
(10001, '2025-01-12', 'FD Hamra Station', 'Hamra, Beirut'),

-- 10002: Achrafieh Gas Leak
(10002, '2025-02-03', 'FD Achrafieh Unit', 'Achrafieh, Beirut'),

-- 10003: Clemenceau Residential Fire (2 stations)
(10003, '2025-02-19', 'FD Beirut Central', 'Clemenceau, Beirut'),
(10003, '2025-02-19', 'FD Hamra Station', 'Hamra, Beirut'),

-- 10005: Saida Flooding
(10005, '2025-03-28', 'FD Saida South', 'Saida - Serail Area'),

-- 10006: Zahle Generator Explosion
(10006, '2025-04-14', 'FD Zahle Bekaa', 'Zahle - Ksara'),

-- 10007: Tyre Highway Collision
(10007, '2025-05-01', 'FD Tyre Coastal', 'Tyre - Old Souk'),

-- 10010: Hazmieh Market Fire (2 stations)
(10010, '2025-06-27', 'FD Dora Industrial', 'Dora, Beirut'),
(10010, '2025-06-27', 'FD Achrafieh Unit', 'Achrafieh, Beirut');


INSERT INTO police_logs (report_number, report_date, name, address) VALUES
-- 10001 Hamra Accident
(10001, '2025-01-12', 'Hamra District Police', 'Hamra, Beirut'),

-- 10002 Gas Leak Achrafieh
(10002, '2025-02-03', 'Achrafieh Police Command', 'Achrafieh, Beirut'),

-- 10003 Residential Fire Clemenceau
(10003, '2025-02-19', 'Beirut Central Police Station', 'Clemenceau, Beirut'),

-- 10005 Flooding Saida
(10005, '2025-03-28', 'Saida South Police', 'Saida - Serail Area'),

-- 10006 Generator Explosion Zahle
(10006, '2025-04-14', 'Zahle Bekaa Police', 'Zahle - Ksara'),

-- 10007 Highway Collision Tyre
(10007, '2025-05-01', 'Tyre Coastal Police', 'Tyre - Old Souk'),

-- 10008 Elevator Malfunction Jounieh
(10008, '2025-05-18', 'Jounieh Keserwan Police', 'Jounieh - Maameltein'),

-- 10009 Construction Site Injury Baalbek
(10009, '2025-06-09', 'Baalbek Regional Police', 'Baalbek - Ras El Ain'),

-- 10010 Market Fire Hazmieh
(10010, '2025-06-27', 'Dora Industrial Police Station', 'Dora, Beirut');




