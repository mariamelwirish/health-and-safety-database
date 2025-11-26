/* ============================================================
   COMPLEX QUERY #1
   REAL-WORLD QUESTION:
   "Which regions experience the highest proportion of high-severity incidents?"

   WHY THIS MATTERS:
   City planners need to identify dangerous areas where 
   life-threatening incidents (severity 4–5) are concentrated.
   This helps with:
     - resource allocation,
     - infrastructure improvements,
     - road safety strategies,
     - civil defense deployment.

   WHAT THIS QUERY DOES:
   1. Extracts the region from each incident's location.
   2. Counts how many incidents occurred in each region.
   3. Counts how many were HIGH severity (>= 4).
   4. Calculates the percentage of high-severity incidents.
   5. Sorts regions from most dangerous to least.

   RESULT:
   Shows Lebanese regions ranked by risk level.
   ============================================================ */

SELECT 
    region,
    COUNT(*) AS total_incidents,
    SUM(CASE WHEN severity_level >= 4 THEN 1 ELSE 0 END) AS high_severity_count,
    ROUND(
        SUM(CASE WHEN severity_level >= 4 THEN 1 ELSE 0 END) / COUNT(*) * 100,
        2
    ) AS high_severity_percentage
FROM (
    -- Extract region name based on location text patterns
    SELECT
        severity_level,
        CASE
            WHEN location LIKE '%Beirut%' THEN 'Beirut'
            WHEN location LIKE '%Tripoli%' THEN 'Tripoli'
            WHEN location LIKE '%Saida%' THEN 'Saida'
            WHEN location LIKE '%Zahle%' THEN 'Zahle'
            WHEN location LIKE '%Tyre%' THEN 'Tyre'
            WHEN location LIKE '%Jounieh%' THEN 'Jounieh'
            WHEN location LIKE '%Baalbek%' THEN 'Baalbek'
            WHEN location LIKE '%Hazmieh%' THEN 'Hazmieh'
            ELSE 'Other'
        END AS region
    FROM incidents
) AS region_incidents
GROUP BY region
ORDER BY high_severity_percentage DESC;

/* ============================================================
   COMPLEX QUERY #2
   REAL-WORLD QUESTION:
   "Which areas of Lebanon are underserved by emergency
    response agencies?"

   WHY THIS MATTERS:
   City planners must identify regions where emergency
   response (hospitals + fire + police) is lower than the
   number of incidents reported. These areas face higher
   risk, slower rescue times, and need more resources.

   WHAT THIS QUERY DOES:
   1. Extracts regions from incident locations.
   2. Counts total incidents per region.
   3. Counts all emergency responses (hospital, fire, police).
   4. Computes the "underserved gap" = incidents - responses.
   5. Shows regions with the largest emergency deficits.

   OUTPUT:
   Regions sorted by highest underserved gap.
   ============================================================ */

WITH incident_regions AS (
    SELECT
        CASE
            WHEN location LIKE '%Beirut%' OR location LIKE '%Hamra%' OR location LIKE '%Clemenceau%' OR location LIKE '%Achrafieh%' OR location LIKE '%Hazmieh%' THEN 'Beirut Area'
            WHEN location LIKE '%Tripoli%' THEN 'Tripoli'
            WHEN location LIKE '%Saida%' THEN 'Saida'
            WHEN location LIKE '%Zahle%' OR location LIKE '%Baalbek%' THEN 'Bekaa'
            WHEN location LIKE '%Tyre%' THEN 'Tyre'
            WHEN location LIKE '%Jounieh%' THEN 'Jounieh'
            ELSE 'Other'
        END AS region,
        report_number,
        report_date
    FROM incidents
),

total_incidents AS (
    SELECT region, COUNT(DISTINCT report_number) AS total_incidents
    FROM incident_regions
    GROUP BY region
),

total_responses AS (
    SELECT region, COUNT(*) AS total_responses
    FROM (
        SELECT ir.region, hl.report_number FROM hospital_logs hl JOIN incident_regions ir ON hl.report_number = ir.report_number AND hl.report_date = ir.report_date
        UNION ALL
        SELECT ir.region, fl.report_number FROM fire_logs fl JOIN incident_regions ir ON fl.report_number = ir.report_number AND fl.report_date = ir.report_date
        UNION ALL
        SELECT ir.region, pl.report_number FROM police_logs pl JOIN incident_regions ir ON pl.report_number = ir.report_number AND pl.report_date = ir.report_date
    ) AS all_logs
    GROUP BY region
)

