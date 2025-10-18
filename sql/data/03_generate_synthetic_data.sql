-- ============================================================================
-- Lereta Intelligence Agent - Synthetic Data Generation
-- ============================================================================
-- Purpose: Generate realistic sample data for Lereta tax and flood operations
-- Volume: ~10K clients, 500K properties, 750K loans, 2M tax records
-- ============================================================================

USE DATABASE LERETA_INTELLIGENCE;
USE SCHEMA RAW;
USE WAREHOUSE LERETA_WH;

-- ============================================================================
-- Step 1: Generate Support Agents
-- ============================================================================
INSERT INTO SUPPORT_AGENTS
SELECT
    'AGT' || LPAD(SEQ4(), 5, '0') AS agent_id,
    ARRAY_CONSTRUCT('John Smith', 'Sarah Johnson', 'Michael Chen', 'Emily Williams', 'David Martinez',
                    'Jessica Brown', 'Christopher Lee', 'Amanda Garcia', 'Matthew Rodriguez', 'Ashley Lopez')[UNIFORM(0, 9, RANDOM())] 
        || ' ' || ARRAY_CONSTRUCT('A', 'B', 'C', 'D', 'E')[UNIFORM(0, 4, RANDOM())] AS agent_name,
    'agent' || SEQ4() || '@lereta.com' AS email,
    ARRAY_CONSTRUCT('TAX_SERVICES', 'FLOOD_SERVICES', 'TECHNICAL', 'COMPLIANCE', 'BILLING')[UNIFORM(0, 4, RANDOM())] AS department,
    ARRAY_CONSTRUCT('Property Tax', 'Flood Certification', 'System Training', 'Regulatory Compliance', 'Account Support')[UNIFORM(0, 4, RANDOM())] AS specialization,
    DATEADD('day', -1 * UNIFORM(30, 1825, RANDOM()), CURRENT_DATE()) AS hire_date,
    (UNIFORM(38, 50, RANDOM()) / 10.0)::NUMBER(3,2) AS average_satisfaction_rating,
    UNIFORM(200, 8000, RANDOM()) AS total_tickets_resolved,
    'ACTIVE' AS agent_status,
    DATEADD('day', -1 * UNIFORM(30, 1825, RANDOM()), CURRENT_TIMESTAMP()) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM TABLE(GENERATOR(ROWCOUNT => 100));

-- ============================================================================
-- Step 2: Generate Products
-- ============================================================================
INSERT INTO PRODUCTS VALUES
-- Tax Monitoring Products
('PROD001', 'Basic Tax Monitoring', 'TAX_MONITORING', 'BASIC', NULL, 2.50, 'PER_PROPERTY_MONTHLY', 'Basic property tax tracking and payment monitoring', TRUE, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD002', 'Professional Tax Service', 'TAX_MONITORING', 'PROFESSIONAL', NULL, 3.50, 'PER_PROPERTY_MONTHLY', 'Comprehensive tax monitoring with delinquency alerts', TRUE, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD003', 'Enterprise Tax Suite', 'TAX_MONITORING', 'ENTERPRISE', NULL, 4.50, 'PER_PROPERTY_MONTHLY', 'Full tax service with escrow management and disbursement', TRUE, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD004', 'Tax Certificate Service', 'TAX_MONITORING', 'ADDON', 15.00, NULL, 'ONE_TIME', 'Official property tax certificate', TRUE, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD005', 'Tax Research Service', 'TAX_MONITORING', 'ADDON', 25.00, NULL, 'ONE_TIME', 'Historical tax research and verification', TRUE, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),

