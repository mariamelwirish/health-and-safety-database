
CREATE DATABASE IF NOT EXISTS city_health_safety;
USE city_health_safety;

/* =========================
   CORE ENTITIES
   ========================= */

/* CITIZEN  (PK = First name + Last name + Birthdate) */
CREATE TABLE citizen (
  first_name   VARCHAR(60)  NOT NULL,
  last_name    VARCHAR(60)  NOT NULL,
  birthdate    DATE         NOT NULL,
  address      VARCHAR(255),
  access_nearest_hospital_clinic VARCHAR(255),
  no_of_calls_made INT,
  PRIMARY KEY (first_name, last_name, birthdate)
);

/* DOCTOR (PK = Medical License no) */
CREATE TABLE doctor (
  medical_license_no VARCHAR(32) PRIMARY KEY,
  first_name         VARCHAR(60) NOT NULL,
  last_name          VARCHAR(60) NOT NULL,
  specialty          VARCHAR(120),
  availability       VARCHAR(120),
  consultation_cost  DECIMAL(10,2)
);

/* HOSPITAL (PK = Code) */
CREATE TABLE hospital (
  code                    VARCHAR(32) PRIMARY KEY,
  name                    VARCHAR(120) NOT NULL,
  address                 VARCHAR(255),
  bed_capacity            INT,
  has_emergency_department TINYINT,
  avg_wait_time           INTEGER,
  accreditation           VARCHAR(120),
  coverage_area           VARCHAR(120),
  doctor_count            INT,
  staff_to_patient_ratio  DECIMAL(10,4)
);

/* PRIVATE CLINIC (PK = Name + Address) */
CREATE TABLE private_clinic (
  name          VARCHAR(120) NOT NULL,
  address       VARCHAR(255) NOT NULL,
  specialty     VARCHAR(120),
  phone         VARCHAR(40),
  email         VARCHAR(120),
  opening_hours VARCHAR(120),
  has_emergency TINYINT,
  doctor_count  INT,
  referral_rate DECIMAL(10,4),
  PRIMARY KEY (name, address)
);

/* PHARMACY (PK = Name + Address) */
CREATE TABLE pharmacy (
  name                  VARCHAR(120) NOT NULL,
  address               VARCHAR(255) NOT NULL,
  phone                 VARCHAR(40),
  email                 VARCHAR(120),
  opening_hours         VARCHAR(120),
  emergency_availability TINYINT,
  services_offered      TEXT,
  medicine_provided     TEXT,
  pct_medicine_out_of_stock DECIMAL(5,2),
  PRIMARY KEY (name, address)
);

/* FIRE DEPARTMENT (PK = Name + Address) */
CREATE TABLE fire_department (
  name            VARCHAR(120) NOT NULL,
  address         VARCHAR(255) NOT NULL,
  phone           VARCHAR(40),
  station_type    VARCHAR(60),
  coverage_area   VARCHAR(120),
  avg_response_time INT,
  no_of_functioning_fire_vehicles INT,
  water_supply    VARCHAR(120),
  PRIMARY KEY (name, address)
);

/* POLICE (PK = Name + Address) */
CREATE TABLE police (
  name                           VARCHAR(120) NOT NULL,
  address                        VARCHAR(255) NOT NULL,
  station_type                   VARCHAR(60),
  coverage_area                  VARCHAR(120),
  officers_count                 INT,
  avg_response_time              INT,
  incidents_handled_per_citizen_ratio DECIMAL(10,6),
  officer_to_population_ratio    DECIMAL(10,6),
  PRIMARY KEY (name, address)
);

/* INCIDENTS (PK = Report number + Report date) */
CREATE TABLE incidents (
  report_number        BIGINT      NOT NULL,
  report_date          DATE        NOT NULL,
  type                 VARCHAR(80),
  severity_level       INT,
  resources_mobilized  TEXT,
  location_accessibility VARCHAR(120),
  location             VARCHAR(255),
  outcome              VARCHAR(120),
  /* "Reported by" references Citizen (composite key) */
  reported_by_first_name VARCHAR(60),
  reported_by_last_name  VARCHAR(60),
  reported_by_birthdate  DATE,
  PRIMARY KEY (report_number, report_date),
  CONSTRAINT fk_incident_reported_by
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
  referrer_medical_license_no VARCHAR(32) NOT NULL,
  referee_medical_license_no  VARCHAR(32) NOT NULL,
  PRIMARY KEY (referrer_medical_license_no, referee_medical_license_no),
  CONSTRAINT fk_refers_referrer
    FOREIGN KEY (referrer_medical_license_no) REFERENCES doctor(medical_license_no)
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_refers_referee
    FOREIGN KEY (referee_medical_license_no)  REFERENCES doctor(medical_license_no)
      ON UPDATE CASCADE ON DELETE RESTRICT
);

