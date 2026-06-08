-- ============================================
-- MANUFACTURING OPERATIONS DATABASE SETUP
-- Copy and paste ALL of this into MySQL Workbench
-- Then execute (Ctrl+Enter)
-- ============================================

-- Step 1: Create database
DROP DATABASE IF EXISTS manufacturing_ops;
CREATE DATABASE manufacturing_ops;
USE manufacturing_ops;

-- ============================================
-- STEP 2: CREATE TABLES
-- ============================================

-- Table 1: Machines in each plant
CREATE TABLE machines (
    machine_id INT PRIMARY KEY,
    machine_name VARCHAR(100),
    plant_id VARCHAR(10),
    equipment_type VARCHAR(50),
    purchase_date DATE
);

-- Table 2: Downtime incidents
CREATE TABLE downtime_logs (
    downtime_id INT PRIMARY KEY,
    machine_id INT,
    plant_id VARCHAR(10),
    downtime_date DATE,
    duration_hours INT,
    reason VARCHAR(100),
    product_line VARCHAR(50),
    FOREIGN KEY (machine_id) REFERENCES machines(machine_id)
);

-- Table 3: Production targets and costs
CREATE TABLE production_targets (
    target_id INT PRIMARY KEY,
    plant_id VARCHAR(10),
    product_line VARCHAR(50),
    target_units_monthly INT,
    production_cost_per_unit INT
);

-- ============================================
-- STEP 3: INSERT SAMPLE DATA
-- ============================================

-- Insert machines data
INSERT INTO machines VALUES 
(1, 'Assembly Line A1', 'P001', 'Conveyor', '2019-01-15'),
(2, 'Welding Unit W2', 'P001', 'Welder', '2018-06-20'),
(3, 'Packaging Machine P1', 'P002', 'Packer', '2020-03-10'),
(4, 'Assembly Line A2', 'P002', 'Conveyor', '2019-11-05'),
(5, 'CNC Machine C1', 'P003', 'CNC', '2017-02-28'),
(6, 'CNC Machine C2', 'P003', 'CNC', '2018-09-12');

-- Insert downtime logs
INSERT INTO downtime_logs VALUES 
(1, 1, 'P001', '2024-01-05', 8, 'Mechanical', 'Product_A'),
(2, 2, 'P001', '2024-01-12', 6, 'Hydraulic Leak', 'Product_C'),
(3, 1, 'P001', '2024-01-20', 4, 'Sensor Error', 'Product_A'),
(4, 3, 'P002', '2024-01-08', 12, 'Mechanical', 'Product_B'),
(5, 5, 'P003', '2024-01-03', 16, 'Bearing Failure', 'Product_D'),
(6, 5, 'P003', '2024-01-15', 10, 'Bearing Failure', 'Product_E'),
(7, 6, 'P003', '2024-01-22', 8, 'Alignment Issue', 'Product_D'),
(8, 4, 'P002', '2024-02-01', 5, 'Mechanical', 'Product_A'),
(9, 2, 'P001', '2024-02-05', 7, 'Hydraulic Leak', 'Product_C'),
(10, 3, 'P002', '2024-02-10', 14, 'Electronic Fault', 'Product_B');

-- Insert production targets
INSERT INTO production_targets VALUES 
(1, 'P001', 'Product_A', 5000, 150),
(2, 'P001', 'Product_C', 3000, 200),
(3, 'P002', 'Product_B', 4000, 180),
(4, 'P002', 'Product_A', 2500, 150),
(5, 'P003', 'Product_D', 3000, 220),
(6, 'P003', 'Product_E', 2000, 250);

-- ============================================
-- VERIFICATION: Check if data was inserted correctly
-- ============================================

SELECT 'MACHINES' AS table_name, COUNT(*) AS row_count FROM machines
UNION ALL
SELECT 'DOWNTIME_LOGS', COUNT(*) FROM downtime_logs
UNION ALL
SELECT 'PRODUCTION_TARGETS', COUNT(*) FROM production_targets;

-- Expected output:
-- MACHINES: 6 rows
-- DOWNTIME_LOGS: 10 rows
-- PRODUCTION_TARGETS: 6 rows

-- If you see this, database setup is successful!