-- Flood Certification Products
('PROD010', 'Standard Flood Determination', 'FLOOD_CERTIFICATION', 'BASIC', 12.00, NULL, 'ONE_TIME', 'FEMA flood zone determination', TRUE, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD011', 'Life-of-Loan Flood Tracking', 'FLOOD_CERTIFICATION', 'PROFESSIONAL', NULL, 1.50, 'PER_PROPERTY_MONTHLY', 'Continuous flood zone monitoring with map change alerts', TRUE, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD012', 'Full Flood Compliance Suite', 'FLOOD_CERTIFICATION', 'ENTERPRISE', NULL, 2.50, 'PER_PROPERTY_MONTHLY', 'Complete flood compliance with insurance tracking', TRUE, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD013', 'Flood Zone Recertification', 'FLOOD_CERTIFICATION', 'ADDON', 15.00, NULL, 'ONE_TIME', 'Updated flood determination after map changes', TRUE, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),

-- Compliance Products
('PROD020', 'Basic Compliance Reporting', 'COMPLIANCE_REPORTING', 'BASIC', NULL, 499.00, 'MONTHLY', 'Standard compliance reports and audit support', TRUE, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD021', 'Advanced Analytics Platform', 'COMPLIANCE_REPORTING', 'PROFESSIONAL', NULL, 999.00, 'MONTHLY', 'Advanced analytics and custom reporting', TRUE, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD022', 'Enterprise Compliance Suite', 'COMPLIANCE_REPORTING', 'ENTERPRISE', NULL, 1999.00, 'MONTHLY', 'Full compliance platform with API access', TRUE, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),

-- Full Suite Packages
('PROD030', 'Lereta Total Tax Solutions - Basic', 'FULL_SUITE', 'BASIC', NULL, 3.99, 'PER_PROPERTY_MONTHLY', 'Tax + Flood monitoring for small portfolios', TRUE, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD031', 'Lereta Total Tax Solutions - Professional', 'FULL_SUITE', 'PROFESSIONAL', NULL, 5.49, 'PER_PROPERTY_MONTHLY', 'Comprehensive tax and flood services', TRUE, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD032', 'Lereta Total Tax Solutions - Enterprise', 'FULL_SUITE', 'ENTERPRISE', NULL, 6.99, 'PER_PROPERTY_MONTHLY', 'Full tax, flood, and compliance platform', TRUE, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP());

-- ============================================================================
-- Step 3: Generate Flood Zones Reference Data
-- ============================================================================
INSERT INTO FLOOD_ZONES VALUES
('AE', 'A', 'High-risk flood zone with detailed elevation data', 'HIGH_RISK', TRUE, CURRENT_TIMESTAMP()),
('A', 'A', 'High-risk flood zone (100-year floodplain)', 'HIGH_RISK', TRUE, CURRENT_TIMESTAMP()),
('AH', 'A', 'High-risk flood zone with shallow flooding', 'HIGH_RISK', TRUE, CURRENT_TIMESTAMP()),
('AO', 'A', 'High-risk flood zone with sheet flow', 'HIGH_RISK', TRUE, CURRENT_TIMESTAMP()),
('VE', 'V', 'Coastal high-risk zone with wave action', 'HIGH_RISK', TRUE, CURRENT_TIMESTAMP()),
('X', 'X', 'Moderate to low-risk zone (500-year floodplain)', 'MODERATE_RISK', FALSE, CURRENT_TIMESTAMP()),
('B', 'B', 'Moderate-risk zone (legacy designation)', 'MODERATE_RISK', FALSE, CURRENT_TIMESTAMP()),
('C', 'C', 'Minimal flood risk zone', 'LOW_RISK', FALSE, CURRENT_TIMESTAMP()),
('D', 'D', 'Undetermined flood risk', 'UNDETERMINED', FALSE, CURRENT_TIMESTAMP());

-- ============================================================================
-- Step 4: Generate Tax Jurisdictions
-- ============================================================================
INSERT INTO TAX_JURISDICTIONS
SELECT
    'JURIS' || LPAD(SEQ4(), 6, '0') AS jurisdiction_id,
    ARRAY_CONSTRUCT('County', 'City', 'Township', 'School District', 'Water District')[UNIFORM(0, 4, RANDOM())]
        || ' of ' ||
    ARRAY_CONSTRUCT('Harris', 'Los Angeles', 'Cook', 'Maricopa', 'San Diego', 'Orange', 'Miami-Dade', 'Dallas', 'Kings', 'Queens')[UNIFORM(0, 9, RANDOM())] AS jurisdiction_name,
    ARRAY_CONSTRUCT('COUNTY', 'CITY', 'SCHOOL_DISTRICT', 'SPECIAL_DISTRICT')[UNIFORM(0, 3, RANDOM())] AS jurisdiction_type,
    ARRAY_CONSTRUCT('CA', 'TX', 'FL', 'NY', 'IL', 'PA', 'OH', 'GA', 'NC', 'MI', 'WA', 'AZ', 'MA', 'VA', 'CO')[UNIFORM(0, 14, RANDOM())] AS state,
    ARRAY_CONSTRUCT('Harris', 'Los Angeles', 'Cook', 'Maricopa', 'San Diego', 'Orange', 'Miami-Dade', 'Dallas', 'Kings', 'Queens')[UNIFORM(0, 9, RANDOM())] AS county,
    (UNIFORM(8, 35, RANDOM()) / 1000.0)::NUMBER(6,4) AS tax_rate,
    ARRAY_CONSTRUCT('ANNUAL', 'SEMI_ANNUAL', 'QUARTERLY')[UNIFORM(0, 2, RANDOM())] AS payment_schedule,
    'taxcollector@' || LOWER(ARRAY_CONSTRUCT('county', 'city', 'district')[UNIFORM(0, 2, RANDOM())]) || '.gov' AS contact_info,
    DATEADD('day', -1 * UNIFORM(365, 3650, RANDOM()), CURRENT_TIMESTAMP()) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM TABLE(GENERATOR(ROWCOUNT => 500));

-- ============================================================================
-- Step 5: Generate Clients (Financial Institutions)
-- ============================================================================
INSERT INTO CLIENTS
SELECT
    'CLI' || LPAD(SEQ4(), 8, '0') AS client_id,
    CASE 
        WHEN UNIFORM(0, 100, RANDOM()) < 15 THEN ARRAY_CONSTRUCT('Wells Fargo', 'JPMorgan Chase', 'Bank of America', 'Citibank', 'U.S. Bank')[UNIFORM(0, 4, RANDOM())] || ' ' || ARRAY_CONSTRUCT('Mortgage', 'Home Loans', 'Lending')[UNIFORM(0, 2, RANDOM())]
        WHEN UNIFORM(0, 100, RANDOM()) < 40 THEN ARRAY_CONSTRUCT('Regional', 'Community', 'First', 'National', 'State')[UNIFORM(0, 4, RANDOM())] || ' ' || ARRAY_CONSTRUCT('Bank', 'Credit Union', 'Financial', 'Mortgage')[UNIFORM(0, 3, RANDOM())]
        ELSE ARRAY_CONSTRUCT('Premier', 'Homeowners', 'Liberty', 'American', 'United')[UNIFORM(0, 4, RANDOM())] || ' ' || ARRAY_CONSTRUCT('Lending', 'Mortgage Services', 'Financial Services')[UNIFORM(0, 2, RANDOM())]
    END AS client_name,
    'contact' || SEQ4() || '@' || ARRAY_CONSTRUCT('bank', 'mortgage', 'lending', 'financial')[UNIFORM(0, 3, RANDOM())] || '.com' AS contact_email,
    CONCAT('+1-', UNIFORM(200, 999, RANDOM()), '-', UNIFORM(100, 999, RANDOM()), '-', UNIFORM(1000, 9999, RANDOM())) AS contact_phone,
    'USA' AS country,
    ARRAY_CONSTRUCT('CA', 'TX', 'FL', 'NY', 'IL', 'PA', 'OH', 'GA', 'NC', 'MI', 'WA', 'AZ', 'MA', 'VA', 'CO')[UNIFORM(0, 14, RANDOM())] AS state,
    ARRAY_CONSTRUCT('Los Angeles', 'Houston', 'Miami', 'New York', 'Chicago', 'Philadelphia', 'Phoenix', 'Seattle', 'Boston', 'Denver', 'Dallas', 'Atlanta')[UNIFORM(0, 11, RANDOM())] AS city,
    DATEADD('day', -1 * UNIFORM(30, 3650, RANDOM()), CURRENT_DATE()) AS onboarding_date,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 96 THEN 'ACTIVE'
         WHEN UNIFORM(0, 100, RANDOM()) < 3 THEN 'SUSPENDED'
         ELSE 'CLOSED' END AS client_status,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 20 THEN 'NATIONAL_SERVICER'
         WHEN UNIFORM(0, 100, RANDOM()) < 60 THEN 'REGIONAL_LENDER'
         ELSE 'CREDIT_UNION' END AS client_type,
    (UNIFORM(50000, 5000000, RANDOM()) / 1.0)::NUMBER(12,2) AS lifetime_value,
    (UNIFORM(80, 99, RANDOM()) / 1.0)::NUMBER(5,2) AS service_quality_score,
    UNIFORM(100, 50000, RANDOM()) AS total_properties,
    DATEADD('day', -1 * UNIFORM(30, 3650, RANDOM()), CURRENT_TIMESTAMP()) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM TABLE(GENERATOR(ROWCOUNT => 10000));

-- ============================================================================
-- Step 6: Generate Properties
-- ============================================================================
INSERT INTO PROPERTIES
SELECT
    'PROP' || LPAD(SEQ4(), 10, '0') AS property_id,
    UNIFORM(100, 9999, RANDOM()) || ' ' ||
    ARRAY_CONSTRUCT('Main', 'Oak', 'Maple', 'Cedar', 'Pine', 'Elm', 'Washington', 'Park', 'Lake', 'River')[UNIFORM(0, 9, RANDOM())] || ' ' ||
    ARRAY_CONSTRUCT('Street', 'Avenue', 'Drive', 'Lane', 'Road', 'Boulevard', 'Court', 'Way')[UNIFORM(0, 7, RANDOM())] AS property_address,
    ARRAY_CONSTRUCT('Los Angeles', 'Houston', 'Phoenix', 'Philadelphia', 'San Antonio', 'San Diego', 'Dallas', 'San Jose', 'Austin', 'Jacksonville', 
                    'Fort Worth', 'Columbus', 'Charlotte', 'Indianapolis', 'Seattle', 'Denver', 'Boston', 'Nashville', 'Portland', 'Las Vegas')[UNIFORM(0, 19, RANDOM())] AS property_city,
    ARRAY_CONSTRUCT('CA', 'TX', 'FL', 'NY', 'IL', 'PA', 'OH', 'GA', 'NC', 'MI', 'WA', 'AZ', 'MA', 'VA', 'CO')[UNIFORM(0, 14, RANDOM())] AS property_state,
    LPAD(UNIFORM(10000, 99999, RANDOM()), 5, '0') AS property_zip,
    ARRAY_CONSTRUCT('Harris', 'Los Angeles', 'Cook', 'Maricopa', 'San Diego', 'Orange', 'Miami-Dade', 'Dallas', 'Kings', 'Queens')[UNIFORM(0, 9, RANDOM())] || ' County' AS county,
    ARRAY_CONSTRUCT('SINGLE_FAMILY', 'CONDO', 'TOWNHOUSE', 'MULTI_FAMILY', 'MOBILE_HOME')[UNIFORM(0, 4, RANDOM())] AS property_type,
    LPAD(UNIFORM(1000000, 9999999, RANDOM()), 8, '0') AS parcel_number,
    (UNIFORM(150000, 1500000, RANDOM()) / 1.0)::NUMBER(15,2) AS assessed_value,
    ARRAY_CONSTRUCT('X', 'X', 'X', 'X', 'AE', 'A', 'C', 'B')[UNIFORM(0, 7, RANDOM())] AS flood_zone,
    DATEADD('day', -1 * UNIFORM(30, 3650, RANDOM()), CURRENT_DATE()) AS first_monitored_date,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 94 THEN 'ACTIVE'
         WHEN UNIFORM(0, 100, RANDOM()) < 4 THEN 'SOLD'
         ELSE 'FORECLOSED' END AS property_status,
    DATEADD('day', -1 * UNIFORM(30, 3650, RANDOM()), CURRENT_TIMESTAMP()) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM TABLE(GENERATOR(ROWCOUNT => 500000));

-- ============================================================================
-- Step 7: Generate Loans
-- ============================================================================
INSERT INTO LOANS
SELECT
    'LOAN' || LPAD(SEQ4(), 10, '0') AS loan_id,
    c.client_id,
    p.property_id,
    'LN' || UNIFORM(100000000, 999999999, RANDOM()) AS loan_number,
    ARRAY_CONSTRUCT('CONVENTIONAL', 'FHA', 'VA', 'JUMBO', 'USDA')[UNIFORM(0, 4, RANDOM())] AS loan_type,
    (UNIFORM(100000, 1200000, RANDOM()) / 1.0)::NUMBER(15,2) AS loan_amount,
    DATEADD('day', -1 * UNIFORM(30, 3650, RANDOM()), CURRENT_DATE()) AS loan_date,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 92 THEN 'ACTIVE'
         WHEN UNIFORM(0, 100, RANDOM()) < 5 THEN 'PAID_OFF'
         WHEN UNIFORM(0, 100, RANDOM()) < 2 THEN 'FORECLOSED'
         ELSE 'SOLD' END AS loan_status,
    ARRAY_CONSTRUCT('John', 'Jane', 'Michael', 'Sarah', 'David', 'Emily', 'Robert', 'Lisa', 'James', 'Mary')[UNIFORM(0, 9, RANDOM())]
        || ' ' ||
    ARRAY_CONSTRUCT('Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis', 'Rodriguez', 'Martinez')[UNIFORM(0, 9, RANDOM())] AS borrower_name,
    'SVC' || UNIFORM(100000000, 999999999, RANDOM()) AS servicer_loan_number,
    UNIFORM(0, 100, RANDOM()) < 95 AS tax_monitoring_required,
    UNIFORM(0, 100, RANDOM()) < 90 AS flood_monitoring_required,
    UNIFORM(0, 100, RANDOM()) < 85 AS escrow_account,
    DATEADD('year', 30, DATEADD('day', -1 * UNIFORM(30, 3650, RANDOM()), CURRENT_DATE())) AS maturity_date,
    DATEADD('day', -1 * UNIFORM(0, 365, RANDOM()), CURRENT_DATE()) AS last_status_change,
    DATEADD('day', -1 * UNIFORM(30, 3650, RANDOM()), CURRENT_TIMESTAMP()) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM CLIENTS c
CROSS JOIN TABLE(GENERATOR(ROWCOUNT => 100))
JOIN PROPERTIES p ON UNIFORM(1, 100, RANDOM()) <= 100
WHERE UNIFORM(0, 100, RANDOM()) < 8
LIMIT 750000;

-- ============================================================================
-- Step 8: Generate Service Subscriptions
-- ============================================================================
INSERT INTO SERVICE_SUBSCRIPTIONS
SELECT
    'SUB' || LPAD(SEQ4(), 10, '0') AS subscription_id,
    c.client_id,
    ARRAY_CONSTRUCT('TAX_ONLY', 'FLOOD_ONLY', 'TAX_AND_FLOOD', 'FULL_SUITE')[UNIFORM(0, 3, RANDOM())] AS service_type,
    ARRAY_CONSTRUCT('BASIC', 'PROFESSIONAL', 'ENTERPRISE')[UNIFORM(0, 2, RANDOM())] AS subscription_tier,
    c.onboarding_date AS start_date,
    DATEADD('year', UNIFORM(1, 3, RANDOM()), c.onboarding_date) AS end_date,
    ARRAY_CONSTRUCT('MONTHLY', 'ANNUAL')[UNIFORM(0, 1, RANDOM())] AS billing_cycle,
    (UNIFORM(1000, 50000, RANDOM()) / 1.0)::NUMBER(10,2) AS monthly_price,
    UNIFORM(100, 50000, RANDOM()) AS property_count_limit,
    UNIFORM(5, 100, RANDOM()) AS user_licenses,
    UNIFORM(10000, 1000000, RANDOM()) AS api_call_limit,
    UNIFORM(0, 100, RANDOM()) < 70 AS advanced_analytics,
    CASE WHEN DATEADD('year', UNIFORM(1, 3, RANDOM()), c.onboarding_date) > CURRENT_DATE() THEN 'ACTIVE'
         ELSE ARRAY_CONSTRUCT('EXPIRED', 'PENDING_RENEWAL')[UNIFORM(0, 1, RANDOM())] END AS subscription_status,
    c.created_at AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM CLIENTS c
WHERE UNIFORM(0, 100, RANDOM()) < 95;

-- ============================================================================
-- Step 9: Generate Tax Records
-- ============================================================================
INSERT INTO TAX_RECORDS
SELECT
    'TAX' || LPAD(SEQ4(), 12, '0') AS tax_record_id,
    l.property_id,
    l.loan_id,
    l.client_id,
    (SELECT jurisdiction_id FROM TAX_JURISDICTIONS ORDER BY RANDOM() LIMIT 1) AS jurisdiction_id,
    YEAR(CURRENT_DATE()) - UNIFORM(0, 2, RANDOM()) AS tax_year,
    p.assessed_value AS assessed_value,
    (p.assessed_value * UNIFORM(80, 350, RANDOM()) / 10000.0)::NUMBER(12,2) AS tax_amount,
    ARRAY_CONSTRUCT('PAID', 'PAID', 'PAID', 'PENDING', 'DELINQUENT')[UNIFORM(0, 4, RANDOM())] AS payment_status,
    DATEADD('month', UNIFORM(1, 12, RANDOM()), DATE_FROM_PARTS(YEAR(CURRENT_DATE()) - UNIFORM(0, 2, RANDOM()), 1, 1)) AS due_date,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 80 THEN DATEADD('day', -UNIFORM(0, 60, RANDOM()), CURRENT_DATE()) ELSE NULL END AS payment_date,
    UNIFORM(0, 100, RANDOM()) < 8 AS delinquent,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 8 THEN DATEADD('day', UNIFORM(30, 180, RANDOM()), DATEADD('month', UNIFORM(1, 12, RANDOM()), DATE_FROM_PARTS(YEAR(CURRENT_DATE()) - UNIFORM(0, 2, RANDOM()), 1, 1))) ELSE NULL END AS delinquency_date,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 8 THEN (UNIFORM(50, 500, RANDOM()) / 1.0)::NUMBER(10,2) ELSE 0.00 END AS penalty_amount,
    DATEADD('day', -UNIFORM(30, 730, RANDOM()), CURRENT_TIMESTAMP()) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM LOANS l
JOIN PROPERTIES p ON l.property_id = p.property_id
WHERE l.tax_monitoring_required = TRUE
  AND UNIFORM(0, 100, RANDOM()) < 80
LIMIT 2000000;

-- ============================================================================
-- Step 10: Generate Flood Certifications
-- ============================================================================
INSERT INTO FLOOD_CERTIFICATIONS
SELECT
    'FLOOD' || LPAD(SEQ4(), 10, '0') AS certification_id,
    l.property_id,
    l.loan_id,
    l.client_id,
    l.loan_date AS certification_date,
    p.flood_zone AS flood_zone,
    ARRAY_CONSTRUCT('STANDARD', 'LIFE_OF_LOAN', 'MANUAL_REVIEW')[UNIFORM(0, 2, RANDOM())] AS determination_method,
    LPAD(UNIFORM(100000, 999999, RANDOM()), 6, '0') || LPAD(UNIFORM(1000, 9999, RANDOM()), 4, '0') || 'K' AS panel_number,
    DATEADD('year', -UNIFORM(0, 10, RANDOM()), l.loan_date) AS map_date,
    'ACTIVE' AS certification_status,
    p.flood_zone IN ('AE', 'A', 'AH', 'AO', 'VE', 'V') AS insurance_required,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 15 THEN DATEADD('year', 5, l.loan_date) ELSE NULL END AS expiration_date,
    UNIFORM(0, 100, RANDOM()) < 90 AS life_of_loan_tracking,
    DATEADD('day', -UNIFORM(0, 365, RANDOM()), CURRENT_TIMESTAMP()) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM LOANS l
JOIN PROPERTIES p ON l.property_id = p.property_id
WHERE l.flood_monitoring_required = TRUE
  AND UNIFORM(0, 100, RANDOM()) < 70
LIMIT 500000;

-- ============================================================================
-- Step 11: Generate Transactions
-- ============================================================================
INSERT INTO TRANSACTIONS
SELECT
    'TXN' || LPAD(SEQ4(), 12, '0') AS transaction_id,
    c.client_id,
    DATEADD('day', UNIFORM(0, 1095, RANDOM()), c.onboarding_date) AS transaction_date,
    ARRAY_CONSTRUCT('SERVICE_FEE', 'SUBSCRIPTION_PAYMENT', 'SETUP_FEE', 'ONE_TIME_SERVICE')[UNIFORM(0, 3, RANDOM())] AS transaction_type,
    ARRAY_CONSTRUCT('TAX_MONITORING', 'FLOOD_CERTIFICATION', 'COMPLIANCE_REPORTING', 'FULL_SUITE')[UNIFORM(0, 3, RANDOM())] AS product_type,
    (SELECT product_id FROM PRODUCTS ORDER BY RANDOM() LIMIT 1) AS product_id,
    (UNIFORM(50, 10000, RANDOM()) / 1.0)::NUMBER(12,2) AS amount,
    'USD' AS currency,
    ARRAY_CONSTRUCT('ACH', 'WIRE', 'CHECK', 'CREDIT_CARD')[UNIFORM(0, 3, RANDOM())] AS payment_method,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 98 THEN 'COMPLETED'
         ELSE ARRAY_CONSTRUCT('PENDING', 'FAILED')[UNIFORM(0, 1, RANDOM())] END AS payment_status,
    (UNIFORM(0, 500, RANDOM()) / 1.0)::NUMBER(10,2) AS discount_amount,
    (UNIFORM(0, 100, RANDOM()) / 1.0)::NUMBER(10,2) AS tax_amount,
    (UNIFORM(50, 10000, RANDOM()) / 1.0)::NUMBER(12,2) AS total_amount,
    DATEADD('day', UNIFORM(0, 1095, RANDOM()), c.onboarding_date) AS created_at
FROM CLIENTS c
CROSS JOIN TABLE(GENERATOR(ROWCOUNT => 200))
WHERE UNIFORM(0, 100, RANDOM()) < 15
LIMIT 1500000;

-- ============================================================================
-- Step 12: Generate Support Tickets
-- ============================================================================
INSERT INTO SUPPORT_TICKETS
SELECT
    'TKT' || LPAD(SEQ4(), 10, '0') AS ticket_id,
    c.client_id,
    ARRAY_CONSTRUCT(
        'Tax payment not showing in system',
        'Flood certification delay',
        'Need property tax certificate',
        'Escrow account discrepancy',
        'Tax delinquency alert question',
        'Flood map change notification',
        'API integration issue',
        'Report access problem',
        'Billing question',
        'Account setup assistance'
    )[UNIFORM(0, 9, RANDOM())] AS subject,
    ARRAY_CONSTRUCT('TAX_MONITORING', 'FLOOD_CERTIFICATION', 'BILLING', 'TECHNICAL', 'COMPLIANCE', 'ACCOUNT_MANAGEMENT')[UNIFORM(0, 5, RANDOM())] AS issue_type,
    ARRAY_CONSTRUCT('LOW', 'MEDIUM', 'HIGH', 'URGENT')[UNIFORM(0, 3, RANDOM())] AS priority,
    ARRAY_CONSTRUCT('OPEN', 'IN_PROGRESS', 'RESOLVED', 'CLOSED')[UNIFORM(0, 3, RANDOM())] AS ticket_status,
    ARRAY_CONSTRUCT('EMAIL', 'PHONE', 'PORTAL', 'CHAT')[UNIFORM(0, 3, RANDOM())] AS channel,
    (SELECT agent_id FROM SUPPORT_AGENTS ORDER BY RANDOM() LIMIT 1) AS assigned_agent_id,
    DATEADD('day', -UNIFORM(0, 730, RANDOM()), CURRENT_TIMESTAMP()) AS created_date,
    DATEADD('hour', UNIFORM(1, 48, RANDOM()), DATEADD('day', -UNIFORM(0, 730, RANDOM()), CURRENT_TIMESTAMP())) AS first_response_date,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 85 THEN DATEADD('hour', UNIFORM(2, 120, RANDOM()), DATEADD('day', -UNIFORM(0, 730, RANDOM()), CURRENT_TIMESTAMP())) ELSE NULL END AS resolved_date,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 80 THEN DATEADD('hour', UNIFORM(4, 168, RANDOM()), DATEADD('day', -UNIFORM(0, 730, RANDOM()), CURRENT_TIMESTAMP())) ELSE NULL END AS closed_date,
    (UNIFORM(1, 120, RANDOM()) / 1.0)::NUMBER(10,2) AS resolution_time_hours,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 70 THEN UNIFORM(3, 5, RANDOM()) ELSE NULL END AS satisfaction_rating,
    DATEADD('day', -UNIFORM(0, 730, RANDOM()), CURRENT_TIMESTAMP()) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM CLIENTS c
CROSS JOIN TABLE(GENERATOR(ROWCOUNT => 10))
WHERE UNIFORM(0, 100, RANDOM()) < 75
LIMIT 75000;

-- ============================================================================
-- Step 13: Generate Marketing Campaigns
-- ============================================================================
INSERT INTO MARKETING_CAMPAIGNS VALUES
('CAMP001', 'Total Tax Solutions Promotion', 'PRODUCT_LAUNCH', '2024-01-01', '2024-12-31', 'REGIONAL_LENDERS', 100000, 'DIGITAL', 'ACTIVE', CURRENT_TIMESTAMP()),
('CAMP002', 'Flood Compliance Automation', 'AWARENESS', '2024-03-01', '2024-09-30', 'ALL_CLIENTS', 75000, 'EMAIL', 'ACTIVE', CURRENT_TIMESTAMP()),
('CAMP003', 'End of Year Tax Service Sale', 'SEASONAL', '2024-11-01', '2024-12-31', 'PROSPECTS', 50000, 'MULTI_CHANNEL', 'ACTIVE', CURRENT_TIMESTAMP()),
('CAMP004', 'API Integration Workshop', 'EDUCATION', '2024-02-01', '2024-12-31', 'NATIONAL_SERVICERS', 40000, 'WEBINAR', 'ACTIVE', CURRENT_TIMESTAMP()),
('CAMP005', 'New Client Onboarding Excellence', 'ONBOARDING', '2024-01-01', '2024-12-31', 'NEW_CLIENTS', 30000, 'EMAIL', 'ACTIVE', CURRENT_TIMESTAMP());

-- ============================================================================
-- Step 14: Generate Client Campaign Interactions
-- ============================================================================
INSERT INTO CLIENT_CAMPAIGN_INTERACTIONS
SELECT
    'INT' || LPAD(SEQ4(), 10, '0') AS interaction_id,
    c.client_id,
    mc.campaign_id,
    DATEADD('day', UNIFORM(0, 300, RANDOM()), mc.start_date) AS interaction_date,
    ARRAY_CONSTRUCT('EMAIL_OPEN', 'CLICK', 'WEBINAR_ATTEND', 'DEMO_REQUEST', 'PURCHASE', 'DOWNLOAD')[UNIFORM(0, 5, RANDOM())] AS interaction_type,
    UNIFORM(0, 100, RANDOM()) < 15 AS conversion_flag,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 15 THEN (UNIFORM(500, 50000, RANDOM()) / 1.0)::NUMBER(12,2) ELSE 0.00 END AS revenue_generated,
    DATEADD('day', UNIFORM(0, 300, RANDOM()), mc.start_date) AS created_at
FROM CLIENTS c
CROSS JOIN MARKETING_CAMPAIGNS mc
WHERE UNIFORM(0, 100, RANDOM()) < 8;

-- ============================================================================
-- Data Generation Complete
-- ============================================================================
SELECT 'Synthetic data generation completed successfully' AS status,
       (SELECT COUNT(*) FROM CLIENTS) AS clients,
       (SELECT COUNT(*) FROM PROPERTIES) AS properties,
       (SELECT COUNT(*) FROM LOANS) AS loans,
       (SELECT COUNT(*) FROM TAX_RECORDS) AS tax_records,
       (SELECT COUNT(*) FROM FLOOD_CERTIFICATIONS) AS flood_certifications,
       (SELECT COUNT(*) FROM SERVICE_SUBSCRIPTIONS) AS subscriptions,
       (SELECT COUNT(*) FROM TRANSACTIONS) AS transactions,
       (SELECT COUNT(*) FROM SUPPORT_TICKETS) AS support_tickets;

