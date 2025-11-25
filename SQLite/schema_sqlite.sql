
/* =========================
   CORE ENTITIES
   ========================= */

/* CITIZEN (PK = First name + Last name + Birthdate) */
CREATE TABLE citizen (
  first_name   TEXT  NOT NULL,  -- VARCHAR -> TEXT
  last_name    TEXT  NOT NULL,
  birthdate    TEXT  NOT NULL,  -- DATE -> TEXT (stored as 'YYYY-MM-DD')
  address      TEXT,
  access_nearest_hospital_clinic TEXT,
  no_of_calls_made INTEGER,     -- INT -> INTEGER
  PRIMARY KEY (first_name, last_name, birthdate)
);

/* DOCTOR (PK = Medical License no) */
CREATE TABLE doctor (
  medical_license_no TEXT PRIMARY KEY,
  first_name         TEXT NOT NULL,
  last_name          TEXT NOT NULL,
  specialty          TEXT,
  availability       TEXT,
  consultation_cost  REAL  -- DECIMAL -> REAL
);

/* HOSPITAL (PK = Code) */
CREATE TABLE hospital (
  code                    TEXT PRIMARY KEY,
  name                    TEXT NOT NULL,
  address                 TEXT,
  bed_capacity            INTEGER,
  has_emergency_department INTEGER,  
  avg_wait_time           INTEGER,
  accreditation           TEXT,
  coverage_area           TEXT,
  doctor_count            INTEGER,
  staff_to_patient_ratio  REAL
);

/* PRIVATE CLINIC (PK = Name + Address) */
CREATE TABLE private_clinic (
  name          TEXT NOT NULL,
  address       TEXT NOT NULL,
  specialty     TEXT,
  phone         TEXT,
  email         TEXT,
  opening_hours TEXT,
  has_emergency INTEGER,
  doctor_count  INTEGER,
  referral_rate REAL,
  PRIMARY KEY (name, address)
);

/* PHARMACY (PK = Name + Address) */
CREATE TABLE pharmacy (
  name                  TEXT NOT NULL,
  address               TEXT NOT NULL,
  phone                 TEXT,
  email                 TEXT,
  opening_hours         TEXT,
  emergency_availability INTEGER,
  services_offered      TEXT,
  medicine_provided     TEXT,
  pct_medicine_out_of_stock REAL,
  PRIMARY KEY (name, address)
);

/* FIRE DEPARTMENT (PK = Name + Address) */
CREATE TABLE fire_department (
  name            TEXT NOT NULL,
  address         TEXT NOT NULL,
  phone           TEXT,
  station_type    TEXT,
  coverage_area   TEXT,
  avg_response_time INTEGER,
  no_of_functioning_fire_vehicles INTEGER,
  water_supply    TEXT,
  PRIMARY KEY (name, address)
);

/* POLICE (PK = Name + Address) */
CREATE TABLE police (
  name                           TEXT NOT NULL,
  address                        TEXT NOT NULL,
  station_type                   TEXT,
  coverage_area                  TEXT,
  officers_count                 INTEGER,
  avg_response_time              INTEGER,
  incidents_handled_per_citizen_ratio REAL,
  officer_to_population_ratio    REAL,
  PRIMARY KEY (name, address)
);

/* INCIDENTS (PK = Report number + Report date) */
CREATE TABLE incidents (
  report_number        INTEGER NOT NULL,  -- BIGINT → INTEGER
  report_date          TEXT    NOT NULL,
  type                 TEXT,
  severity_level       INTEGER,
  resources_mobilized  TEXT,
  location_accessibility TEXT,
  location             TEXT,
  outcome              TEXT,
  -- "Reported by" references Citizen (composite key)
  reported_by_first_name TEXT,
  reported_by_last_name  TEXT,
  reported_by_birthdate  TEXT,
  PRIMARY KEY (report_number, report_date),
  FOREIGN KEY (reported_by_first_name, reported_by_last_name, reported_by_birthdate)
    REFERENCES citizen(first_name, last_name, birthdate)
    ON UPDATE CASCADE
    ON DELETE SET NULL
);

/* =========================
   RELATIONSHIP TABLES
   ========================= */

