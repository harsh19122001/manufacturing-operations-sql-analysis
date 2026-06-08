# Manufacturing Operations SQL Analysis

## 📊 The Problem

A manufacturing company operates 3 plants producing 5 product lines. They have production data, machine data, and downtime logs scattered across systems — but **no visibility into which machines/plants are actually losing them money**.

Management knows downtime happens. But they don't know:
- Which plant performs worst?
- Which machines fail most often?
- How much money is this costing monthly/annually?
- Which products are delayed because of equipment failures?
- Which machines should be replaced vs maintained?

**Result:** ₹50L+ annual losses, but nobody can see it or fix it.

---

## 🎯 What I Found

I analyzed 6 months of downtime data using SQL and discovered:

### **Finding 1: Plant P003 is the Problem**
- **4.72% of production capacity is lost monthly** (vs 3.47% at Plant P001)
- 34 hours of downtime last month alone
- **Root cause:** CNC machines with bearing failures

### **Finding 2: Two Machines Cause 78% of All Costs**
- **CNC Machine C1** (Plant P003): 2 bearing failures = ₹18,720 monthly loss
- **Packer Machine P1** (Plant P002): 2 failures = ₹17,680 monthly loss
- Other 4 machines combined: ₹9,100 monthly loss

### **Finding 3: Total Annual Cost Leak is ₹5.46 Lakhs**
```
Monthly downtime cost: ₹45,500
Annual downtime cost: ₹546,000
```

Broken down by reason:
- Bearing failures: 44% (predictable, preventable)
- Hydraulic leaks: 28% (recurring pattern)
- Mechanical failures: 20%
- Electronic faults: 8%

### **Finding 4: Products D & B Are Most Delayed**
- Product D loses 3.61% capacity due to downtime
- Product B loses 3.61% capacity due to downtime
- Both delayed, customer fulfillment at risk

### **Finding 5: Machine Age Matters**
- Machines 6+ years old have 2x failure rate
- CNC C1 is 7 years old (highest risk)
- Welding Unit W2 is 6 years old (high risk)
- Others are newer, more stable

---

## 💡 My Recommendation

**Stop reacting to failures. Start preventing them.**

### Option A: Reactive (Current State)
- Machine breaks → Emergency repair → ₹50L+ downtime cost annually
- No predictability, constant surprises

### Option B: Preventive (Recommended)
- **Spend ₹8L now:**
  - Replace CNC Machine C1 (₹3.5L)
  - Rebuild/maintain Packer P1 (₹2.5L)
  - Implement bearing replacement schedule for CNC machines (₹2L)

- **Recover ₹4.2L annually:**
  - Prevent CNC failures (saves ₹3.5L/year)
  - Eliminate packer downtime (saves ₹2.1L/year)
  - Reduce other failures through preventive maintenance (saves ₹1.2L/year)

**ROI: 52% in Year 1. Pays for itself in 2.3 months.**

---

## 📁 Files in This Repository

### **Database Files**
- **`schema_and_sample_data.sql`** — Complete database setup. Copy-paste this into MySQL Workbench to create tables and insert sample data.

### **Query Files (Analysis)**
- **`query_1_plant_downtime.sql`** — Which plant has the worst downtime? Answer: Plant P003 (4.72% capacity loss)
- **`query_2_equipment_failures.sql`** — Which equipment fails most often? Answer: CNC machines with bearing failures
- **`query_3_financial_impact.sql`** — How much money is lost to downtime? Answer: ₹5.46L annually
- **`query_4_equipment_age_risk.sql`** — Which machines are high-risk and aging? Answer: CNC C1, Welding W2, Packer P1
- **`query_5_product_line_impact.sql`** — Which products are delayed by equipment failure? Answer: Product D & B at 3.6% capacity loss each

### **Results File**
- **`results_and_findings.txt`** — Sample output from running each query + business interpretation

---

## 🚀 How to Use This

### **Step 1: Set Up the Database**
```
1. Open MySQL Workbench
2. Copy ALL of schema_and_sample_data.sql
3. Paste into MySQL Workbench query editor
4. Hit Execute (Ctrl+Enter)
5. You now have a complete database with 3 tables + sample data
```

### **Step 2: Run Each Query**
```
1. Open query_1_plant_downtime.sql
2. Copy the SQL code
3. Paste into MySQL Workbench
4. Execute (Ctrl+Enter)
5. See the results
6. Repeat for queries 2-5
```

### **Step 3: Understand the Business Logic**
- Don't just run queries. Understand WHY each query answers a business question
- For example: Query 1 groups by plant_id to compare performance across locations
- Query 3 multiplies downtime_hours × production_cost_per_unit to calculate financial impact

### **Step 4: Read the Results File**
- See sample outputs from each query
- Understand what the numbers mean
- Learn how to explain findings to business stakeholders

---

## 📊 Key SQL Skills Demonstrated

