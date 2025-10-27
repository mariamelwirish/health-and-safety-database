from sqlmodel import select
from .database import get_session
from .models.core import (
    Citizen,
    Doctor,
    Hospital,
    PrivateClinic,
    Pharmacy,
    FireDepartment,
    Police,
    Incidents,
)
from .models.relations import (
    Refers,
    Employ,
    WorksIn,
    Consult,
    Prescribes,
    HospitalLogs,
    FireLogs,
    PoliceLogs,
)

def doctors_per_citizen():
    with get_session() as s:
        rows = s.exec(
            select(Citizen.first_name, Citizen.last_name, Doctor.first_name, Doctor.last_name)
            .join(Consult, (Citizen.first_name == Consult.citizen_first_name) &
                           (Citizen.last_name == Consult.citizen_last_name) &
                           (Citizen.birthdate == Consult.citizen_birthdate))
            .join(Doctor, Doctor.medical_license_no == Consult.medical_license_no)
        ).all()
        return rows


# Generic "get all" functions for each table/model
def get_all_citizens():
    with get_session() as s:
        return s.exec(select(Citizen)).all()


def get_all_doctors():
    with get_session() as s:
        return s.exec(select(Doctor)).all()


def get_all_hospitals():
    with get_session() as s:
        return s.exec(select(Hospital)).all()


def get_all_private_clinics():
    with get_session() as s:
        return s.exec(select(PrivateClinic)).all()


def get_all_pharmacies():
    with get_session() as s:
        return s.exec(select(Pharmacy)).all()


def get_all_fire_departments():
    with get_session() as s:
        return s.exec(select(FireDepartment)).all()


def get_all_police_stations():
    with get_session() as s:
        return s.exec(select(Police)).all()


def get_all_incidents():
    with get_session() as s:
        return s.exec(select(Incidents)).all()


def get_all_refers():
    with get_session() as s:
        return s.exec(select(Refers)).all()


def get_all_employs():
    with get_session() as s:
        return s.exec(select(Employ)).all()


def get_all_worksin():
    with get_session() as s:
        return s.exec(select(WorksIn)).all()


def get_all_consults():
    with get_session() as s:
        return s.exec(select(Consult)).all()


def get_all_prescribes():
    with get_session() as s:
        return s.exec(select(Prescribes)).all()


def get_all_hospital_logs():
    with get_session() as s:
        return s.exec(select(HospitalLogs)).all()


def get_all_fire_logs():
    with get_session() as s:
        return s.exec(select(FireLogs)).all()


def get_all_police_logs():
    with get_session() as s:
        return s.exec(select(PoliceLogs)).all()


ALL_QUERIES = {
    "citizens": get_all_citizens,
    "doctors": get_all_doctors,
    "hospitals": get_all_hospitals,
    "private_clinics": get_all_private_clinics,
    "pharmacies": get_all_pharmacies,
    "fire_departments": get_all_fire_departments,
    "police": get_all_police_stations,
    "incidents": get_all_incidents,
    "refers": get_all_refers,
    "employs": get_all_employs,
    "works_in": get_all_worksin,
    "consults": get_all_consults,
    "prescribes": get_all_prescribes,
    "hospital_logs": get_all_hospital_logs,
    "fire_logs": get_all_fire_logs,
    "police_logs": get_all_police_logs,
}