SELECT
    ti.region,
    ti.total_incidents,
    COALESCE(tr.total_responses, 0) AS total_agency_responses,
    (ti.total_incidents - COALESCE(tr.total_responses, 0)) AS response_deficit_gap
FROM total_incidents ti
LEFT JOIN total_responses tr ON ti.region = tr.region
ORDER BY response_deficit_gap DESC;

/* ============================================================
   COMPLEX QUERY #3
   REAL-WORLD QUESTION:
   "Which hospitals are facing the longest wait times in areas
    with many incidents?"

   WHY THIS MATTERS:
   City planners need to identify which hospitals are under the
   greatest pressure by combining:
      - incident frequency in their service region
      - hospital wait times
   This shows hospitals that may require:
      - more resources,
      - more staff,
      - expanded emergency capacity.

   WHAT THIS QUERY DOES:
   1. Groups incidents by region.
   2. Counts incidents per region (incident load).
   3. Associates each hospital with its region based on address.
   4. Joins incident load with hospital wait times.
   5. Ranks hospitals by highest incident load + highest wait time.

   OUTPUT:
   A prioritized list of hospitals under the most strain.
   ============================================================ */

WITH incident_regions AS (
    SELECT
        CASE
            WHEN location LIKE '%Beirut%' 
              OR location LIKE '%Hamra%' 
              OR location LIKE '%Clemenceau%' 
              OR location LIKE '%Achrafieh%'
              OR location LIKE '%Hazmieh%'
            THEN 'Beirut Area'

            WHEN location LIKE '%Tripoli%' THEN 'Tripoli'
            WHEN location LIKE '%Saida%' THEN 'Saida'
            WHEN location LIKE '%Zahle%' OR location LIKE '%Baalbek%' THEN 'Bekaa'
            WHEN location LIKE '%Tyre%' THEN 'Tyre'
            WHEN location LIKE '%Jounieh%' THEN 'Jounieh'
            ELSE 'Other'
        END AS region
    FROM incidents
),

incident_load AS (
    SELECT region, COUNT(*) AS incident_count
    FROM incident_regions
    GROUP BY region
),

hospital_regions AS (
    SELECT 
        h.code,
        h.name,
        h.avg_wait_time,
        CASE
            WHEN h.address LIKE '%Beirut%' 
              OR h.address LIKE '%Hamra%' 
              OR h.address LIKE '%Clemenceau%' 
              OR h.address LIKE '%Achrafieh%'
              OR h.address LIKE '%Hazmieh%'
            THEN 'Beirut Area'

            WHEN h.address LIKE '%Tripoli%' THEN 'Tripoli'
            WHEN h.address LIKE '%Saida%' THEN 'Saida'
            WHEN h.address LIKE '%Zahle%' OR h.address LIKE '%Baalbek%' THEN 'Bekaa'
            WHEN h.address LIKE '%Tyre%' THEN 'Tyre'
            WHEN h.address LIKE '%Jounieh%' THEN 'Jounieh'
            ELSE 'Other'
        END AS region
    FROM hospital h
)

SELECT
    hr.name AS hospital_name,
    hr.region AS hospital_region,
    il.incident_count,
    hr.avg_wait_time
FROM hospital_regions hr
LEFT JOIN incident_load il ON hr.region = il.region
ORDER BY il.incident_count DESC, hr.avg_wait_time DESC;

/* ============================================================
   COMPLEX QUERY #4
   REAL-WORLD QUESTION:
   "Does population density (proxied by citizen count) align
    with emergency resources?"

   WHY THIS MATTERS:
   City planners need to understand whether regions with many
   residents have enough emergency resources (hospitals, fire
   stations, police stations). Regions with high population and
   low emergency coverage pose serious safety risks.

   WHAT THIS QUERY DOES:
   1. Groups citizens into regions (population proxy).
   2. Classifies hospitals, fire departments, and police stations
      by region.
   3. Counts population vs emergency assets per region.
   4. Computes citizens_per_resource ratio.
   5. Ranks regions from worst (underserved) to best.

   OUTPUT:
   Regions with too many people and too few resources.
   ============================================================ */