✅ **GROUP BY & Aggregations** — Sum, Count, Avg, Round
✅ **JOINs** — LEFT JOIN to combine machines + downtime data + production targets
✅ **CTEs (Common Table Expressions)** — Query 4 uses WITH clause for readability
✅ **CASE Logic** — Query 4 uses CASE to flag machine risk levels
✅ **Window Functions** — Calculates percentages and comparative metrics
✅ **Date Functions** — YEAR, MONTH to analyze temporal patterns
✅ **Subqueries** — Nested queries for complex filtering
✅ **Mathematical Operations** — Cost calculations, percentage calculations

---

## 💼 Business Skills Demonstrated

✅ **Problem Identification** — Found ₹5.46L annual cost leak
✅ **Root Cause Analysis** — Traced problem to 2 specific machines
✅ **Financial Analysis** — Calculated cost impact with precision
✅ **Risk Assessment** — Flagged aging machines before they fail
✅ **Solution Design** — Recommended preventive maintenance strategy
✅ **ROI Calculation** — Showed 52% return on ₹8L investment
✅ **Stakeholder Communication** — Explained findings in business language, not SQL jargon

---

## 🎓 What You'll Learn From This

If you study this case study, you'll learn:

1. **How to think like a data analyst:**
   - Start with a business problem
   - Use data to understand it
   - Quantify the impact
   - Recommend solutions with ROI

2. **Advanced SQL techniques:**
   - CTEs for cleaner, more maintainable queries
   - Window functions for comparative analysis
   - Case logic for classification
   - Multiple joins for complex relationships

3. **How to communicate data findings:**
   - Lead with business impact, not technical details
   - Use numbers to tell a story
   - Explain "so what?" for every finding
   - Recommend actions, not just report data

---

## 📈 Real-World Application

This case study is based on **actual manufacturing operations challenges**. Companies like these face similar problems:

- **Manufacturing:** Downtime in plants, equipment failures, production delays
- **Logistics:** Vehicle breakdowns, delivery delays, route inefficiencies
- **Retail:** Store underperformance, product return rates, inventory issues
- **E-commerce:** Warehouse downtime, fulfillment delays, cancellation rates

**The analysis approach is the same for all:** Find where money is leaking, quantify it, recommend fixes with ROI.

---

## 🔧 Technical Stack

- **Database:** MySQL
- **SQL Features:** Joins, CTEs, Window Functions, Aggregations, CASE Logic, Date Functions
- **Analysis Type:** Operational Performance, Cost Impact, Risk Assessment
- **Sample Data:** 6 months of manufacturing downtime logs (10 downtime incidents, 6 machines, 3 plants)

---

## 📋 Data Dictionary

### **machines Table**
| Column | Type | Meaning |
|---|---|---|
| machine_id | INT | Unique identifier for each machine |
| machine_name | VARCHAR(100) | Human-readable name (e.g., "CNC Machine C1") |
| plant_id | VARCHAR(10) | Which plant (P001, P002, P003) |
| equipment_type | VARCHAR(50) | Type of equipment (Conveyor, CNC, Welder, Packer) |
| purchase_date | DATE | When the machine was installed |

### **downtime_logs Table**
| Column | Type | Meaning |
|---|---|---|
| downtime_id | INT | Unique identifier for each downtime incident |
| machine_id | INT | Which machine failed |
| plant_id | VARCHAR(10) | Which plant it's in |
| downtime_date | DATE | When the failure happened |
| duration_hours | INT | How long the machine was down |
| reason | VARCHAR(100) | Why it failed (e.g., "Bearing Failure") |
| product_line | VARCHAR(50) | Which product was affected |

### **production_targets Table**
| Column | Type | Meaning |
|---|---|---|
| target_id | INT | Unique identifier |
| plant_id | VARCHAR(10) | Which plant |
| product_line | VARCHAR(50) | Which product |
| target_units_monthly | INT | Target production quantity |
| production_cost_per_unit | INT | Cost to produce one unit (in rupees) |

---

## 🎯 Interview Questions This Answers

**Q: Tell me about a time you analyzed operational data**
A: "I analyzed downtime logs across 3 manufacturing plants and found ₹5.46L annual losses..."

**Q: How do you approach a complex data problem?**
A: "I start with a business question ('where's the money leak?'), use SQL to find the answer, quantify the impact, and recommend solutions with ROI..."

**Q: Walk me through your SQL skills**
A: "I use JOINs to combine data from multiple tables, CTEs to make queries readable, aggregations to summarize, and CASE logic to classify findings..."

**Q: Tell me about a time you found a problem and recommended a solution**
A: "I identified that 2 machines cause 78% of downtime costs. I recommended preventive maintenance that recovers ₹4.2L annually with 52% ROI..."

---

## 📧 Connect

If you have questions about this analysis or want to discuss data-driven operations, reach out:

- **LinkedIn:** [Your LinkedIn URL]
- **Email:** hjaiswal741@gmail.com
- **GitHub:** [Your GitHub profile]

---

## 📝 License

This case study is open-source and available for learning purposes. Feel free to modify the data, expand the analysis, or use it as a template for your own projects.

---

**Last Updated:** June 2024
**Status:** Complete case study with 5 SQL queries, sample data, and business recommendations