/* REFERS (Doctor -> Doctor) */
CREATE TABLE refers (
  referrer_medical_license_no TEXT NOT NULL,
  referee_medical_license_no  TEXT NOT NULL,
  PRIMARY KEY (referrer_medical_license_no, referee_medical_license_no),
  FOREIGN KEY (referrer_medical_license_no) REFERENCES doctor(medical_license_no)
    ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (referee_medical_license_no) REFERENCES doctor(medical_license_no)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

/* EMPLOY (PrivateClinic ↔ Doctor) */
CREATE TABLE employ (
  medical_license_no TEXT NOT NULL,
  clinic_name        TEXT NOT NULL,
  clinic_address     TEXT NOT NULL,
  PRIMARY KEY (medical_license_no, clinic_name, clinic_address),
  FOREIGN KEY (medical_license_no) REFERENCES doctor(medical_license_no)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  FOREIGN KEY (clinic_name, clinic_address) REFERENCES private_clinic(name, address)
    ON UPDATE CASCADE ON DELETE CASCADE
);

/* WORKS IN (Hospital ↔ Doctor) */
CREATE TABLE works_in (
  medical_license_no TEXT NOT NULL,
  code               TEXT NOT NULL,
  PRIMARY KEY (medical_license_no, code),
  FOREIGN KEY (medical_license_no) REFERENCES doctor(medical_license_no)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  FOREIGN KEY (code) REFERENCES hospital(code)
    ON UPDATE CASCADE ON DELETE CASCADE
);

/* CONSULT (Citizen ↔ Doctor) */
CREATE TABLE consult (
  citizen_first_name  TEXT NOT NULL,
  citizen_last_name   TEXT NOT NULL,
  citizen_birthdate   TEXT NOT NULL,
  medical_license_no  TEXT NOT NULL,
  PRIMARY KEY (citizen_first_name, citizen_last_name, citizen_birthdate, medical_license_no),
  FOREIGN KEY (citizen_first_name, citizen_last_name, citizen_birthdate)
    REFERENCES citizen(first_name, last_name, birthdate)
    ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (medical_license_no) REFERENCES doctor(medical_license_no)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

/* PRESCRIBES (Citizen ↔ Doctor) */
CREATE TABLE prescribes (
  citizen_first_name  TEXT NOT NULL,
  citizen_last_name   TEXT NOT NULL,
  citizen_birthdate   TEXT NOT NULL,
  medical_license_no  TEXT NOT NULL,
  PRIMARY KEY (citizen_first_name, citizen_last_name, citizen_birthdate, medical_license_no),
  FOREIGN KEY (citizen_first_name, citizen_last_name, citizen_birthdate)
    REFERENCES citizen(first_name, last_name, birthdate)
    ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (medical_license_no) REFERENCES doctor(medical_license_no)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

/* HOSPITAL LOGS (Hospital ↔ Incident) */
CREATE TABLE hospital_logs (
  report_number INTEGER NOT NULL,
  report_date   TEXT    NOT NULL,
  code          TEXT    NOT NULL,
  PRIMARY KEY (report_number, report_date, code),
  FOREIGN KEY (report_number, report_date)
    REFERENCES incidents(report_number, report_date)
    ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (code) REFERENCES hospital(code)
    ON UPDATE CASCADE ON DELETE CASCADE
);

/* FIRE DEPARTMENT LOGS (FireDepartment ↔ Incident) */
CREATE TABLE fire_logs (
  report_number INTEGER NOT NULL,
  report_date   TEXT    NOT NULL,
  name          TEXT    NOT NULL,
  address       TEXT    NOT NULL,
  PRIMARY KEY (report_number, report_date, name, address),
  FOREIGN KEY (report_number, report_date)
    REFERENCES incidents(report_number, report_date)
    ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (name, address) REFERENCES fire_department(name, address)
    ON UPDATE CASCADE ON DELETE CASCADE
);

/* POLICE LOGS (Police ↔ Incident) */
CREATE TABLE police_logs (
  report_number INTEGER NOT NULL,
  report_date   TEXT    NOT NULL,
  name          TEXT    NOT NULL,
  address       TEXT    NOT NULL,
  PRIMARY KEY (report_number, report_date, name, address),
  FOREIGN KEY (report_number, report_date)
    REFERENCES incidents(report_number, report_date)
    ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (name, address) REFERENCES police(name, address)
    ON UPDATE CASCADE ON DELETE CASCADE
);

-- Enable foreign key constraints (disabled by default in SQLite)
PRAGMA foreign_keys = ON;