-- 1. Map citizens to regions
WITH citizen_regions AS (
    SELECT
        CASE
            WHEN address LIKE '%Beirut%'
              OR address LIKE '%Hamra%'
              OR address LIKE '%Achrafieh%'
              OR address LIKE '%Clemenceau%'
              OR address LIKE '%Hazmieh%'
            THEN 'Beirut Area'

            WHEN address LIKE '%Tripoli%' THEN 'Tripoli'
            WHEN address LIKE '%Saida%' THEN 'Saida'
            WHEN address LIKE '%Zahle%' OR address LIKE '%Baalbek%' THEN 'Bekaa'
            WHEN address LIKE '%Tyre%' THEN 'Tyre'
            WHEN address LIKE '%Jounieh%' THEN 'Jounieh'
            ELSE 'Other'
        END AS region
    FROM citizen
),

citizen_count AS (
    SELECT region, COUNT(*) AS citizens
    FROM citizen_regions
    GROUP BY region
),

-- 2. Map hospitals, fire stations, and police stations to regions
hospital_regions AS (
    SELECT
        CASE
            WHEN address LIKE '%Beirut%'
              OR address LIKE '%Hamra%' 
              OR address LIKE '%Achrafieh%'
              OR address LIKE '%Clemenceau%'
              OR address LIKE '%Hazmieh%'
            THEN 'Beirut Area'

            WHEN address LIKE '%Tripoli%' THEN 'Tripoli'
            WHEN address LIKE '%Saida%' THEN 'Saida'
            WHEN address LIKE '%Zahle%' OR address LIKE '%Baalbek%' THEN 'Bekaa'
            WHEN address LIKE '%Tyre%' THEN 'Tyre'
            WHEN address LIKE '%Jounieh%' THEN 'Jounieh'
            ELSE 'Other'
        END AS region
    FROM hospital
),

fire_regions AS (
    SELECT
        CASE
            WHEN address LIKE '%Beirut%' 
              OR address LIKE '%Hamra%'
              OR address LIKE '%Achrafieh%'
              OR address LIKE '%Clemenceau%'
              OR address LIKE '%Hazmieh%'
            THEN 'Beirut Area'
            WHEN address LIKE '%Tripoli%' THEN 'Tripoli'
            WHEN address LIKE '%Saida%' THEN 'Saida'
            WHEN address LIKE '%Zahle%' OR address LIKE '%Baalbek%' THEN 'Bekaa'
            WHEN address LIKE '%Tyre%' THEN 'Tyre'
            WHEN address LIKE '%Jounieh%' THEN 'Jounieh'
            ELSE 'Other'
        END AS region
    FROM fire_department
),

police_regions AS (
    SELECT
        CASE
            WHEN address LIKE '%Beirut%' 
              OR address LIKE '%Hamra%' 
              OR address LIKE '%Achrafieh%'
              OR address LIKE '%Clemenceau%'
              OR address LIKE '%Hazmieh%'
            THEN 'Beirut Area'
            WHEN address LIKE '%Tripoli%' THEN 'Tripoli'
            WHEN address LIKE '%Saida%' THEN 'Saida'
            WHEN address LIKE '%Zahle%' OR address LIKE '%Baalbek%' THEN 'Bekaa'
            WHEN address LIKE '%Tyre%' THEN 'Tyre'
            WHEN address LIKE '%Jounieh%' THEN 'Jounieh'
            ELSE 'Other'
        END AS region
    FROM police
),

-- 3. Count resources per region
resource_count AS (
    SELECT
        region,
        COUNT(*) AS total_resources
    FROM (
        SELECT region FROM hospital_regions
        UNION ALL
        SELECT region FROM fire_regions
        UNION ALL
        SELECT region FROM police_regions
    ) AS combined
    GROUP BY region
)

-- 4. Combine population vs resources
SELECT
    cc.region,
    cc.citizens,
    rc.total_resources,
    ROUND(cc.citizens / rc.total_resources, 2) AS citizens_per_resource
FROM citizen_count cc
JOIN resource_count rc ON cc.region = rc.region
ORDER BY citizens_per_resource DESC;


