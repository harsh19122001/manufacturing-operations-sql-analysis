-- QUERY 1: Which Plant Has the Worst Downtime?
-- ============================================
-- Purpose: Compare downtime performance across all 3 plants
-- Business Question: Which location is losing the most production capacity?
-- Action: Focus improvement efforts on worst-performing plant

SELECT 
    m.plant_id,
    COUNT(d.downtime_id) AS total_incidents,
    ROUND(SUM(d.duration_hours), 2) AS total_downtime_hours,
    ROUND(AVG(d.duration_hours), 2) AS avg_downtime_per_incident,
    ROUND((SUM(d.duration_hours) / (30 * 24)) * 100, 2) AS downtime_percentage_monthly
FROM machines m
LEFT JOIN downtime_logs d ON m.machine_id = d.machine_id
GROUP BY m.plant_id
ORDER BY total_downtime_hours DESC;

-- ============================================
-- EXPECTED OUTPUT:
-- ============================================
/*
plant_id | total_incidents | total_downtime_hours | avg_downtime_per_incident | downtime_percentage_monthly
P003     | 3               | 34.00                | 11.33                     | 4.72
P002     | 3               | 31.00                | 10.33                     | 4.27
P001     | 4               | 25.00                | 6.25                      | 3.47

INTERPRETATION:
- Plant P003 has the WORST performance (4.72% of monthly capacity lost)
- This means Plant P003 loses about 34 hours per month (out of 720 hours)
- Plant P001 performs best but still has 25 hours downtime
- All plants have room for improvement
- Plant P003 should be priority for maintenance review
*/

-- ============================================
-- HOW TO EXPLAIN THIS TO MANAGEMENT:
-- ============================================
/*
"We analyzed downtime across all 3 plants over 6 months. 
Plant P003 loses 34 hours per month, which is 4.72% of total production capacity.
Plant P001 loses 25 hours per month (3.47% capacity).

This means Plant P003 is essentially closed for almost 2 full days per month
due to equipment failures. We need to focus improvement efforts there first."
*/
