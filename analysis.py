"""
================================================================
For each query:
  - Loads CSV output
  - Cleans the data
  - Performs analysis
  - Generates charts saved into /charts/
================================================================
"""

# IMPORTS & DIRECTORY SETUP
import pandas as pd
import matplotlib.pyplot as plt
import os

os.makedirs("charts", exist_ok=True)

# SECTION 1 — LOAD ALL 10 CSV FILES
q1  = pd.read_csv("MySQL/CSV/q1.csv")
q2  = pd.read_csv("MySQL/CSV/q2.csv")
q3  = pd.read_csv("MySQL/CSV/q3.csv")
q4  = pd.read_csv("MySQL/CSV/q4.csv")
q5  = pd.read_csv("MySQL/CSV/q5.csv")
q6  = pd.read_csv("MySQL/CSV/q6.csv")
q7  = pd.read_csv("MySQL/CSV/q7.csv")
q8  = pd.read_csv("MySQL/CSV/q8.csv")
q9  = pd.read_csv("MySQL/CSV/q9.csv")
q10 = pd.read_csv("MySQL/CSV/q10.csv")

dfs = [q1,q2,q3,q4,q5,q6,q7,q8,q9,q10]

# SECTION 2 — GENERAL DATA CLEANING
"""
Cleaning includes:
  - Fill missing values with "Unknown"
  - Convert numeric-looking columns to numbers
  - Strip whitespace from text fields
"""

for df in dfs:
    df.fillna("Unknown", inplace=True)

for df in dfs:
    for col in df.columns:
        df[col] = pd.to_numeric(df[col], errors="ignore")

for df in dfs:
    for col in df.columns:
        if df[col].dtype == object:
            df[col] = df[col].astype(str).str.strip()


# SECTION 3 — QUERY-BY-QUERY ANALYSIS
#  QUERY 1 
"""
Q1: High Severity Incidents per Region
Columns:
    region, total_incidents, high_severity_count, high_severity_percentage
"""
print("\n---- Q1 ANALYSIS ----")
print(q1)

# Visualization:
#   This chart compares how dangerous each region is by showing the percentage of incidents that are high severity.
plt.figure(figsize=(10,5))
plt.bar(q1['region'], q1['high_severity_percentage'], color='salmon')
plt.title("Q1 — High Severity Percentage per Region")
plt.xlabel("Region")
plt.ylabel("High Severity %")
plt.xticks(rotation=45)
plt.tight_layout()
plt.savefig("charts/Q1_high_severity_percentage.png")
plt.close()



# QUERY 2
"""
Q2: Agency Response Deficit
Columns:
    region, total_incidents, total_agency_responses, response_deficit_gap
"""
print("\n---- Q2 ANALYSIS ----")
print(q2)

# Visualization:
#   This chart reveals whether agencies responded enough. 
#       - Positive gap = not enough responses (underserved)
#       - Negative gap = over-response (overserved)
#       - Zero = perfect response.
plt.figure(figsize=(10,5))
plt.bar(q2['region'], q2['response_deficit_gap'], color='skyblue')
plt.title("Q2 — Agency Response Deficit Gap per Region")
plt.xlabel("Region")
plt.ylabel("Deficit Gap")
plt.xticks(rotation=45)
plt.tight_layout()
plt.savefig("charts/Q2_deficit_gap.png")
plt.close()



# QUERY 3
"""
Q3: Hospital Load + Average Wait Time
Columns:
    hospital_name, hospital_region, incident_count, avg_wait_time
"""
print("\n---- Q3 ANALYSIS ----")
print(q3)

# Visualization 1:
#   This chart shows how many incidents each hospital handled.
plt.figure(figsize=(12,5))
plt.bar(q3['hospital_name'], q3['incident_count'], color='steelblue')
plt.title("Q3 — Incident Count per Hospital")
plt.xlabel("Hospital")
plt.ylabel("Incident Count")
plt.xticks(rotation=60, ha='right')
plt.tight_layout()
plt.savefig("charts/Q3_incident_count.png")
plt.close()

# Visualization 2:
#   This chart compares average patient waiting time across hospitals.
plt.figure(figsize=(12,5))
plt.bar(q3['hospital_name'], q3['avg_wait_time'], color='darkred')
plt.title("Q3 — Average Waiting Time per Hospital")
plt.xlabel("Hospital")
plt.ylabel("Average Wait Time (minutes)")
plt.xticks(rotation=60, ha='right')
plt.tight_layout()
plt.savefig("charts/Q3_avg_wait_time.png")
plt.close()



