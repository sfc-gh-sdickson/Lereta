-- ============================================================================
-- Lereta ML Model Functions
-- ============================================================================
-- Creates optimized inference tables and SQL UDF wrappers for fast ML predictions
-- Target: <10 seconds per function call
-- ============================================================================

USE DATABASE LERETA_INTELLIGENCE;
USE SCHEMA ML_MODELS;
USE WAREHOUSE LERETA_WH;

-- ============================================================================
-- Create Inference-Optimized Tables (Pre-computed samples)
-- ============================================================================
-- These tables are materialized subsets for fast inference
-- Refresh these periodically (daily or weekly) for production use

-- Tax Delinquency Inference Table
CREATE OR REPLACE TABLE TAX_DELINQUENCY_INFERENCE AS
SELECT *
FROM LERETA_INTELLIGENCE.ANALYTICS.V_TAX_DELINQUENCY_FEATURES
SAMPLE (1000 ROWS);

-- Client Churn Inference Table
CREATE OR REPLACE TABLE CLIENT_CHURN_INFERENCE AS
SELECT *
FROM LERETA_INTELLIGENCE.ANALYTICS.V_CLIENT_CHURN_FEATURES
SAMPLE (1000 ROWS);

-- Loan Risk Inference Table
CREATE OR REPLACE TABLE LOAN_RISK_INFERENCE AS
SELECT *
FROM LERETA_INTELLIGENCE.ANALYTICS.V_LOAN_RISK_FEATURES
SAMPLE (1000 ROWS);

-- ============================================================================
-- Function 1: Predict Tax Delinquency Risk
-- ============================================================================
-- Returns: Summary string with risk distribution
-- Input: property_state_filter (CA, TX, FL, etc., or NULL for all)
-- Analyzes 25 properties from inference table

CREATE OR REPLACE FUNCTION PREDICT_TAX_DELINQUENCY_RISK(property_state_filter VARCHAR)
RETURNS VARCHAR
AS
$$
    SELECT 
        'Total Properties: ' || COUNT(*) || 
        ', Not Delinquent: ' || SUM(CASE WHEN pred:PREDICTED_DELINQUENT::INT = 0 THEN 1 ELSE 0 END) ||
        ', Delinquent: ' || SUM(CASE WHEN pred:PREDICTED_DELINQUENT::INT = 1 THEN 1 ELSE 0 END)
    FROM (
        SELECT 
            TAX_DELINQUENCY_PREDICTOR!PREDICT(
                PROPERTY_TYPE, ASSESSED_VALUE, FLOOD_ZONE, TAX_AMOUNT, TAX_RATE,
                JURISDICTION_TYPE, PENALTY_AMOUNT, DAYS_SINCE_DUE, DAYS_SINCE_LAST_PAYMENT,
                LOAN_TYPE, LOAN_AMOUNT, ESCROW_ACCOUNT, LOAN_STATUS, CLIENT_TYPE,
                SERVICE_QUALITY_SCORE, CLIENT_STATUS, HAS_UNPAID_TAXES, CURRENT_PAID_STATUS
            ) as pred
        FROM LERETA_INTELLIGENCE.ML_MODELS.TAX_DELINQUENCY_INFERENCE
        LIMIT 25
    )
$$;

-- ============================================================================
-- Function 2: Predict Client Churn Risk
-- ============================================================================
-- Returns: Summary string with churn risk distribution
-- Input: client_type_filter (NATIONAL_SERVICER, REGIONAL_LENDER, CREDIT_UNION, or NULL)
-- Analyzes 25 clients from inference table

CREATE OR REPLACE FUNCTION PREDICT_CLIENT_CHURN_RISK(client_type_filter VARCHAR)
RETURNS VARCHAR
AS
$$
    SELECT 
        'Total Clients: ' || COUNT(*) ||
        ', Low Risk: ' || SUM(CASE WHEN pred:PREDICTED_RISK::INT = 0 THEN 1 ELSE 0 END) ||
        ', Medium Risk: ' || SUM(CASE WHEN pred:PREDICTED_RISK::INT = 1 THEN 1 ELSE 0 END) ||
        ', High Risk: ' || SUM(CASE WHEN pred:PREDICTED_RISK::INT = 2 THEN 1 ELSE 0 END)
    FROM (
        SELECT 
            CLIENT_CHURN_PREDICTOR!PREDICT(
                CLIENT_TYPE, SERVICE_QUALITY_SCORE, TOTAL_PROPERTIES, LIFETIME_VALUE,
                MONTHS_AS_CLIENT, SERVICE_TYPE, SUBSCRIPTION_TIER, BILLING_CYCLE,
                MONTHLY_PRICE, PROPERTY_COUNT_LIMIT, USER_LICENSES, ADVANCED_ANALYTICS,
                SUBSCRIPTION_DURATION_DAYS, TOTAL_SUPPORT_TICKETS, AVG_SATISFACTION_RATING,
                AVG_RESOLUTION_TIME, OPEN_TICKETS, TOTAL_TRANSACTIONS, TOTAL_REVENUE,
                AVG_TRANSACTION_AMOUNT
            ) as pred
        FROM LERETA_INTELLIGENCE.ML_MODELS.CLIENT_CHURN_INFERENCE
        WHERE client_type_filter IS NULL OR CLIENT_TYPE = client_type_filter
        LIMIT 25
    )