/* EMPLOY (PrivateClinic ↔ Doctor) */
CREATE TABLE employ (
  medical_license_no VARCHAR(32)  NOT NULL,
  clinic_name        VARCHAR(120) NOT NULL,
  clinic_address     VARCHAR(255) NOT NULL,
  PRIMARY KEY (medical_license_no, clinic_name, clinic_address),
  CONSTRAINT fk_employ_doctor
    FOREIGN KEY (medical_license_no) REFERENCES doctor(medical_license_no)
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_employ_clinic
    FOREIGN KEY (clinic_name, clinic_address) REFERENCES private_clinic(name, address)
      ON UPDATE CASCADE ON DELETE CASCADE
);

/* WORKS IN (Hospital ↔ Doctor) */
CREATE TABLE works_in (
  medical_license_no VARCHAR(32) NOT NULL,
  code               VARCHAR(32) NOT NULL,
  PRIMARY KEY (medical_license_no, code),
  CONSTRAINT fk_works_in_doctor
    FOREIGN KEY (medical_license_no) REFERENCES doctor(medical_license_no)
      ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_works_in_hospital
    FOREIGN KEY (code) REFERENCES hospital(code)
      ON UPDATE CASCADE ON DELETE CASCADE
);

/* CONSULT (Citizen ↔ Doctor) */
CREATE TABLE consult (
  citizen_first_name  VARCHAR(60) NOT NULL,
  citizen_last_name   VARCHAR(60) NOT NULL,
  citizen_birthdate   DATE        NOT NULL,
  medical_license_no  VARCHAR(32) NOT NULL,
  PRIMARY KEY (citizen_first_name, citizen_last_name, citizen_birthdate, medical_license_no),
  CONSTRAINT fk_consult_citizen
    FOREIGN KEY (citizen_first_name, citizen_last_name, citizen_birthdate)
    REFERENCES citizen(first_name, last_name, birthdate)
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_consult_doctor
    FOREIGN KEY (medical_license_no) REFERENCES doctor(medical_license_no)
      ON UPDATE CASCADE ON DELETE RESTRICT
);

/* PRESCRIBES (Citizen ↔ Doctor) */
CREATE TABLE prescribes (
  citizen_first_name  VARCHAR(60) NOT NULL,
  citizen_last_name   VARCHAR(60) NOT NULL,
  citizen_birthdate   DATE        NOT NULL,
  medical_license_no  VARCHAR(32) NOT NULL,
  PRIMARY KEY (citizen_first_name, citizen_last_name, citizen_birthdate, medical_license_no),
  CONSTRAINT fk_prescribes_citizen
    FOREIGN KEY (citizen_first_name, citizen_last_name, citizen_birthdate)
    REFERENCES citizen(first_name, last_name, birthdate)
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_prescribes_doctor
    FOREIGN KEY (medical_license_no) REFERENCES doctor(medical_license_no)
      ON UPDATE CASCADE ON DELETE RESTRICT
);

/* HOSPITAL LOGS (Hospital ↔ Incident) */
CREATE TABLE hospital_logs (
  report_number BIGINT NOT NULL,
  report_date   DATE   NOT NULL,
  code          VARCHAR(32) NOT NULL,
  PRIMARY KEY (report_number, report_date, code),
  CONSTRAINT fk_hlog_incident
    FOREIGN KEY (report_number, report_date)
    REFERENCES incidents(report_number, report_date)
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_hlog_hospital
    FOREIGN KEY (code) REFERENCES hospital(code)
      ON UPDATE CASCADE ON DELETE CASCADE
);

/* FIRE DEPARTMENT LOGS (FireDepartment ↔ Incident) */
CREATE TABLE fire_logs (
  report_number BIGINT NOT NULL,
  report_date   DATE   NOT NULL,
  name          VARCHAR(120) NOT NULL,
  address       VARCHAR(255) NOT NULL,
  PRIMARY KEY (report_number, report_date, name, address),
  CONSTRAINT fk_flog_incident
    FOREIGN KEY (report_number, report_date)
    REFERENCES incidents(report_number, report_date)
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_flog_fd
    FOREIGN KEY (name, address) REFERENCES fire_department(name, address)
      ON UPDATE CASCADE ON DELETE CASCADE
);

/* POLICE LOGS (Police ↔ Incident) */
CREATE TABLE police_logs (
  report_number BIGINT NOT NULL,
  report_date   DATE   NOT NULL,
  name          VARCHAR(120) NOT NULL,
  address       VARCHAR(255) NOT NULL,
  PRIMARY KEY (report_number, report_date, name, address),
  CONSTRAINT fk_plog_incident
    FOREIGN KEY (report_number, report_date)
    REFERENCES incidents(report_number, report_date)
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_plog_police
    FOREIGN KEY (name, address) REFERENCES police(name, address)
      ON UPDATE CASCADE ON DELETE CASCADE
);