/* ============================================================
   COMPLEX QUERY #5
   REAL-WORLD QUESTION:
   "Which clinics or hospitals serve the widest geographical area?"

   WHY THIS MATTERS:
   Some medical facilities act as regional hubs, attracting
   patients from multiple different regions. This indicates:
     - patient travel patterns,
     - potential overburdening of major hospitals/clinics,
     - regional healthcare imbalance,
     - need for expansion or new local clinics.

   WHAT THIS QUERY DOES:
   1. Extracts region of each citizen based on citizen.address.
   2. Extracts region of each hospital or clinic based on address.
   3. Connects citizens → doctors (consult).
   4. Connects doctors → hospitals (works_in) and → clinics (employ).
   5. Counts how many DISTINCT citizen regions each facility serves.
   6. Ranks facilities from widest geographic reach to smallest.

   OUTPUT:
   A list of hospitals and clinics ranked by how many regions
   their patients come from.
   ============================================================ */


-- 1. Map CITIZENS to regions

WITH citizen_regions AS (
    SELECT
        c.first_name,
        c.last_name,
        c.birthdate,
        CASE
            WHEN c.address LIKE '%Beirut%' 
              OR c.address LIKE '%Hamra%' 
              OR c.address LIKE '%Achrafieh%' 
              OR c.address LIKE '%Clemenceau%'
              OR c.address LIKE '%Hazmieh%'
            THEN 'Beirut Area'

            WHEN c.address LIKE '%Tripoli%' THEN 'Tripoli'
            WHEN c.address LIKE '%Saida%' THEN 'Saida'
            WHEN c.address LIKE '%Zahle%' OR c.address LIKE '%Baalbek%' THEN 'Bekaa'
            WHEN c.address LIKE '%Tyre%' THEN 'Tyre'
            WHEN c.address LIKE '%Jounieh%' THEN 'Jounieh'
            ELSE 'Other'
        END AS citizen_region
    FROM citizen c
),

-- 2. Map HOSPITALS to regions
hospital_regions AS (
    SELECT
        h.code AS facility_id,
        h.name AS facility_name,
        'Hospital' AS facility_type,
        CASE
            WHEN h.address LIKE '%Beirut%'
              OR h.address LIKE '%Hamra%' 
              OR h.address LIKE '%Achrafieh%' 
              OR h.address LIKE '%Clemenceau%'
              OR h.address LIKE '%Hazmieh%'
            THEN 'Beirut Area'

            WHEN h.address LIKE '%Tripoli%' THEN 'Tripoli'
            WHEN h.address LIKE '%Saida%' THEN 'Saida'
            WHEN h.address LIKE '%Zahle%' OR h.address LIKE '%Baalbek%' THEN 'Bekaa'
            WHEN h.address LIKE '%Tyre%' THEN 'Tyre'
            WHEN h.address LIKE '%Jounieh%' THEN 'Jounieh'
            ELSE 'Other'
        END AS facility_region
    FROM hospital h
),

-- 3. Map CLINICS to regions
clinic_regions AS (
    SELECT
        CONCAT(pc.name, ' | ', pc.address) AS facility_id,
        pc.name AS facility_name,
        'Clinic' AS facility_type,
        CASE
            WHEN pc.address LIKE '%Beirut%'
              OR pc.address LIKE '%Hamra%' 
              OR pc.address LIKE '%Achrafieh%' 
              OR pc.address LIKE '%Clemenceau%'
              OR pc.address LIKE '%Hazmieh%'
            THEN 'Beirut Area'

            WHEN pc.address LIKE '%Tripoli%' THEN 'Tripoli'
            WHEN pc.address LIKE '%Saida%' THEN 'Saida'
            WHEN pc.address LIKE '%Zahle%' OR pc.address LIKE '%Baalbek%' THEN 'Bekaa'
            WHEN pc.address LIKE '%Tyre%' THEN 'Tyre'
            WHEN pc.address LIKE '%Jounieh%' THEN 'Jounieh'
            ELSE 'Other'
        END AS facility_region
    FROM private_clinic pc
),

-- 4. Combine all facility regions
all_facilities AS (
    SELECT * FROM hospital_regions
    UNION ALL
    SELECT * FROM clinic_regions
),

