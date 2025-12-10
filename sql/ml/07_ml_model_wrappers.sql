-- ============================================================================
-- Lereta ML Model Functions
-- ============================================================================
-- Creates SQL UDF wrappers for ML model inference
-- These functions are called by the Intelligence Agent
-- Execution time: <10 seconds per function call
-- ============================================================================

USE DATABASE LERETA_INTELLIGENCE;
USE SCHEMA ML_MODELS;
USE WAREHOUSE LERETA_WH;

-- ============================================================================
-- Function 1: Predict Tax Delinquency Risk
-- ============================================================================
-- Returns: Summary string with risk distribution
-- Input: property_state_filter (CA, TX, FL, etc., or NULL for all)
-- Analyzes 100 properties from portfolio

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
                property_type, assessed_value, flood_zone, tax_amount, tax_rate,
                jurisdiction_type, penalty_amount, days_since_due, days_since_last_payment,
                loan_type, loan_amount, escrow_account, loan_status, client_type,
                service_quality_score, client_status, has_unpaid_taxes, current_paid_status
            ) as pred
        FROM LERETA_INTELLIGENCE.ANALYTICS.V_TAX_DELINQUENCY_FEATURES f
        JOIN LERETA_INTELLIGENCE.RAW.PROPERTIES p ON f.tax_record_id = p.property_id
        WHERE property_state_filter IS NULL OR p.property_state = property_state_filter
        LIMIT 100
    )
$$;

-- ============================================================================
-- Function 2: Predict Client Churn Risk
-- ============================================================================
-- Returns: Summary string with churn status distribution
-- Input: client_type_filter (NATIONAL_SERVICER, REGIONAL_LENDER, CREDIT_UNION, or NULL)
-- Analyzes 100 clients

CREATE OR REPLACE FUNCTION PREDICT_CLIENT_CHURN_RISK(client_type_filter VARCHAR)
RETURNS VARCHAR
AS
$$
    SELECT 
        'Total Clients: ' || COUNT(*) ||
        ', Active: ' || SUM(CASE WHEN pred:PREDICTED_STATUS = 'ACTIVE' THEN 1 ELSE 0 END) ||
        ', At Risk: ' || SUM(CASE WHEN pred:PREDICTED_STATUS IN ('EXPIRED', 'PENDING_RENEWAL') THEN 1 ELSE 0 END)
    FROM (
        SELECT 
            CLIENT_CHURN_PREDICTOR!PREDICT(
                client_type, service_quality_score, total_properties, lifetime_value,
                months_as_client, service_type, subscription_tier, billing_cycle,
                monthly_price, property_count_limit, user_licenses, advanced_analytics,
                subscription_duration_days, total_support_tickets, avg_satisfaction_rating,
                avg_resolution_time, open_tickets, total_transactions, total_revenue,
                avg_transaction_amount
            ) as pred
        FROM LERETA_INTELLIGENCE.ANALYTICS.V_CLIENT_CHURN_FEATURES
        WHERE client_type_filter IS NULL OR client_type = client_type_filter
        LIMIT 100
    )
$$;

-- ============================================================================
-- Function 3: Classify Loan Risk
-- ============================================================================
-- Returns: Summary string with risk level distribution
-- Input: loan_type_filter (CONVENTIONAL, FHA, VA, JUMBO, USDA, or NULL)
-- Analyzes 100 loans

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
                loan_type, loan_amount, loan_status, escrow_account, loan_age_months,
                loan_to_value_ratio, property_type, assessed_value, flood_zone,
                property_state, insurance_required, life_of_loan_tracking, high_flood_risk,
                tax_amount, delinquent, penalty_amount, tax_rate, jurisdiction_type,
                tax_paid_on_time, days_payment_delay, client_type, service_quality_score
            ) as pred
        FROM LERETA_INTELLIGENCE.ANALYTICS.V_LOAN_RISK_FEATURES
        WHERE loan_type_filter IS NULL OR loan_type = loan_type_filter
        LIMIT 100
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
-- Next Step: Run sql/agent/08_create_ai_agent.sql
-- ============================================================================
