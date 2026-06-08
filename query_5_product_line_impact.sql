-- QUERY 5: Which Product Lines Are Most Affected by Downtime?
-- ============================================
-- Purpose: Show which customer-facing products are delayed
-- Business Question: Which products should we prioritize fixing for?
-- Action: Ensure critical product lines have redundancy/backup plans

SELECT 
    d.product_line,
    COUNT(d.downtime_id) AS incident_count,
    ROUND(SUM(d.duration_hours), 2) AS total_downtime_hours,
    COUNT(DISTINCT d.machine_id) AS machines_affected,
    pt.target_units_monthly,
    ROUND(SUM(d.duration_hours) * pt.production_cost_per_unit, 2) AS estimated_lost_revenue,
    ROUND((SUM(d.duration_hours) / (30 * 24)) * 100, 2) AS monthly_capacity_lost_percent
FROM downtime_logs d
JOIN production_targets pt ON d.product_line = pt.product_line
GROUP BY d.product_line, pt.target_units_monthly, pt.production_cost_per_unit
ORDER BY total_downtime_hours DESC;

-- ============================================
-- EXPECTED OUTPUT:
-- ============================================
/*
product_line | incident_count | total_downtime_hours | machines_affected | target_units_monthly | estimated_lost_revenue | monthly_capacity_lost_percent
Product_D    | 2              | 26.00                | 2                 | 3000                 | 5720.00                | 3.61
Product_B    | 2              | 26.00                | 2                 | 4000                 | 4680.00                | 3.61
Product_A    | 3              | 17.00                | 3                 | 7500                 | 2550.00                | 2.36
Product_C    | 2              | 13.00                | 1                 | 3000                 | 2600.00                | 1.81
Product_E    | 1              | 10.00                | 1                 | 2000                 | 2500.00                | 1.39

INTERPRETATION:
- Product D & B are both delayed 3.6% of the time (highest impact on customers)
- Product A is delayed 2.36% across 3 different machines (dispersed risk)
- Product C has lowest impact (1.81% delay rate)
- Products D & B need attention: they're at risk of missing customer deadlines
*/

-- ============================================
-- CAPACITY LOSS EXPLAINED:
-- ============================================
/*
"monthly_capacity_lost_percent" = (total_downtime_hours) / (30 days × 24 hours per day) × 100

Example for Product D:
- 26 hours downtime per month
- 30 × 24 = 720 hours total monthly production capacity
- 26 / 720 = 0.0361 = 3.61% capacity lost

This means: To produce 3000 units of Product D monthly, we need 720 "machine hours"
But we lose 26 hours to downtime, so we're missing 3.61% of our target.

If we produce at constant rate:
- 3000 units needs 720 hours
- 26 hours lost = 26/720 × 3000 = 108 units NOT produced
- So Product D is SHORT 108 units per month due to downtime
*/

-- ============================================
-- HOW TO EXPLAIN THIS TO PRODUCT MANAGERS:
-- ============================================
/*
"Product D & B Status: AT RISK

Product D: 3.61% of production capacity is lost to downtime
- This means you're missing ~108 units per month
- 2 machines affecting this product have failed
- Customers may not get their full orders on time

Product B: 3.61% of production capacity is lost to downtime  
- Same situation: missing ~144 units per month (larger volume)
- 2 different machines both affecting this product

IMMEDIATE ACTIONS:
1. Implement backup/redundancy for machines producing Products D & B
2. Notify customers about potential delays (be proactive)
3. Fix CNC Machine C1 (affects Product D)
4. Fix Packer Machine P1 (affects Product B)

Expected impact: 
- Once these machines are fixed, capacity for D & B increases to 96%+ reliability
- Customer satisfaction improves
- Revenue stabilizes

MEDIUM TERM:
- Consider adding a second machine for critical products D & B
- Equipment redundancy = insurance against downtime
"
*/

-- ============================================
-- SQL CONCEPTS USED:
-- ============================================
/*
JOIN: Combines downtime_logs with production_targets so we can match products
      with their production costs

AGGREGATIONS: COUNT, SUM, ROUND to calculate totals

GROUP BY: Groups by product_line so we see impact per product

ORDER BY: Shows worst-affected products first

Mathematical calculation: SUM(hours) / (30 * 24) * 100
          = Converts hours to percentage of monthly capacity
*/