-- 5. Connect citizens → doctors → hospitals/clinics
facility_patient_regions AS (
    SELECT
        f.facility_name,
        f.facility_type,
        f.facility_region,
        cr.citizen_region
    FROM consult co
    JOIN citizen_regions cr
      ON cr.first_name = co.citizen_first_name
     AND cr.last_name  = co.citizen_last_name
     AND cr.birthdate  = co.citizen_birthdate
    JOIN all_facilities f
      ON (
            -- hospital: join via works_in
            (f.facility_type = 'Hospital' AND f.facility_id = (
                SELECT w.code 
                FROM works_in w 
                WHERE w.medical_license_no = co.medical_license_no
                LIMIT 1
            ))
         OR
            -- clinic: join via employ
            (f.facility_type = 'Clinic' AND f.facility_id = (
                SELECT CONCAT(e.clinic_name, ' | ', e.clinic_address)
                FROM employ e
                WHERE e.medical_license_no = co.medical_license_no
                LIMIT 1
            ))
      )
)

-- 6. Count how many UNIQUE citizen regions each facility serves
SELECT
    facility_name,
    facility_type,
    COUNT(DISTINCT citizen_region) AS regions_served
FROM facility_patient_regions
GROUP BY facility_name, facility_type
ORDER BY regions_served DESC, facility_name ASC;

/* ============================================================
   COMPLEX QUERY #6
   REAL-WORLD QUESTION:
   "Are there regions where multiple agencies frequently respond
    to the same incident?"

   WHY THIS MATTERS:
   City planners and emergency coordinators need to know which
   regions generate incidents that are so complex they require
   multiple agencies (hospital, fire, police) at once.
   These hotspots:
     - increase operational complexity,
     - stress coordination between agencies,
     - indicate deeper infrastructure or safety problems.

   WHAT THIS QUERY DOES:
   1. Assigns each incident to a region based on its location.
   2. For each incident, checks whether:
        - hospital_logs exists (hospital involved),
        - fire_logs exists (fire dept involved),
        - police_logs exists (police involved).
   3. Counts how many distinct agencies respond per incident.
   4. For each region, computes:
        - total incidents,
        - how many incidents had 2+ agencies,
        - percentage of multi-agency incidents.
   5. Sorts regions by the highest percentage of multi-agency
      incidents.

   RESULT:
   Shows which regions generate the most complex emergencies
   requiring multiple agencies at once.
   ============================================================ */

WITH incident_regions AS (
    SELECT
        report_number,
        report_date,
        CASE
            WHEN location LIKE '%Beirut%' THEN 'Beirut'
            WHEN location LIKE '%Tripoli%' THEN 'Tripoli'
            WHEN location LIKE '%Saida%' THEN 'Saida'
            WHEN location LIKE '%Zahle%' THEN 'Zahle'
            WHEN location LIKE '%Tyre%' THEN 'Tyre'
            WHEN location LIKE '%Jounieh%' THEN 'Jounieh'
            WHEN location LIKE '%Baalbek%' THEN 'Baalbek'
            WHEN location LIKE '%Hazmieh%' THEN 'Hazmieh'
            ELSE 'Other'
        END AS region
    FROM incidents
),

incident_agencies AS (
    SELECT
        ir.region,
        ir.report_number,
        ir.report_date,
        (
            -- 1 if at least one hospital log exists for this incident
            CASE WHEN EXISTS (
                SELECT 1
                FROM hospital_logs hl
                WHERE hl.report_number = ir.report_number
                  AND hl.report_date   = ir.report_date
            ) THEN 1 ELSE 0 END
            +
            -- 1 if at least one fire log exists for this incident
            CASE WHEN EXISTS (
                SELECT 1
                FROM fire_logs fl
                WHERE fl.report_number = ir.report_number
                  AND fl.report_date   = ir.report_date
            ) THEN 1 ELSE 0 END
            +
            -- 1 if at least one police log exists for this incident
            CASE WHEN EXISTS (
                SELECT 1
                FROM police_logs pl
                WHERE pl.report_number = ir.report_number
                  AND pl.report_date   = ir.report_date
            ) THEN 1 ELSE 0 END
        ) AS agencies_involved
    FROM incident_regions ir
),

region_stats AS (
    SELECT
        region,
        COUNT(*) AS total_incidents,
        SUM(CASE WHEN agencies_involved >= 2 THEN 1 ELSE 0 END) AS multi_agency_incidents
    FROM incident_agencies
    GROUP BY region
)

