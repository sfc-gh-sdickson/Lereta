-- ============================================================================
-- Lereta Intelligence Agent - ML Model Wrappers
-- ============================================================================
-- Purpose: Create SQL User-Defined Functions (UDFs) to wrap ML models
--          for integration with the Lereta Intelligence Agent
-- Models:
--   1. TAX_DELINQUENCY_PREDICTOR - Predict tax delinquency risk
--   2. CLIENT_CHURN_PREDICTOR - Predict client churn risk
--   3. LOAN_RISK_CLASSIFIER - Classify loan risk level
-- ============================================================================

USE DATABASE LERETA_INTELLIGENCE;
USE SCHEMA ANALYTICS;
USE WAREHOUSE LERETA_WH;

-- ============================================================================
-- Function 1: Predict Tax Delinquency Risk
-- ============================================================================
-- This function predicts whether a property is likely to become delinquent
-- on property taxes based on historical patterns and property characteristics
-- ============================================================================

CREATE OR REPLACE FUNCTION PREDICT_TAX_DELINQUENCY(
    tax_record_id VARCHAR,
    property_type VARCHAR,
    assessed_value NUMBER,
    flood_zone VARCHAR,
    tax_amount NUMBER,
    tax_rate NUMBER,
    jurisdiction_type VARCHAR,
    penalty_amount NUMBER,
    days_since_due NUMBER,
    days_since_last_payment NUMBER,
    loan_type VARCHAR,
    loan_amount NUMBER,
    escrow_account BOOLEAN,
    loan_status VARCHAR,
    client_type VARCHAR,
    service_quality_score NUMBER,
    client_status VARCHAR,
    has_unpaid_taxes NUMBER,
    current_paid_status NUMBER
)
RETURNS OBJECT
LANGUAGE PYTHON
RUNTIME_VERSION = '3.9'
PACKAGES = ('snowflake-snowpark-python', 'snowflake-ml-python')
HANDLER = 'predict_tax_delinquency'
COMMENT = 'Predicts tax delinquency risk using the TAX_DELINQUENCY_PREDICTOR model'
AS
$$
from snowflake.ml.registry import Registry
from snowflake.snowpark import Session
import pandas as pd

def predict_tax_delinquency(session, tax_record_id, property_type, assessed_value, flood_zone,
                             tax_amount, tax_rate, jurisdiction_type, penalty_amount,
                             days_since_due, days_since_last_payment, loan_type, loan_amount,
                             escrow_account, loan_status, client_type, service_quality_score,
                             client_status, has_unpaid_taxes, current_paid_status):
    """
    Predict tax delinquency risk for a given property
    
    Returns:
        dict: {
            'prediction': 0 or 1 (0=not delinquent, 1=delinquent),
            'confidence': probability score,
            'risk_level': 'LOW', 'MEDIUM', 'HIGH'
        }
    """
    try:
        # Get the model from registry
        registry = Registry(session=session)
        model_ref = registry.get_model("TAX_DELINQUENCY_PREDICTOR").version("v1")
        model = model_ref.load_model()
        
        # Prepare input data
        input_data = pd.DataFrame({
            'PROPERTY_TYPE': [property_type],
            'ASSESSED_VALUE': [assessed_value],
            'FLOOD_ZONE': [flood_zone],
            'TAX_AMOUNT': [tax_amount],
            'TAX_RATE': [tax_rate],
            'JURISDICTION_TYPE': [jurisdiction_type],
            'PENALTY_AMOUNT': [penalty_amount],
            'DAYS_SINCE_DUE': [days_since_due],
            'DAYS_SINCE_LAST_PAYMENT': [days_since_last_payment],
            'LOAN_TYPE': [loan_type],
            'LOAN_AMOUNT': [loan_amount],
            'ESCROW_ACCOUNT': [escrow_account],
            'LOAN_STATUS': [loan_status],
            'CLIENT_TYPE': [client_type],
            'SERVICE_QUALITY_SCORE': [service_quality_score],
            'CLIENT_STATUS': [client_status],
            'HAS_UNPAID_TAXES': [has_unpaid_taxes],
            'CURRENT_PAID_STATUS': [current_paid_status]
        })
        
        # Make prediction
        prediction = model.predict(input_data)
        
        # Extract prediction value
        pred_value = int(prediction.iloc[0])
        
        # Determine risk level based on prediction and features
        if pred_value == 1:
            if penalty_amount > 500 or days_since_due > 90:
                risk_level = 'HIGH'
            else:
                risk_level = 'MEDIUM'
        else:
            risk_level = 'LOW'
        
        return {
            'tax_record_id': tax_record_id,
            'prediction': pred_value,
            'prediction_label': 'DELINQUENT' if pred_value == 1 else 'NOT_DELINQUENT',
            'risk_level': risk_level,
            'model_version': 'v1'
        }
        
    except Exception as e:
        return {
            'tax_record_id': tax_record_id,
            'error': str(e),
            'prediction': None
        }
