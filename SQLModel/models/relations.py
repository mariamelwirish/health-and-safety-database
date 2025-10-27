from sqlmodel import SQLModel, Field, ForeignKeyConstraint
from datetime import date
from typing import Optional

class Refers(SQLModel, table=True):
    referrer_medical_license_no: str = Field(primary_key=True, foreign_key="doctor.medical_license_no")
    referee_medical_license_no: str  = Field(primary_key=True, foreign_key="doctor.medical_license_no")

class Employ(SQLModel, table=True):
    medical_license_no: str = Field(primary_key=True, foreign_key="doctor.medical_license_no")
    clinic_name: str = Field(primary_key=True)
    clinic_address: str = Field(primary_key=True)
    __table_args__ = (
        ForeignKeyConstraint(["clinic_name","clinic_address"],
                             ["private_clinic.name","private_clinic.address"],
                             onupdate="CASCADE", ondelete="CASCADE"),
    )

class WorksIn(SQLModel, table=True):
    medical_license_no: str = Field(primary_key=True, foreign_key="doctor.medical_license_no")
    code: str = Field(primary_key=True, foreign_key="hospital.code")

class Consult(SQLModel, table=True):
    citizen_first_name: str = Field(primary_key=True)
    citizen_last_name: str = Field(primary_key=True)
    citizen_birthdate: date = Field(primary_key=True)
    medical_license_no: str = Field(primary_key=True, foreign_key="doctor.medical_license_no")
    __table_args__ = (
        ForeignKeyConstraint(["citizen_first_name","citizen_last_name","citizen_birthdate"],
                             ["citizen.first_name","citizen.last_name","citizen.birthdate"],
                             onupdate="CASCADE", ondelete="CASCADE"),
    )

class Prescribes(SQLModel, table=True):
    citizen_first_name: str = Field(primary_key=True)
    citizen_last_name: str = Field(primary_key=True)
    citizen_birthdate: date = Field(primary_key=True)
    medical_license_no: str = Field(primary_key=True, foreign_key="doctor.medical_license_no")
    __table_args__ = (
        ForeignKeyConstraint(["citizen_first_name","citizen_last_name","citizen_birthdate"],
                             ["citizen.first_name","citizen.last_name","citizen.birthdate"],
                             onupdate="CASCADE", ondelete="CASCADE"),
    )

class HospitalLogs(SQLModel, table=True):
    report_number: int = Field(primary_key=True)
    report_date: date  = Field(primary_key=True)
    code: str          = Field(primary_key=True, foreign_key="hospital.code")
    details: Optional[str] = None
    __table_args__ = (
        ForeignKeyConstraint(["report_number","report_date"],
                             ["incidents.report_number","incidents.report_date"],
                             onupdate="CASCADE", ondelete="CASCADE"),
    )

class FireLogs(SQLModel, table=True):
    report_number: int = Field(primary_key=True)
    report_date: date  = Field(primary_key=True)
    name: str          = Field(primary_key=True)
    address: str       = Field(primary_key=True)
    details: Optional[str] = None
    __table_args__ = (
        ForeignKeyConstraint(["report_number","report_date"],
                             ["incidents.report_number","incidents.report_date"],
                             onupdate="CASCADE", ondelete="CASCADE"),
        ForeignKeyConstraint(["name","address"],
                             ["fire_department.name","fire_department.address"],
                             onupdate="CASCADE", ondelete="CASCADE"),
    )

class PoliceLogs(SQLModel, table=True):
    report_number: int = Field(primary_key=True)
    report_date: date  = Field(primary_key=True)
    name: str          = Field(primary_key=True)
    address: str       = Field(primary_key=True)
    details: Optional[str] = None
    __table_args__ = (
        ForeignKeyConstraint(["report_number","report_date"],
                             ["incidents.report_number","incidents.report_date"],
                             onupdate="CASCADE", ondelete="CASCADE"),
        ForeignKeyConstraint(["name","address"],
                             ["police.name","police.address"],
                             onupdate="CASCADE", ondelete="CASCADE"),
    )