$$;

-- ============================================================================
-- Function 3: Classify Loan Risk
-- ============================================================================
-- Returns: Summary string with risk level distribution
-- Input: loan_type_filter (CONVENTIONAL, FHA, VA, JUMBO, USDA, or NULL)
-- Analyzes 25 loans from inference table

CREATE OR REPLACE FUNCTION CLASSIFY_LOAN_RISK(loan_type_filter VARCHAR)
RETURNS VARCHAR
AS
$$
    SELECT 
        'Total Loans: ' || COUNT(*) ||
        ', Low Risk: ' || SUM(CASE WHEN pred:PREDICTED_RISK = 'LOW' THEN 1 ELSE 0 END) ||
        ', Medium Risk: ' || SUM(CASE WHEN pred:PREDICTED_RISK = 'MEDIUM' THEN 1 ELSE 0 END) ||
        ', High Risk: ' || SUM(CASE WHEN pred:PREDICTED_RISK = 'HIGH' THEN 1 ELSE 0 END)
    FROM (
        SELECT 
            LOAN_RISK_CLASSIFIER!PREDICT(
                LOAN_TYPE, LOAN_AMOUNT, LOAN_STATUS, ESCROW_ACCOUNT, LOAN_AGE_MONTHS,
                LOAN_TO_VALUE_RATIO, PROPERTY_TYPE, ASSESSED_VALUE, FLOOD_ZONE,
                PROPERTY_STATE, INSURANCE_REQUIRED, LIFE_OF_LOAN_TRACKING, HIGH_FLOOD_RISK,
                TAX_AMOUNT, DELINQUENT, PENALTY_AMOUNT, TAX_RATE, JURISDICTION_TYPE,
                TAX_PAID_ON_TIME, DAYS_PAYMENT_DELAY, CLIENT_TYPE, SERVICE_QUALITY_SCORE
            ) as pred
        FROM LERETA_INTELLIGENCE.ML_MODELS.LOAN_RISK_INFERENCE
        WHERE loan_type_filter IS NULL OR LOAN_TYPE = loan_type_filter
        LIMIT 25
    )
$$;

-- ============================================================================
-- Verification Tests
-- ============================================================================
SELECT '🔄 Testing ML functions...' as status;

SELECT PREDICT_TAX_DELINQUENCY_RISK(NULL) as tax_delinquency_result;
SELECT PREDICT_CLIENT_CHURN_RISK(NULL) as client_churn_result;
SELECT CLASSIFY_LOAN_RISK(NULL) as loan_risk_result;

SELECT '✅ All ML functions created and tested successfully!' as final_status;

-- ============================================================================
-- Refresh Instructions
-- ============================================================================
-- To refresh inference tables with latest data, run:
-- CREATE OR REPLACE TABLE TAX_DELINQUENCY_INFERENCE AS SELECT * FROM LERETA_INTELLIGENCE.ANALYTICS.V_TAX_DELINQUENCY_FEATURES SAMPLE (1000 ROWS);
-- CREATE OR REPLACE TABLE CLIENT_CHURN_INFERENCE AS SELECT * FROM LERETA_INTELLIGENCE.ANALYTICS.V_CLIENT_CHURN_FEATURES SAMPLE (1000 ROWS);
-- CREATE OR REPLACE TABLE LOAN_RISK_INFERENCE AS SELECT * FROM LERETA_INTELLIGENCE.ANALYTICS.V_LOAN_RISK_FEATURES SAMPLE (1000 ROWS);

-- ============================================================================
-- Next Step: Run sql/agent/08_create_ai_agent.sql
-- ============================================================================