$$;

-- ============================================================================
-- Function 2: Predict Client Churn Risk
-- ============================================================================
-- This function predicts whether a client is likely to cancel their
-- subscription based on usage patterns and satisfaction metrics
-- ============================================================================

CREATE OR REPLACE FUNCTION PREDICT_CLIENT_CHURN(
    client_id VARCHAR,
    client_type VARCHAR,
    service_quality_score NUMBER,
    total_properties NUMBER,
    lifetime_value NUMBER,
    months_as_client NUMBER,
    service_type VARCHAR,
    subscription_tier VARCHAR,
    billing_cycle VARCHAR,
    monthly_price NUMBER,
    property_count_limit NUMBER,
    user_licenses NUMBER,
    advanced_analytics BOOLEAN,
    subscription_duration_days NUMBER,
    total_support_tickets NUMBER,
    avg_satisfaction_rating NUMBER,
    avg_resolution_time NUMBER,
    open_tickets NUMBER,
    total_transactions NUMBER,
    total_revenue NUMBER,
    avg_transaction_amount NUMBER
)
RETURNS OBJECT
LANGUAGE PYTHON
RUNTIME_VERSION = '3.9'
PACKAGES = ('snowflake-snowpark-python', 'snowflake-ml-python')
HANDLER = 'predict_client_churn'
COMMENT = 'Predicts client churn risk using the CLIENT_CHURN_PREDICTOR model'
AS
$$
from snowflake.ml.registry import Registry
import pandas as pd

def predict_client_churn(session, client_id, client_type, service_quality_score, total_properties,
                          lifetime_value, months_as_client, service_type, subscription_tier,
                          billing_cycle, monthly_price, property_count_limit, user_licenses,
                          advanced_analytics, subscription_duration_days, total_support_tickets,
                          avg_satisfaction_rating, avg_resolution_time, open_tickets,
                          total_transactions, total_revenue, avg_transaction_amount):
    """
    Predict client churn risk
    
    Returns:
        dict: {
            'prediction': 0 or 1 (0=will not churn, 1=will churn),
            'churn_probability': probability score,
            'risk_level': 'LOW', 'MEDIUM', 'HIGH',
            'key_factors': list of risk factors
        }
    """
    try:
        # Get the model from registry
        registry = Registry(session=session)
        model_ref = registry.get_model("CLIENT_CHURN_PREDICTOR").version("v1")
        model = model_ref.load_model()
        
        # Prepare input data
        input_data = pd.DataFrame({
            'CLIENT_TYPE': [client_type],
            'SERVICE_QUALITY_SCORE': [service_quality_score],
            'TOTAL_PROPERTIES': [total_properties],
            'LIFETIME_VALUE': [lifetime_value],
            'MONTHS_AS_CLIENT': [months_as_client],
            'SERVICE_TYPE': [service_type],
            'SUBSCRIPTION_TIER': [subscription_tier],
            'BILLING_CYCLE': [billing_cycle],
            'MONTHLY_PRICE': [monthly_price],
            'PROPERTY_COUNT_LIMIT': [property_count_limit],
            'USER_LICENSES': [user_licenses],
            'ADVANCED_ANALYTICS': [advanced_analytics],
            'SUBSCRIPTION_DURATION_DAYS': [subscription_duration_days],
            'TOTAL_SUPPORT_TICKETS': [total_support_tickets],
            'AVG_SATISFACTION_RATING': [avg_satisfaction_rating],
            'AVG_RESOLUTION_TIME': [avg_resolution_time],
            'OPEN_TICKETS': [open_tickets],
            'TOTAL_TRANSACTIONS': [total_transactions],
            'TOTAL_REVENUE': [total_revenue],
            'AVG_TRANSACTION_AMOUNT': [avg_transaction_amount]
        })
        
        # Make prediction
        prediction = model.predict(input_data)
        pred_value = int(prediction.iloc[0])
        
        # Identify key risk factors
        risk_factors = []
        if open_tickets > 3:
            risk_factors.append('High open ticket count')
        if avg_satisfaction_rating and avg_satisfaction_rating < 3.5:
            risk_factors.append('Low satisfaction rating')
        if total_support_tickets > 10:
            risk_factors.append('High support ticket volume')
        if service_quality_score < 85:
            risk_factors.append('Low service quality score')
        
        # Determine risk level
        if pred_value == 1:
            if len(risk_factors) >= 3:
                risk_level = 'HIGH'
            else:
                risk_level = 'MEDIUM'
        else:
            risk_level = 'LOW'
        
        return {
            'client_id': client_id,
            'prediction': pred_value,
            'prediction_label': 'WILL_CHURN' if pred_value == 1 else 'WILL_NOT_CHURN',
            'risk_level': risk_level,
            'risk_factors': risk_factors,
            'model_version': 'v1'
        }
        
    except Exception as e:
        return {
            'client_id': client_id,
            'error': str(e),
            'prediction': None
        }
