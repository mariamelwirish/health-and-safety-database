USE city_health_safety;

/* --------- CORE ENTITIES --------- */

/* Citizens */
INSERT INTO citizen (first_name,last_name,birthdate,address,access_nearest_hospital_clinic,no_of_calls_made) VALUES
('Alice','Smith','1999-05-10','Hamra, Beirut','AUBMC / Hamra Clinic',3),
('Bob','Nader','2001-11-02','Achrafieh, Beirut','RHUH / Downtown Clinic',1),
('Carol','Aziz','1995-03-20','Verdun, Beirut','AUBMC / Hamra Clinic',0);

/* Doctors */
INSERT INTO doctor (medical_license_no,first_name,last_name,specialty,availability,consultation_cost) VALUES
('D1001','John','Kareem','Cardiology','Mon-Thu 9-3',75.00),
('D1002','Layla','Haddad','Emergency Medicine','Daily 8-8',60.00),
('D1003','Rami','Saab','General Practice','Mon-Fri 10-4',40.00);

/* Hospitals */
INSERT INTO hospital (code,name,address,bed_capacity,has_emergency_department,avg_wait_time,accreditation,coverage_area,doctor_count,staff_to_patient_ratio) VALUES
('H001','AUBMC','Hamra, Beirut',600,1,35,'JCI','Beirut',350,0.1200),
('H002','RHUH','Bir Hasan, Beirut',450,1,45,'MoH','Beirut',280,0.1400);

/* Private clinics */
INSERT INTO private_clinic (name,address,specialty,phone,email,opening_hours,has_emergency,doctor_count,referral_rate) VALUES
('Hamra Clinic','Hamra, Beirut','Multi-specialty','+961-1-111111','info@hamraclinic.lb','Mon-Sat 9-6',0,12,0.1500),
('Downtown Clinic','Downtown, Beirut','General Practice','+961-1-222222','hello@downtownclinic.lb','Mon-Fri 9-5',0,6,0.0800);

/* Pharmacies */
INSERT INTO pharmacy (name,address,phone,email,opening_hours,emergency_availability,services_offered,medicine_provided,pct_medicine_out_of_stock) VALUES
('WellCare Pharmacy','Hamra, Beirut','+961-1-333333','care@wellcare.lb','Daily 8-11',1,'Vaccines; BP check','Rx & OTC',5.00),
('CityMed Pharmacy','Achrafieh, Beirut','+961-1-444444','hello@citymed.lb','Daily 8-10',0,'BP check','Rx & OTC',8.50);

/* Fire Department */
INSERT INTO fire_department (name,address,phone,station_type,coverage_area,avg_response_time,no_of_functioning_fire_vehicles,water_supply) VALUES
('FD West','Jnah, Beirut','125','Urban','West Beirut',8,6,'Adequate'),
('FD East','Achrafieh, Beirut','125','Urban','East Beirut',9,5,'Adequate');

/* Police */
INSERT INTO police (name,address,station_type,coverage_area,officers_count,avg_response_time,incidents_handled_per_citizen_ratio,officer_to_population_ratio) VALUES
('Beirut Central','Clemenceau, Beirut','Urban','Beirut',520,11,0.002500,0.001800),
('Ashrafieh Precinct','Achrafieh, Beirut','Urban','Achrafieh',210,13,0.003100,0.002200);

/* Incidents (note: reported_by_* must match an existing citizen or be NULL) */
INSERT INTO incidents (report_number,report_date,type,severity_level,resources_mobilized,location_accessibility,location,outcome,
                       reported_by_first_name,reported_by_last_name,reported_by_birthdate) VALUES
(10001,'2025-10-01','Medical Emergency',3,'Ambulance; ER Team','Easy','Hamra Main St.','Stabilized','Alice','Smith','1999-05-10'),
(10002,'2025-10-02','Traffic Accident',2,'Ambulance; Police; Fire','Moderate','Ring Road Exit 3','Resolved','Bob','Nader','2001-11-02');

/* --------- RELATIONSHIPS --------- */

/* Refers (doctor -> doctor) */
INSERT INTO refers (referrer_medical_license_no,referee_medical_license_no) VALUES
('D1001','D1002'),
('D1003','D1001');

/* Employ (clinic <-> doctor) */
INSERT INTO employ (medical_license_no,clinic_name,clinic_address) VALUES
('D1001','Hamra Clinic','Hamra, Beirut'),
('D1002','Downtown Clinic','Downtown, Beirut'),
('D1003','Hamra Clinic','Hamra, Beirut');

/* Works_in (hospital <-> doctor) */
INSERT INTO works_in (medical_license_no,code) VALUES
('D1001','H001'),
('D1002','H002'),
('D1003','H001');

/* Consult (citizen <-> doctor) */
INSERT INTO consult (citizen_first_name,citizen_last_name,citizen_birthdate,medical_license_no) VALUES
('Alice','Smith','1999-05-10','D1001'),
('Alice','Smith','1999-05-10','D1003'),
('Bob','Nader','2001-11-02','D1002');

/* Prescribes (citizen <-> doctor) */
INSERT INTO prescribes (citizen_first_name,citizen_last_name,citizen_birthdate,medical_license_no) VALUES
('Alice','Smith','1999-05-10','D1001'),
('Bob','Nader','2001-11-02','D1002');

/* Logs (agency <-> incident) */
INSERT INTO hospital_logs (report_number,report_date,code) VALUES
(10001,'2025-10-01','H001'),
(10002,'2025-10-02','H002');

INSERT INTO fire_logs (report_number,report_date,name,address) VALUES
(10002,'2025-10-02','FD East','Achrafieh, Beirut'),
(10002,'2025-10-02','FD West','Jnah, Beirut');

INSERT INTO police_logs (report_number,report_date,name,address) VALUES
(10002,'2025-10-02','Beirut Central','Clemenceau, Beirut');



