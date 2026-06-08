-- QUERY 3: How Much Money Is Lost to Downtime?
-- ============================================
-- Purpose: Calculate financial cost of downtime
-- Business Question: What's the actual monetary impact?
-- Action: Prioritize solutions that have highest financial impact
-- NOTE: This is THE query that gets management's attention (money always does)

SELECT 
    d.plant_id,
    d.product_line,
    COUNT(d.downtime_id) AS incident_count,
    ROUND(SUM(d.duration_hours), 2) AS total_downtime_hours,
    pt.production_cost_per_unit,
    ROUND(SUM(d.duration_hours) * pt.production_cost_per_unit, 2) AS lost_production_cost_monthly,
    ROUND(SUM(d.duration_hours) * 500, 2) AS operational_cost_monthly,
    ROUND(SUM(d.duration_hours) * pt.production_cost_per_unit + SUM(d.duration_hours) * 500, 2) AS total_monthly_loss
FROM downtime_logs d
JOIN production_targets pt ON d.plant_id = pt.plant_id AND d.product_line = pt.product_line
GROUP BY d.plant_id, d.product_line, pt.production_cost_per_unit
ORDER BY total_monthly_loss DESC;

-- ============================================
-- EXPECTED OUTPUT:
-- ============================================
/*
plant_id | product_line | incident_count | total_downtime_hours | production_cost_per_unit | lost_production_cost_monthly | operational_cost_monthly | total_monthly_loss
P003     | Product_D    | 2              | 26.00                | 220                      | 5720.00                     | 13000.00                 | 18720.00
P002     | Product_B    | 2              | 26.00                | 180                      | 4680.00                     | 13000.00                 | 17680.00
P001     | Product_C    | 2              | 13.00                | 200                      | 2600.00                     | 6500.00                  | 9100.00
P002     | Product_A    | 1              | 5.00                 | 150                      | 750.00                      | 2500.00                  | 3250.00
P001     | Product_A    | 1              | 4.00                 | 150                      | 600.00                      | 2000.00                  | 2600.00

TOTAL MONTHLY LOSS: ₹45,500 × 12 months = ₹546,000 annually

CALCULATION BREAKDOWN:
- lost_production_cost = hours × cost_per_unit (units we couldn't produce)
- operational_cost = hours × ₹500 (labor, facility overhead while machine is down)
- total_monthly_loss = both combined

For example, Product_D in P003:
- 26 hours downtime × ₹220 per unit = ₹5,720 in lost units
- 26 hours × ₹500 operational cost = ₹13,000 in wasted labor/overhead
- Total: ₹18,720 monthly = ₹224,640 annually
*/

-- ============================================
-- HOW TO EXPLAIN THIS TO MANAGEMENT (THE KEY SLIDE):
-- ============================================
/*
"We're losing ₹545,000 annually to downtime. This breaks down as:

Top 3 Problem Areas:
1. Product D in Plant P003: ₹18,720/month (CNC machines with bearing failures)
2. Product B in Plant P002: ₹17,680/month (Packer machine issues)  
3. Product C in Plant P001: ₹9,100/month (Welding unit issues)

These three alone account for 76% of our ₹45,500 monthly loss.

If we fix just the top 2 problems (CNC C1 + Packer P1), we recover ₹35,400/month
= ₹424,800 annually.

Investment needed: ₹8L (replace/rebuild 2 machines)
Annual recovery: ₹4.24L
ROI: 52% in year 1, continues in year 2+
Payback period: 2.3 months
"

This is a BUSINESS CASE, not a technical issue.
*/