$$;

-- ============================================================================
-- Function 3: Classify Loan Risk
-- ============================================================================
-- This function classifies loans into risk categories (LOW/MEDIUM/HIGH)
-- based on tax compliance, flood zone risk, and property characteristics
-- ============================================================================

CREATE OR REPLACE FUNCTION CLASSIFY_LOAN_RISK(
    loan_id VARCHAR,
    loan_type VARCHAR,
    loan_amount NUMBER,
    loan_status VARCHAR,
    escrow_account BOOLEAN,
    loan_age_months NUMBER,
    loan_to_value_ratio NUMBER,
    property_type VARCHAR,
    assessed_value NUMBER,
    flood_zone VARCHAR,
    property_state VARCHAR,
    insurance_required BOOLEAN,
    life_of_loan_tracking BOOLEAN,
    high_flood_risk NUMBER,
    tax_amount NUMBER,
    delinquent BOOLEAN,
    penalty_amount NUMBER,
    tax_rate NUMBER,
    jurisdiction_type VARCHAR,
    tax_paid_on_time NUMBER,
    days_payment_delay NUMBER,
    client_type VARCHAR,
    service_quality_score NUMBER
)
RETURNS OBJECT
LANGUAGE PYTHON
RUNTIME_VERSION = '3.9'
PACKAGES = ('snowflake-snowpark-python', 'snowflake-ml-python')
HANDLER = 'classify_loan_risk'
COMMENT = 'Classifies loan risk level using the LOAN_RISK_CLASSIFIER model'
AS
$$
from snowflake.ml.registry import Registry
import pandas as pd

def classify_loan_risk(session, loan_id, loan_type, loan_amount, loan_status, escrow_account,
                       loan_age_months, loan_to_value_ratio, property_type, assessed_value,
                       flood_zone, property_state, insurance_required, life_of_loan_tracking,
                       high_flood_risk, tax_amount, delinquent, penalty_amount, tax_rate,
                       jurisdiction_type, tax_paid_on_time, days_payment_delay, client_type,
                       service_quality_score):
    """
    Classify loan risk level
    
    Returns:
        dict: {
            'risk_level': 'LOW', 'MEDIUM', 'HIGH',
            'risk_factors': list of identified risks,
            'recommendations': list of actions
        }
    """
    try:
        # Get the model from registry
        registry = Registry(session=session)
        model_ref = registry.get_model("LOAN_RISK_CLASSIFIER").version("v1")
        model = model_ref.load_model()
        
        # Prepare input data
        input_data = pd.DataFrame({
            'LOAN_TYPE': [loan_type],
            'LOAN_AMOUNT': [loan_amount],
            'LOAN_STATUS': [loan_status],
            'ESCROW_ACCOUNT': [escrow_account],
            'LOAN_AGE_MONTHS': [loan_age_months],
            'LOAN_TO_VALUE_RATIO': [loan_to_value_ratio],
            'PROPERTY_TYPE': [property_type],
            'ASSESSED_VALUE': [assessed_value],
            'FLOOD_ZONE': [flood_zone],
            'PROPERTY_STATE': [property_state],
            'INSURANCE_REQUIRED': [insurance_required],
            'LIFE_OF_LOAN_TRACKING': [life_of_loan_tracking],
            'HIGH_FLOOD_RISK': [high_flood_risk],
            'TAX_AMOUNT': [tax_amount],
            'DELINQUENT': [delinquent],
            'PENALTY_AMOUNT': [penalty_amount],
            'TAX_RATE': [tax_rate],
            'JURISDICTION_TYPE': [jurisdiction_type],
            'TAX_PAID_ON_TIME': [tax_paid_on_time],
            'DAYS_PAYMENT_DELAY': [days_payment_delay],
            'CLIENT_TYPE': [client_type],
            'SERVICE_QUALITY_SCORE': [service_quality_score]
        })
        
        # Make prediction
        prediction = model.predict(input_data)
        risk_level = str(prediction.iloc[0])
        
        # Identify risk factors
        risk_factors = []
        if high_flood_risk == 1:
            risk_factors.append('High flood risk zone')
        if delinquent:
            risk_factors.append('Tax delinquency')
        if not escrow_account:
            risk_factors.append('No escrow account')
        if loan_to_value_ratio > 0.9:
            risk_factors.append('High LTV ratio')
        if insurance_required and not life_of_loan_tracking:
            risk_factors.append('Missing life-of-loan tracking')
        
        # Generate recommendations
        recommendations = []
        if risk_level in ['HIGH', 'MEDIUM']:
            if delinquent:
                recommendations.append('Contact borrower about delinquent taxes')
            if high_flood_risk == 1 and not insurance_required:
                recommendations.append('Verify flood insurance requirement')
            if not escrow_account:
                recommendations.append('Consider establishing escrow account')
            if not life_of_loan_tracking:
                recommendations.append('Enable life-of-loan flood tracking')
        
        return {
            'loan_id': loan_id,
            'risk_level': risk_level,
            'risk_factors': risk_factors,
            'recommendations': recommendations,
            'model_version': 'v1'
        }
        
    except Exception as e:
        return {
            'loan_id': loan_id,
            'error': str(e),
            'risk_level': 'UNKNOWN'
        }