SELECT
    region,
    total_incidents,
    multi_agency_incidents,
    ROUND(
        multi_agency_incidents / total_incidents * 100,
        2
    ) AS multi_agency_percentage
FROM region_stats
ORDER BY multi_agency_percentage DESC, multi_agency_incidents DESC;

/* ============================================================
   COMPLEX QUERY #7
   REAL-WORLD QUESTION:
   "Is there a mismatch between hospital bed capacity and the
    volume of incidents in their coverage region?"

   WHY THIS MATTERS:
   City planners and health ministry officials must ensure that
   hospitals have enough capacity to handle the incident volume
   in their region. A mismatch (many incidents but few beds)
   indicates:
     - strained hospitals,
     - overcrowding risk,
     - slower emergency care,
     - need for investment in regional health infrastructure.

   WHAT THIS QUERY DOES:
   1. Groups incidents into geographic regions.
   2. Counts incidents per region.
   3. Assigns each hospital to a region based on its address.
   4. Sums total hospital bed capacity per region.
   5. Compares:
        - incident volume per region
        - total beds available
   6. Calculates an incidents-to-bed ratio
        (higher ratio = possible mismatch).
   7. Sorts regions from most mismatched to least.

   RESULT:
   Shows which regions have high emergency demand but limited
   hospital bed capacity — essential for identifying gaps in
   healthcare coverage.
   ============================================================ */

WITH incident_regions AS (
    SELECT
        CASE
            WHEN location LIKE '%Beirut%' 
              OR location LIKE '%Hamra%'
              OR location LIKE '%Achrafieh%'
              OR location LIKE '%Clemenceau%'
              OR location LIKE '%Hazmieh%'
            THEN 'Beirut Area'
            WHEN location LIKE '%Tripoli%' THEN 'Tripoli'
            WHEN location LIKE '%Saida%' THEN 'Saida'
            WHEN location LIKE '%Zahle%' 
              OR location LIKE '%Baalbek%' THEN 'Bekaa'
            WHEN location LIKE '%Tyre%' THEN 'Tyre'
            WHEN location LIKE '%Jounieh%' THEN 'Jounieh'
            ELSE 'Other'
        END AS region
    FROM incidents
),

incident_counts AS (
    SELECT region, COUNT(*) AS incident_count
    FROM incident_regions
    GROUP BY region
),

hospital_regions AS (
    SELECT
        code,
        bed_capacity,
        CASE
            WHEN address LIKE '%Beirut%' 
              OR address LIKE '%Hamra%'
              OR address LIKE '%Achrafieh%'
              OR address LIKE '%Clemenceau%'
              OR address LIKE '%Hazmieh%'
            THEN 'Beirut Area'
            WHEN address LIKE '%Tripoli%' THEN 'Tripoli'
            WHEN address LIKE '%Saida%' THEN 'Saida'
            WHEN address LIKE '%Zahle%' 
              OR address LIKE '%Baalbek%' THEN 'Bekaa'
            WHEN address LIKE '%Tyre%' THEN 'Tyre'
            WHEN address LIKE '%Jounieh%' THEN 'Jounieh'
            ELSE 'Other'
        END AS region
    FROM hospital
),

bed_capacity_by_region AS (
    SELECT region, SUM(bed_capacity) AS total_beds
    FROM hospital_regions
    GROUP BY region
)

SELECT
    ic.region,
    ic.incident_count,
    COALESCE(bcr.total_beds, 0) AS total_beds,
    ROUND(
        ic.incident_count / COALESCE(bcr.total_beds, 1),
        3
    ) AS incidents_per_bed_ratio
FROM incident_counts ic
LEFT JOIN bed_capacity_by_region bcr
       ON ic.region = bcr.region
ORDER BY incidents_per_bed_ratio DESC;

/* ============================================================
   COMPLEX QUERY #8
   REAL-WORLD QUESTION:
   "Which types of incidents most commonly occur in areas with
    difficult accessibility?"

   WHY THIS MATTERS:
   Emergency agencies need to understand which incident types
   are most frequent in hard-to-reach areas (old souks, rural
   roads, mountainous neighborhoods, dense urban blocks).
   This helps planners improve:
       - road infrastructure,
       - fire access routes,
       - ambulance routing,
       - placement of rapid-response units.

   WHAT THIS QUERY DOES:
   1. Filters incidents where location_accessibility = 'Difficult'.
   2. Groups by incident type.
   3. Counts how many times each type appears.
   4. Sorts from most frequent to least.

   OUTPUT:
   A ranked list of incident types that occur most often in
   difficult-access regions.
   ============================================================ */

