-- QUERY 2: Which Equipment Type Fails Most Often?
-- ============================================
-- Purpose: Break down failures by equipment type and failure reason
-- Business Question: Which equipment should we focus maintenance on?
-- Action: Identify patterns in failures (bearing failures, hydraulic leaks, etc.)

SELECT 
    m.equipment_type,
    COUNT(d.downtime_id) AS failure_count,
    ROUND(SUM(d.duration_hours), 2) AS total_downtime_hours,
    ROUND(SUM(d.duration_hours) / COUNT(d.downtime_id), 2) AS avg_hours_per_failure,
    d.reason
FROM machines m
LEFT JOIN downtime_logs d ON m.machine_id = d.machine_id
WHERE d.downtime_id IS NOT NULL
GROUP BY m.equipment_type, d.reason
ORDER BY failure_count DESC, total_downtime_hours DESC;

-- ============================================
-- EXPECTED OUTPUT:
-- ============================================
/*
equipment_type | failure_count | total_downtime_hours | avg_hours_per_failure | reason
CNC            | 3             | 34.00                | 11.33                 | Bearing Failure
Conveyor       | 2             | 12.00                | 6.00                  | Mechanical
Welder         | 2             | 13.00                | 6.50                  | Hydraulic Leak
Packer         | 2             | 26.00                | 13.00                 | Mechanical/Electronic

INTERPRETATION:
- CNC machines fail most often (3 times) with bearing failures (11+ hours each)
- Hydraulic leaks on welding units are recurring (happened twice)
- Conveyor and Packer have fewer failures but packer takes longer to repair (13 hours avg)
- Bearing failures are PREDICTABLE - can be prevented with maintenance schedule
- Hydraulic leaks suggest maintenance issue (fluid degradation, seal wear)
*/

-- ============================================
-- HOW TO EXPLAIN THIS TO MANAGEMENT:
-- ============================================
/*
"CNC machines fail 3 times with bearing failures, averaging 11+ hours down per failure.
This is predictable downtime - bearings wear out on a schedule, so we can replace them
BEFORE they fail, not after.

Welding units have recurring hydraulic leaks (happened twice). This suggests the
hydraulic fluid or seals need attention on a regular maintenance schedule.

Preventive maintenance for CNC bearings alone would prevent 34 hours of downtime
(worth ₹18,720 in lost production)."
*/