$$;

-- ============================================================================
-- Helper Views: Pre-computed Model Input Features
-- ============================================================================
-- These views prepare the data in the format needed by the ML model functions
-- ============================================================================

-- View for Tax Delinquency Prediction Features
CREATE OR REPLACE VIEW V_TAX_DELINQUENCY_FEATURES AS
SELECT 
    t.tax_record_id,
    t.delinquent AS actual_delinquent,
    p.property_type,
    p.assessed_value,
    p.flood_zone,
    t.tax_amount,
    tj.tax_rate,
    tj.jurisdiction_type,
    t.penalty_amount,
    DATEDIFF('day', t.due_date, CURRENT_DATE()) AS days_since_due,
    DATEDIFF('day', COALESCE(t.payment_date, CURRENT_DATE()), CURRENT_DATE()) AS days_since_last_payment,
    l.loan_type,
    l.loan_amount,
    l.escrow_account,
    l.loan_status,
    c.client_type,
    c.service_quality_score,
    c.client_status,
    CASE WHEN t.payment_date IS NULL THEN 1 ELSE 0 END AS has_unpaid_taxes,
    CASE WHEN t.payment_status = 'PAID' THEN 1 ELSE 0 END AS current_paid_status
FROM RAW.TAX_RECORDS t
JOIN RAW.PROPERTIES p ON t.property_id = p.property_id
JOIN RAW.LOANS l ON t.loan_id = l.loan_id
JOIN RAW.CLIENTS c ON t.client_id = c.client_id
JOIN RAW.TAX_JURISDICTIONS tj ON t.jurisdiction_id = tj.jurisdiction_id
WHERE p.property_status = 'ACTIVE'
    AND l.loan_status = 'ACTIVE';

-- View for Client Churn Prediction Features
CREATE OR REPLACE VIEW V_CLIENT_CHURN_FEATURES AS
WITH client_metrics AS (
    SELECT 
        c.client_id,
        c.client_type,
        c.service_quality_score,
        c.total_properties,
        c.lifetime_value,
        DATEDIFF('month', c.onboarding_date, CURRENT_DATE()) AS months_as_client,
        s.service_type,
        s.subscription_tier,
        s.billing_cycle,
        s.monthly_price,
        s.property_count_limit,
        s.user_licenses,
        s.advanced_analytics,
        s.subscription_status,
        DATEDIFF('day', s.start_date, COALESCE(s.end_date, CURRENT_DATE())) AS subscription_duration_days,
        COUNT(DISTINCT st.ticket_id) AS total_support_tickets,
        AVG(st.satisfaction_rating) AS avg_satisfaction_rating,
        AVG(st.resolution_time_hours) AS avg_resolution_time,
        SUM(CASE WHEN st.ticket_status = 'OPEN' THEN 1 ELSE 0 END) AS open_tickets,
        COUNT(DISTINCT t.transaction_id) AS total_transactions,
        SUM(t.total_amount) AS total_revenue,
        AVG(t.total_amount) AS avg_transaction_amount
    FROM RAW.CLIENTS c
    LEFT JOIN RAW.SERVICE_SUBSCRIPTIONS s ON c.client_id = s.client_id
    LEFT JOIN RAW.SUPPORT_TICKETS st ON c.client_id = st.client_id
    LEFT JOIN RAW.TRANSACTIONS t ON c.client_id = t.client_id
    WHERE c.client_status IN ('ACTIVE', 'SUSPENDED')
        AND s.subscription_id IS NOT NULL
    GROUP BY ALL
)
SELECT * FROM client_metrics;

