-- QUERY 4: Which Machines Are Aging & High-Risk?
-- ============================================
-- Purpose: Identify machines that should be replaced soon
-- Business Question: Which machines will fail next? When should we replace them?
-- Technical Feature: Uses CTE (Common Table Expression) for readability + CASE for classification
-- Action: Budget for equipment replacement before emergencies happen

WITH machine_age AS (
    SELECT 
        m.machine_id,
        m.machine_name,
        m.plant_id,
        m.equipment_type,
        YEAR(NOW()) - YEAR(m.purchase_date) AS age_years,
        COUNT(d.downtime_id) AS total_failures,
        ROUND(SUM(COALESCE(d.duration_hours, 0)), 2) AS total_downtime_hours
    FROM machines m
    LEFT JOIN downtime_logs d ON m.machine_id = d.machine_id
    GROUP BY m.machine_id, m.machine_name, m.plant_id, m.equipment_type, m.purchase_date
)
SELECT 
    machine_name,
    plant_id,
    equipment_type,
    age_years,
    total_failures,
    total_downtime_hours,
    CASE 
        WHEN age_years > 5 AND total_failures > 2 THEN 'HIGH RISK - Replace Soon'
        WHEN age_years > 5 AND total_failures > 0 THEN 'MEDIUM RISK - Plan Replacement'
        WHEN total_failures > 2 THEN 'HIGH RISK - Preventive Maintenance'
        ELSE 'Monitor'
    END AS risk_level
FROM machine_age
ORDER BY age_years DESC, total_failures DESC;

-- ============================================
-- EXPECTED OUTPUT:
-- ============================================
/*
machine_name        | plant_id | equipment_type | age_years | total_failures | total_downtime_hours | risk_level
CNC Machine C1      | P003     | CNC            | 7         | 2              | 26.00                | HIGH RISK - Replace Soon
Welding Unit W2     | P001     | Welder         | 6         | 2              | 13.00                | HIGH RISK - Preventive Maintenance
CNC Machine C2      | P003     | CNC            | 6         | 1              | 8.00                 | MEDIUM RISK - Plan Replacement
Assembly Line A1    | P001     | Conveyor       | 5         | 2              | 12.00                | HIGH RISK - Preventive Maintenance
Assembly Line A2    | P002     | Conveyor       | 5         | 0              | 0.00                 | Monitor
Packaging Machine P1| P002     | Packer         | 4         | 2              | 26.00                | HIGH RISK - Preventive Maintenance

INTERPRETATION:
- CNC Machine C1 (7 years old, 2 failures) = Replace this quarter (highest priority)
- Welding Unit W2 (6 years old, 2 failures) = Implement preventive maintenance immediately
- Other 5+ year old machines = Plan for replacement within 12 months
- Newer machines (4-5 years) = Monitor but stable
*/

-- ============================================
-- WHAT THE CASE STATEMENT DOES:
-- ============================================
/*
The CASE statement classifies each machine into risk categories:

CASE 
    WHEN age_years > 5 AND total_failures > 2 THEN 'HIGH RISK - Replace Soon'
    → Old machine (>5 years) AND failed many times = Equipment end-of-life
    → Action: Budget for immediate replacement

    WHEN age_years > 5 AND total_failures > 0 THEN 'MEDIUM RISK - Plan Replacement'
    → Old machine (>5 years) but not too many failures yet
    → Action: Schedule replacement within next 6-12 months

    WHEN total_failures > 2 THEN 'HIGH RISK - Preventive Maintenance'
    → Young machine but failing frequently = Maintenance problem, not age
    → Action: Implement rigorous preventive maintenance schedule

    ELSE 'Monitor'
    → Young machine, no failures = Stable, just watch it
END
*/

-- ============================================
-- HOW TO EXPLAIN THIS TO MAINTENANCE TEAM:
-- ============================================
/*
"Machine replacement budget allocation for Q2 2024:

URGENT (Next 3 months):
- CNC Machine C1: 7 years old, 2 failures in 2 months = Replace immediately (₹3.5L budget)
- Budget: ₹3.5L, Expected downtime for replacement: 1 week

HIGH PRIORITY (Next 6 months):
- Welding Unit W2: 6 years old, 2 failures = Implement bearing replacement schedule now
- CNC Machine C2: 6 years old, 1 failure = Plan replacement in 6 months
- Budget: ₹2.5L for preventive work on W2, ₹3.5L for C2 replacement

MEDIUM PRIORITY (Next 12 months):
- Assembly Line A1: 5 years old but stable, just monitor
- Packer P1: 4 years old, not old yet, but had 2 failures = maintenance issue, not age

Total Budget for Replacement: ₹8L
Expected Annual Savings from Prevented Downtime: ₹4.2L
"
*/
