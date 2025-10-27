from datetime import date
from sqlmodel import Session
from .database import engine
from .models.core import (
    Citizen, Doctor, Hospital, PrivateClinic, Pharmacy,
    FireDepartment, Police, Incidents
)
from .models.relations import (
    Refers, Employ, WorksIn, Consult, Prescribes,
    HospitalLogs, FireLogs, PoliceLogs
)


def insert() -> None:
    with Session(engine) as session:

        # CORE ENTITIES
        citizens = [
            Citizen(first_name="Alice", last_name="Smith", birthdate=date(1999, 5, 10),
                    address="Hamra, Beirut", access_nearest_hospital_clinic="AUBMC / Hamra Clinic", no_of_calls_made=3),
            Citizen(first_name="Bob", last_name="Nader", birthdate=date(2001, 11, 2),
                    address="Achrafieh, Beirut", access_nearest_hospital_clinic="RHUH / Downtown Clinic", no_of_calls_made=1),
            Citizen(first_name="Carol", last_name="Aziz", birthdate=date(1995, 3, 20),
                    address="Verdun, Beirut", access_nearest_hospital_clinic="AUBMC / Hamra Clinic", no_of_calls_made=0),
        ]

        doctors = [
            Doctor(medical_license_no="D1001", first_name="John", last_name="Kareem",
                   specialty="Cardiology", availability="Mon-Thu 9-3", consultation_cost=75.00),
            Doctor(medical_license_no="D1002", first_name="Layla", last_name="Haddad",
                   specialty="Emergency Medicine", availability="Daily 8-8", consultation_cost=60.00),
            Doctor(medical_license_no="D1003", first_name="Rami", last_name="Saab",
                   specialty="General Practice", availability="Mon-Fri 10-4", consultation_cost=40.00),
        ]

        hospitals = [
            Hospital(code="H001", name="AUBMC", address="Hamra, Beirut",
                     bed_capacity=600, has_emergency_department=True,
                     avg_wait_time=35, accreditation="JCI", coverage_area="Beirut",
                     doctor_count=350, staff_to_patient_ratio=0.12),
            Hospital(code="H002", name="RHUH", address="Bir Hasan, Beirut",
                     bed_capacity=450, has_emergency_department=True,
                     avg_wait_time=45, accreditation="MoH", coverage_area="Beirut",
                     doctor_count=280, staff_to_patient_ratio=0.14),
        ]

        clinics = [
            PrivateClinic(name="Hamra Clinic", address="Hamra, Beirut",
                          specialty="Multi-specialty", phone="+961-1-111111",
                          email="info@hamraclinic.lb", opening_hours="Mon-Sat 9-6",
                          has_emergency=False, doctor_count=12, referral_rate=0.15),
            PrivateClinic(name="Downtown Clinic", address="Downtown, Beirut",
                          specialty="General Practice", phone="+961-1-222222",
                          email="hello@downtownclinic.lb", opening_hours="Mon-Fri 9-5",
                          has_emergency=False, doctor_count=6, referral_rate=0.08),
        ]

        pharmacies = [
            Pharmacy(name="WellCare Pharmacy", address="Hamra, Beirut",
                     phone="+961-1-333333", email="care@wellcare.lb",
                     opening_hours="Daily 8-11", emergency_availability=True,
                     services_offered="Vaccines; BP check",
                     medicine_provided="Rx & OTC", pct_medicine_out_of_stock=5.00),
            Pharmacy(name="CityMed Pharmacy", address="Achrafieh, Beirut",
                     phone="+961-1-444444", email="hello@citymed.lb",
                     opening_hours="Daily 8-10", emergency_availability=False,
                     services_offered="BP check",
                     medicine_provided="Rx & OTC", pct_medicine_out_of_stock=8.50),
        ]

        fire_departments = [
            FireDepartment(name="FD West", address="Jnah, Beirut",
                           phone="125", station_type="Urban", coverage_area="West Beirut",
                           avg_response_time=8, no_of_functioning_fire_vehicles=6,
                           water_supply="Adequate"),
            FireDepartment(name="FD East", address="Achrafieh, Beirut",
                           phone="125", station_type="Urban", coverage_area="East Beirut",
                           avg_response_time=9, no_of_functioning_fire_vehicles=5,
                           water_supply="Adequate"),
        ]

        police_stations = [
            Police(name="Beirut Central", address="Clemenceau, Beirut",
                   station_type="Urban", coverage_area="Beirut",
                   officers_count=520, avg_response_time=11,
                   incidents_handled_per_citizen_ratio=0.0025,
                   officer_to_population_ratio=0.0018),
            Police(name="Ashrafieh Precinct", address="Achrafieh, Beirut",
                   station_type="Urban", coverage_area="Achrafieh",
                   officers_count=210, avg_response_time=13,
                   incidents_handled_per_citizen_ratio=0.0031,
                   officer_to_population_ratio=0.0022),
        ]

        incidents = [
            Incidents(report_number=10001, report_date=date(2025, 10, 1),
                      type="Medical Emergency", severity_level=3,
                      resources_mobilized="Ambulance; ER Team",
                      location_accessibility="Easy", location="Hamra Main St.",
                      outcome="Stabilized",
                      reported_by_first_name="Alice",
                      reported_by_last_name="Smith",
                      reported_by_birthdate=date(1999, 5, 10)),
            Incidents(report_number=10002, report_date=date(2025, 10, 2),
                      type="Traffic Accident", severity_level=2,
                      resources_mobilized="Ambulance; Police; Fire",
                      location_accessibility="Moderate", location="Ring Road Exit 3",
                      outcome="Resolved",
                      reported_by_first_name="Bob",
                      reported_by_last_name="Nader",
                      reported_by_birthdate=date(2001, 11, 2)),
        ]

        # RELATIONSHIPS
        refers = [
            Refers(referrer_medical_license_no="D1001", referee_medical_license_no="D1002"),
            Refers(referrer_medical_license_no="D1003", referee_medical_license_no="D1001"),
        ]

        employ = [
            Employ(medical_license_no="D1001", clinic_name="Hamra Clinic", clinic_address="Hamra, Beirut"),
            Employ(medical_license_no="D1002", clinic_name="Downtown Clinic", clinic_address="Downtown, Beirut"),
            Employ(medical_license_no="D1003", clinic_name="Hamra Clinic", clinic_address="Hamra, Beirut"),
        ]

        works_in = [
            WorksIn(medical_license_no="D1001", code="H001"),
            WorksIn(medical_license_no="D1002", code="H002"),
            WorksIn(medical_license_no="D1003", code="H001"),
        ]

        consult = [
            Consult(citizen_first_name="Alice", citizen_last_name="Smith",
                    citizen_birthdate=date(1999, 5, 10), medical_license_no="D1001"),
            Consult(citizen_first_name="Alice", citizen_last_name="Smith",
                    citizen_birthdate=date(1999, 5, 10), medical_license_no="D1003"),
            Consult(citizen_first_name="Bob", citizen_last_name="Nader",
                    citizen_birthdate=date(2001, 11, 2), medical_license_no="D1002"),
        ]

        prescribes = [
            Prescribes(citizen_first_name="Alice", citizen_last_name="Smith",
                       citizen_birthdate=date(1999, 5, 10), medical_license_no="D1001"),
            Prescribes(citizen_first_name="Bob", citizen_last_name="Nader",
                       citizen_birthdate=date(2001, 11, 2), medical_license_no="D1002"),
        ]

        hospital_logs = [
            HospitalLogs(report_number=10001, report_date=date(2025, 10, 1),
                         code="H001", details="ER triage & stabilization"),
            HospitalLogs(report_number=10002, report_date=date(2025, 10, 2),
                         code="H002", details="ER evaluation"),
        ]

        fire_logs = [
            FireLogs(report_number=10002, report_date=date(2025, 10, 2),
                     name="FD East", address="Achrafieh, Beirut",
                     details="Extrication & scene safety"),
            FireLogs(report_number=10002, report_date=date(2025, 10, 2),
                     name="FD West", address="Jnah, Beirut",
                     details="Support unit"),
        ]

        police_logs = [
            PoliceLogs(report_number=10002, report_date=date(2025, 10, 2),
                       name="Beirut Central", address="Clemenceau, Beirut",
                       details="Traffic management & report"),
        ]

        # ADD + COMMIT
        all_objects = (
            citizens + doctors + hospitals + clinics + pharmacies +
            fire_departments + police_stations + incidents +
            refers + employ + works_in + consult + prescribes +
            hospital_logs + fire_logs + police_logs
        )

        session.add_all(all_objects)
        session.commit()
        print("Database seeded successfully.")