-- View for Loan Risk Classification Features
CREATE OR REPLACE VIEW V_LOAN_RISK_FEATURES AS
SELECT 
    l.loan_id,
    l.loan_type,
    l.loan_amount,
    l.loan_status,
    l.escrow_account,
    DATEDIFF('month', l.loan_date, CURRENT_DATE()) AS loan_age_months,
    (l.loan_amount / NULLIF(p.assessed_value, 0))::DOUBLE AS loan_to_value_ratio,
    p.property_type,
    p.assessed_value,
    p.flood_zone,
    p.property_state,
    fc.insurance_required,
    fc.life_of_loan_tracking,
    CASE WHEN fz.risk_level = 'HIGH_RISK' THEN 1 ELSE 0 END AS high_flood_risk,
    t.tax_amount,
    t.delinquent,
    t.penalty_amount,
    tj.tax_rate,
    tj.jurisdiction_type,
    CASE WHEN t.payment_status = 'PAID' THEN 1 ELSE 0 END AS tax_paid_on_time,
    DATEDIFF('day', t.due_date, COALESCE(t.payment_date, CURRENT_DATE())) AS days_payment_delay,
    c.client_type,
    c.service_quality_score
FROM RAW.LOANS l
JOIN RAW.PROPERTIES p ON l.property_id = p.property_id
LEFT JOIN RAW.FLOOD_CERTIFICATIONS fc ON l.loan_id = fc.loan_id
LEFT JOIN RAW.FLOOD_ZONES fz ON p.flood_zone = fz.zone_id
LEFT JOIN RAW.TAX_RECORDS t ON l.loan_id = t.loan_id
LEFT JOIN RAW.TAX_JURISDICTIONS tj ON t.jurisdiction_id = tj.jurisdiction_id
LEFT JOIN RAW.CLIENTS c ON l.client_id = c.client_id
WHERE l.loan_status = 'ACTIVE'
    AND p.property_status = 'ACTIVE';

-- ============================================================================
-- Test ML Functions (Sample Queries)
-- ============================================================================

-- Test Tax Delinquency Prediction
-- SELECT 
--     tax_record_id,
--     actual_delinquent,
--     PREDICT_TAX_DELINQUENCY(
--         tax_record_id, property_type, assessed_value, flood_zone,
--         tax_amount, tax_rate, jurisdiction_type, penalty_amount,
--         days_since_due, days_since_last_payment, loan_type, loan_amount,
--         escrow_account, loan_status, client_type, service_quality_score,
--         client_status, has_unpaid_taxes, current_paid_status
--     ) AS prediction
-- FROM V_TAX_DELINQUENCY_FEATURES
-- LIMIT 10;

-- Test Client Churn Prediction
-- SELECT 
--     client_id,
--     subscription_status,
--     PREDICT_CLIENT_CHURN(
--         client_id, client_type, service_quality_score, total_properties,
--         lifetime_value, months_as_client, service_type, subscription_tier,
--         billing_cycle, monthly_price, property_count_limit, user_licenses,
--         advanced_analytics, subscription_duration_days, total_support_tickets,
--         avg_satisfaction_rating, avg_resolution_time, open_tickets,
--         total_transactions, total_revenue, avg_transaction_amount
--     ) AS prediction
-- FROM V_CLIENT_CHURN_FEATURES
-- LIMIT 10;

-- Test Loan Risk Classification
-- SELECT 
--     loan_id,
--     CLASSIFY_LOAN_RISK(
--         loan_id, loan_type, loan_amount, loan_status, escrow_account,
--         loan_age_months, loan_to_value_ratio, property_type, assessed_value,
--         flood_zone, property_state, insurance_required, life_of_loan_tracking,
--         high_flood_risk, tax_amount, delinquent, penalty_amount, tax_rate,
--         jurisdiction_type, tax_paid_on_time, days_payment_delay, client_type,
--         service_quality_score
--     ) AS risk_classification
-- FROM V_LOAN_RISK_FEATURES
-- LIMIT 10;

-- ============================================================================
-- Model Wrapper Functions Created Successfully
-- ============================================================================
SELECT 'ML Model Wrapper Functions Created Successfully' AS status,
       'TAX_DELINQUENCY_PREDICTOR, CLIENT_CHURN_PREDICTOR, LOAN_RISK_CLASSIFIER' AS models,
       'All 3 UDFs and 3 helper views created' AS details;