SELECT
    type AS incident_type,
    COUNT(*) AS occurrence_count
FROM incidents
WHERE location_accessibility = 'Difficult'
GROUP BY type
ORDER BY occurrence_count DESC;

/* ============================================================
   COMPLEX QUERY #9
   REAL-WORLD QUESTION:
   "Which citizens are frequent emergency reporters, and do their
    locations correlate with infrastructure weaknesses?"

   WHY THIS MATTERS:
   City planners and emergency coordinators need to understand:
     - Who is calling/reporting emergencies most frequently.
     - Whether these citizens live in areas with poor access
       (infrastructure weaknesses), such as locations that are
       hard for responders to reach.

   If the same citizens from the same neighborhoods repeatedly
   report incidents in places with "Difficult" accessibility,
   this can signal:
     - unsafe housing or street layouts,
     - poor road infrastructure,
     - lack of nearby clinics/hospitals,
     - areas needing targeted urban planning or upgrades.

   WHAT THIS QUERY DOES:
   1. Joins citizens with incidents they reported.
   2. For each citizen, computes:
        - number of incidents they reported,
        - their stored no_of_calls_made,
        - how many of their incidents had 'Difficult'
          location_accessibility,
        - the percentage of their incidents that were 'Difficult'.
   3. Ranks citizens by:
        - highest no_of_calls_made,
        - then by highest difficult-accessibility percentage.

   RESULT:
   A list of "frequent reporters" and whether their reported
   incidents tend to occur in hard-to-reach locations, helping
   identify neighborhoods with possible infrastructure problems.
   ============================================================ */

WITH citizen_incident_stats AS (
    SELECT
        c.first_name,
        c.last_name,
        c.birthdate,
        c.address,
        c.access_nearest_hospital_clinic,
        c.no_of_calls_made,
        COUNT(i.report_number) AS incidents_reported,
        SUM(CASE WHEN i.location_accessibility = 'Difficult' THEN 1 ELSE 0 END) AS difficult_incidents,
        CASE 
            WHEN COUNT(i.report_number) = 0 THEN 0
            ELSE ROUND(
                SUM(CASE WHEN i.location_accessibility = 'Difficult' THEN 1 ELSE 0 END)
                / COUNT(i.report_number) * 100,
                2
            )
        END AS difficult_incidents_percentage
    FROM citizen c
    LEFT JOIN incidents i
        ON  i.reported_by_first_name = c.first_name
        AND i.reported_by_last_name  = c.last_name
        AND i.reported_by_birthdate  = c.birthdate
    GROUP BY
        c.first_name,
        c.last_name,
        c.birthdate,
        c.address,
        c.access_nearest_hospital_clinic,
        c.no_of_calls_made
)

SELECT
    first_name,
    last_name,
    birthdate,
    address,
    access_nearest_hospital_clinic,
    no_of_calls_made,
    incidents_reported,
    difficult_incidents,
    difficult_incidents_percentage
FROM citizen_incident_stats
ORDER BY
    no_of_calls_made DESC,
    difficult_incidents_percentage DESC;


/* ============================================================
   COMPLEX QUERY #10
   REAL-WORLD QUESTION:
   "Which clinics or hospitals serve as 'Regional Magnets',
    attracting patients from outside their local district?"

   WHY THIS MATTERS:
   Identifies facilities that provide specialized care not
   available in other regions, guiding Ministry of Health
   decisions on where to build new specialized centers to
   reduce patient travel burdens.

   WHAT THIS QUERY DOES:
   1. Maps Citizens to their home region.
   2. Maps Hospitals and Clinics to their physical region.
   3. Links Citizens to Facilities via their Doctor's network.
   4. Compares Home Region vs. Facility Region.
   5. Counts 'Cross-Region' visits per facility.
   ============================================================ */

