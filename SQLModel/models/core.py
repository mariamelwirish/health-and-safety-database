from typing import Optional
from datetime import date
from sqlmodel import SQLModel, Field, ForeignKeyConstraint

class Citizen(SQLModel, table=True):
    first_name: str = Field(primary_key=True, max_length=60)
    last_name: str  = Field(primary_key=True, max_length=60)
    birthdate: date = Field(primary_key=True)
    address: Optional[str] = None
    access_nearest_hospital_clinic: Optional[str] = None
    no_of_calls_made: Optional[int] = None

class Doctor(SQLModel, table=True):
    medical_license_no: str = Field(primary_key=True, max_length=32)
    first_name: str
    last_name: str
    specialty: Optional[str] = None
    availability: Optional[str] = None
    consultation_cost: Optional[float] = None

class Hospital(SQLModel, table=True):
    code: str = Field(primary_key=True, max_length=32)
    name: str
    address: Optional[str] = None
    bed_capacity: Optional[int] = None
    has_emergency_department: Optional[bool] = None
    avg_wait_time: Optional[int] = None
    accreditation: Optional[str] = None
    coverage_area: Optional[str] = None
    doctor_count: Optional[int] = None
    staff_to_patient_ratio: Optional[float] = None

class PrivateClinic(SQLModel, table=True):
    __tablename__ = "private_clinic"
    name: str = Field(primary_key=True)
    address: str = Field(primary_key=True)
    specialty: Optional[str] = None
    phone: Optional[str] = None
    email: Optional[str] = None
    opening_hours: Optional[str] = None
    has_emergency: Optional[bool] = None
    doctor_count: Optional[int] = None
    referral_rate: Optional[float] = None

class Pharmacy(SQLModel, table=True):
    name: str = Field(primary_key=True)
    address: str = Field(primary_key=True)
    phone: Optional[str] = None
    email: Optional[str] = None
    opening_hours: Optional[str] = None
    emergency_availability: Optional[bool] = None
    services_offered: Optional[str] = None
    medicine_provided: Optional[str] = None
    pct_medicine_out_of_stock: Optional[float] = None

class FireDepartment(SQLModel, table=True):
    __tablename__ = "fire_department"
    name: str = Field(primary_key=True)
    address: str = Field(primary_key=True)
    phone: Optional[str] = None
    station_type: Optional[str] = None
    coverage_area: Optional[str] = None
    avg_response_time: Optional[int] = None
    no_of_functioning_fire_vehicles: Optional[int] = None
    water_supply: Optional[str] = None

class Police(SQLModel, table=True):
    name: str = Field(primary_key=True)
    address: str = Field(primary_key=True)
    station_type: Optional[str] = None
    coverage_area: Optional[str] = None
    officers_count: Optional[int] = None
    avg_response_time: Optional[int] = None
    incidents_handled_per_citizen_ratio: Optional[float] = None
    officer_to_population_ratio: Optional[float] = None

class Incidents(SQLModel, table=True):
    report_number: int = Field(primary_key=True)
    report_date: date = Field(primary_key=True)
    type: Optional[str] = None
    severity_level: Optional[int] = None
    resources_mobilized: Optional[str] = None
    location_accessibility: Optional[str] = None
    location: Optional[str] = None
    outcome: Optional[str] = None
    reported_by_first_name: Optional[str] = None
    reported_by_last_name: Optional[str] = None
    reported_by_birthdate: Optional[date] = None

    __table_args__ = (
        ForeignKeyConstraint(
            ["reported_by_first_name","reported_by_last_name","reported_by_birthdate"],
            ["citizen.first_name","citizen.last_name","citizen.birthdate"],
            onupdate="CASCADE", ondelete="SET NULL",
        ),
    )