# QUERY 4
"""
Q4: Citizens per Resource
Columns:
    region, citizens, total_resources, citizens_per_resource
"""
print("\n---- Q4 ANALYSIS ----")
print(q4)

# Visualization:
#   This chart shows how many citizens depend on each resource.
#       - Higher = more load on that region's services.
plt.figure(figsize=(10,5))
plt.bar(q4['region'], q4['citizens_per_resource'], color='purple')
plt.title("Q4 — Citizens per Resource per Region")
plt.xlabel("Region")
plt.ylabel("Citizens per Resource")
plt.xticks(rotation=45)
plt.tight_layout()
plt.savefig("charts/Q4_citizens_per_resource.png")
plt.close()



# QUERY 5
"""
Q5: Facilities and the Regions They Serve
Columns:
    facility_name, facility_type, regions_served
"""
print("\n---- Q5 ANALYSIS ----")
print(q5)

# Visualization:
#   This chart shows which facilities serve the most regions. Useful for identifying distributed service centers.
plt.figure(figsize=(10,5))
plt.bar(q5['facility_name'], q5['regions_served'], color='green')
plt.title("Q5 — Regions Served per Facility")
plt.xlabel("Facility")
plt.ylabel("Regions Served")
plt.xticks(rotation=60, ha='right')
plt.tight_layout()
plt.savefig("charts/Q5_regions_served.png")
plt.close()



# QUERY 6
"""
Q6: Multi-Agency Incident Percentage
Columns:
    region, total_incidents, multi_agency_incidents, multi_agency_percentage
"""
print("\n---- Q6 ANALYSIS ----")
print(q6)

# Visualization:
#   How often incidents require multiple agencies (police+fire+hospital).
plt.figure(figsize=(10,5))
plt.bar(q6['region'], q6['multi_agency_percentage'], color='red')
plt.title("Q6 — Multi-Agency Incident Percentage per Region")
plt.xlabel("Region")
plt.ylabel("Multi-Agency %")
plt.xticks(rotation=45)
plt.tight_layout()
plt.savefig("charts/Q6_multi_agency.png")
plt.close()



# QUERY 7
"""
Q7: Incidents per Hospital Bed Ratio
Columns:
    region, incident_count, total_beds, incidents_per_bed_ratio
"""
print("\n---- Q7 ANALYSIS ----")
print(q7)

# Visualization:
#   This chart highlights how overloaded each region's healthcare system is.
plt.figure(figsize=(10,5))
plt.bar(q7['region'], q7['incidents_per_bed_ratio'], color='brown')
plt.title("Q7 — Incidents per Hospital Bed Ratio")
plt.xlabel("Region")
plt.ylabel("Incidents per Bed")
plt.xticks(rotation=45)
plt.tight_layout()
plt.savefig("charts/Q7_incidents_per_bed.png")
plt.close()



# QUERY 8
"""
Q8: Incident Type Frequency
Columns:
    incident_type, occurrence_count
"""
print("\n---- Q8 ANALYSIS ----")
print(q8)

# Visualization:
#   Which types of incidents occur most frequently citywide.
plt.figure(figsize=(10,5))
plt.bar(q8['incident_type'], q8['occurrence_count'], color='gray')
plt.title("Q8 — Incident Type Frequency")
plt.xlabel("Incident Type")
plt.ylabel("Occurrences")
plt.xticks(rotation=45)
plt.tight_layout()
plt.savefig("charts/Q8_incident_types.png")
plt.close()



# QUERY 9
"""
Q9: Citizen Difficulty Levels
Columns:
    first_name, last_name, birthdate,
    access_nearest_hospital_clinic,
    no_of_calls_made,
    incidents_reported,
    difficult_incidents,
    difficult_incidents_percentage
"""
print("\n---- Q9 ANALYSIS ----")
print(q9)




# QUERY 10
"""
Q10: Cross-Region Facility Visits
Columns:
    facility_name, facility_type, cross_region_visits
"""
print("\n---- Q10 ANALYSIS ----")
print(q10)

# Visualization:
#   How often facilities receive people from outside their own region.
plt.figure(figsize=(10,5))
plt.bar(q10['facility_name'], q10['cross_region_visits'], color='navy')
plt.title("Q10 — Cross-Region Visits per Facility")
plt.xlabel("Facility")
plt.ylabel("Cross-Region Visits")
plt.xticks(rotation=60, ha='right')
plt.tight_layout()
plt.savefig("charts/Q10_cross_region_visits.png")
plt.close()

print("\nAll analyses complete — charts saved in /charts/")