-- 1. Map CITIZENS to regions
WITH citizen_regions AS (
    SELECT
        c.first_name,
        c.last_name,
        c.birthdate,
        CASE
            WHEN c.address LIKE '%Beirut%' OR c.address LIKE '%Hamra%' OR c.address LIKE '%Achrafieh%' OR c.address LIKE '%Clemenceau%' OR c.address LIKE '%Hazmieh%' THEN 'Beirut Area'
            WHEN c.address LIKE '%Tripoli%' THEN 'Tripoli'
            WHEN c.address LIKE '%Saida%' THEN 'Saida'
            WHEN c.address LIKE '%Zahle%' OR c.address LIKE '%Baalbek%' THEN 'Bekaa'
            WHEN c.address LIKE '%Tyre%' THEN 'Tyre'
            WHEN c.address LIKE '%Jounieh%' THEN 'Jounieh'
            ELSE 'Other'
        END AS citizen_region
    FROM citizen c
),

-- 2. Map HOSPITALS to regions
hospital_regions AS (
    SELECT
        h.code AS facility_id,
        h.name AS facility_name,
        'Hospital' AS facility_type,
        CASE
            WHEN h.address LIKE '%Beirut%' OR h.address LIKE '%Hamra%' OR h.address LIKE '%Achrafieh%' OR h.address LIKE '%Clemenceau%' OR h.address LIKE '%Hazmieh%' THEN 'Beirut Area'
            WHEN h.address LIKE '%Tripoli%' THEN 'Tripoli'
            WHEN h.address LIKE '%Saida%' THEN 'Saida'
            WHEN h.address LIKE '%Zahle%' OR h.address LIKE '%Baalbek%' THEN 'Bekaa'
            WHEN h.address LIKE '%Tyre%' THEN 'Tyre'
            WHEN h.address LIKE '%Jounieh%' THEN 'Jounieh'
            ELSE 'Other'
        END AS facility_region
    FROM hospital h
),

-- 3. Map CLINICS to regions
clinic_regions AS (
    SELECT
        CONCAT(pc.name, ' | ', pc.address) AS facility_id,
        pc.name AS facility_name,
        'Clinic' AS facility_type,
        CASE
            WHEN pc.address LIKE '%Beirut%' OR pc.address LIKE '%Hamra%' OR pc.address LIKE '%Achrafieh%' OR pc.address LIKE '%Clemenceau%' OR pc.address LIKE '%Hazmieh%' THEN 'Beirut Area'
            WHEN pc.address LIKE '%Tripoli%' THEN 'Tripoli'
            WHEN pc.address LIKE '%Saida%' THEN 'Saida'
            WHEN pc.address LIKE '%Zahle%' OR pc.address LIKE '%Baalbek%' THEN 'Bekaa'
            WHEN pc.address LIKE '%Tyre%' THEN 'Tyre'
            WHEN pc.address LIKE '%Jounieh%' THEN 'Jounieh'
            ELSE 'Other'
        END AS facility_region
    FROM private_clinic pc
),

-- 4. Combine hospitals + clinics into one table
all_facilities AS (
    SELECT * FROM hospital_regions
    UNION ALL
    SELECT * FROM clinic_regions
),

-- 5. Connect patients → doctors → facilities
patient_movements AS (
    SELECT
        f.facility_name,
        f.facility_type,
        f.facility_region,
        cr.citizen_region
    FROM consult co
    JOIN citizen_regions cr
      ON cr.first_name = co.citizen_first_name
     AND cr.last_name  = co.citizen_last_name
     AND cr.birthdate  = co.citizen_birthdate
    JOIN all_facilities f
      ON (
           (f.facility_type = 'Hospital' AND f.facility_id IN (
               SELECT w.code FROM works_in w WHERE w.medical_license_no = co.medical_license_no
           ))
        OR (f.facility_type = 'Clinic' AND f.facility_id IN (
               -- FIXED TYPO HERE: Removed the extra quote after clinic_address
               SELECT CONCAT(e.clinic_name, ' | ', e.clinic_address)
               FROM employ e 
               WHERE e.medical_license_no = co.medical_license_no
           ))
      )
),

-- 6. Count cross-region visits
cross_region_traffic AS (
    SELECT
        facility_name,
        facility_type,
        COUNT(*) AS cross_region_visits
    FROM patient_movements
    WHERE citizen_region <> facility_region
    GROUP BY facility_name, facility_type
)

-- FINAL OUTPUT
SELECT
    facility_name,
    facility_type,
    cross_region_visits
FROM cross_region_traffic
ORDER BY cross_region_visits DESC;






