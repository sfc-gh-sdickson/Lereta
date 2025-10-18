-- ============================================================================
-- Lereta Intelligence Agent - Analytical Views
-- ============================================================================
-- Purpose: Create curated analytical views for tax and flood business intelligence
-- ============================================================================

USE DATABASE LERETA_INTELLIGENCE;
USE SCHEMA ANALYTICS;
USE WAREHOUSE LERETA_WH;

-- ============================================================================
-- Client 360 View
-- ============================================================================
CREATE OR REPLACE VIEW V_CLIENT_360 AS
SELECT
    c.client_id,
    c.client_name,
    c.contact_email,
    c.contact_phone,
    c.country,
    c.state,
    c.city,
    c.onboarding_date,
    c.client_status,
    c.client_type,
    c.lifetime_value,
    c.service_quality_score,
    c.total_properties,
    COUNT(DISTINCT l.loan_id) AS active_loans,
    COUNT(DISTINCT p.property_id) AS monitored_properties,
    COUNT(DISTINCT ss.subscription_id) AS total_subscriptions,
    COUNT(DISTINCT t.transaction_id) AS total_transactions,
    SUM(t.total_amount) AS total_revenue,
    COUNT(DISTINCT st.ticket_id) AS total_support_tickets,
    AVG(st.satisfaction_rating) AS avg_satisfaction_rating,
    COUNT(DISTINCT tr.tax_record_id) AS total_tax_records,
    COUNT(DISTINCT fc.certification_id) AS total_flood_certifications,
    c.created_at,
    c.updated_at
FROM RAW.CLIENTS c
LEFT JOIN RAW.LOANS l ON c.client_id = l.client_id AND l.loan_status = 'ACTIVE'
LEFT JOIN RAW.PROPERTIES p ON l.property_id = p.property_id AND p.property_status = 'ACTIVE'
LEFT JOIN RAW.SERVICE_SUBSCRIPTIONS ss ON c.client_id = ss.client_id
LEFT JOIN RAW.TRANSACTIONS t ON c.client_id = t.client_id
LEFT JOIN RAW.SUPPORT_TICKETS st ON c.client_id = st.client_id
LEFT JOIN RAW.TAX_RECORDS tr ON c.client_id = tr.client_id
LEFT JOIN RAW.FLOOD_CERTIFICATIONS fc ON c.client_id = fc.client_id
GROUP BY
    c.client_id, c.client_name, c.contact_email, c.contact_phone, 
    c.country, c.state, c.city, c.onboarding_date, c.client_status, 
    c.client_type, c.lifetime_value, c.service_quality_score, 
    c.total_properties, c.created_at, c.updated_at;

-- ============================================================================
-- Property Tax Analytics View
-- ============================================================================
CREATE OR REPLACE VIEW V_PROPERTY_TAX_ANALYTICS AS
SELECT
    p.property_id,
    p.property_address,
    p.property_city,
    p.property_state,
    p.property_zip,
    p.county,
    p.property_type,
    p.assessed_value,
    p.property_status,
    COUNT(DISTINCT l.loan_id) AS total_loans,
    COUNT(DISTINCT tr.tax_record_id) AS total_tax_records,
    COUNT(DISTINCT CASE WHEN tr.payment_status = 'PAID' THEN tr.tax_record_id END) AS paid_tax_records,
    COUNT(DISTINCT CASE WHEN tr.payment_status = 'DELINQUENT' THEN tr.tax_record_id END) AS delinquent_tax_records,
    SUM(tr.tax_amount) AS total_tax_amount,
    SUM(CASE WHEN tr.payment_status = 'PAID' THEN tr.tax_amount ELSE 0 END) AS total_paid_amount,
    SUM(CASE WHEN tr.delinquent = TRUE THEN tr.penalty_amount ELSE 0 END) AS total_penalties,
    MAX(tr.due_date) AS latest_tax_due_date,
    MAX(tr.payment_date) AS last_payment_date,
    COUNT(DISTINCT tb.bill_id) AS total_tax_bills,
    p.created_at,
    p.updated_at
FROM RAW.PROPERTIES p
LEFT JOIN RAW.LOANS l ON p.property_id = l.property_id
LEFT JOIN RAW.TAX_RECORDS tr ON p.property_id = tr.property_id
LEFT JOIN RAW.TAX_BILLS tb ON tr.tax_record_id = tb.tax_record_id
GROUP BY
    p.property_id, p.property_address, p.property_city, p.property_state, 
    p.property_zip, p.county, p.property_type, p.assessed_value, 
    p.property_status, p.created_at, p.updated_at;

-- ============================================================================
-- Loan Analytics View
-- ============================================================================
CREATE OR REPLACE VIEW V_LOAN_ANALYTICS AS
SELECT
    l.loan_id,
    l.client_id,
    c.client_name,
    c.client_type,
    l.property_id,
    p.property_address,
    p.property_state,
    p.county,
    l.loan_number,
    l.loan_type,
    l.loan_amount,
    l.loan_date,
    l.loan_status,
    l.borrower_name,
    l.tax_monitoring_required,
    l.flood_monitoring_required,
    l.escrow_account,
    l.maturity_date,
    DATEDIFF('month', l.loan_date, CURRENT_DATE()) AS loan_age_months,
    DATEDIFF('month', CURRENT_DATE(), l.maturity_date) AS months_to_maturity,
    COUNT(DISTINCT tr.tax_record_id) AS total_tax_records,
    COUNT(DISTINCT CASE WHEN tr.delinquent = TRUE THEN tr.tax_record_id END) AS delinquent_tax_records,
    COUNT(DISTINCT fc.certification_id) AS total_flood_certifications,
    COUNT(DISTINCT CASE WHEN fc.insurance_required = TRUE THEN fc.certification_id END) AS flood_insurance_required_count,
    l.created_at,
    l.updated_at
FROM RAW.LOANS l
JOIN RAW.CLIENTS c ON l.client_id = c.client_id
JOIN RAW.PROPERTIES p ON l.property_id = p.property_id
LEFT JOIN RAW.TAX_RECORDS tr ON l.loan_id = tr.loan_id
LEFT JOIN RAW.FLOOD_CERTIFICATIONS fc ON l.loan_id = fc.loan_id
GROUP BY
    l.loan_id, l.client_id, c.client_name, c.client_type, l.property_id, 
    p.property_address, p.property_state, p.county, l.loan_number, 
    l.loan_type, l.loan_amount, l.loan_date, l.loan_status, l.borrower_name,
    l.tax_monitoring_required, l.flood_monitoring_required, l.escrow_account, 
    l.maturity_date, l.created_at, l.updated_at;

-- ============================================================================
-- Tax Compliance Analytics View
-- ============================================================================
CREATE OR REPLACE VIEW V_TAX_COMPLIANCE_ANALYTICS AS
SELECT
    tr.tax_record_id,
    tr.client_id,
    c.client_name,
    tr.property_id,
    p.property_address,
    p.property_state,
    p.county,
    tr.loan_id,
    l.loan_number,
    tj.jurisdiction_name,
    tj.jurisdiction_type,
    tr.tax_year,
    tr.assessed_value,
    tr.tax_amount,
    tr.payment_status,
    tr.due_date,
    tr.payment_date,
    tr.delinquent,
    tr.delinquency_date,
    tr.penalty_amount,
    CASE 
        WHEN tr.payment_status = 'PAID' THEN 'COMPLIANT'
        WHEN tr.delinquent = TRUE THEN 'DELINQUENT'
        WHEN tr.due_date < CURRENT_DATE() THEN 'OVERDUE'
        WHEN DATEDIFF('day', CURRENT_DATE(), tr.due_date) <= 30 THEN 'DUE_SOON'
        ELSE 'CURRENT'
    END AS compliance_status,
    DATEDIFF('day', tr.due_date, CURRENT_DATE()) AS days_past_due,
    COUNT(DISTINCT tb.bill_id) AS total_bills,
    COUNT(DISTINCT tp.payment_id) AS total_payments,
    tr.created_at,
    tr.updated_at
FROM RAW.TAX_RECORDS tr
JOIN RAW.CLIENTS c ON tr.client_id = c.client_id
JOIN RAW.PROPERTIES p ON tr.property_id = p.property_id
JOIN RAW.LOANS l ON tr.loan_id = l.loan_id
JOIN RAW.TAX_JURISDICTIONS tj ON tr.jurisdiction_id = tj.jurisdiction_id
LEFT JOIN RAW.TAX_BILLS tb ON tr.tax_record_id = tb.tax_record_id
LEFT JOIN RAW.TAX_PAYMENTS tp ON tr.tax_record_id = tp.tax_record_id
GROUP BY
    tr.tax_record_id, tr.client_id, c.client_name, tr.property_id, 
    p.property_address, p.property_state, p.county, tr.loan_id, l.loan_number,
    tj.jurisdiction_name, tj.jurisdiction_type, tr.tax_year, tr.assessed_value, 
    tr.tax_amount, tr.payment_status, tr.due_date, tr.payment_date, 
    tr.delinquent, tr.delinquency_date, tr.penalty_amount, 
    tr.created_at, tr.updated_at;

-- ============================================================================
-- Flood Certification Analytics View
-- ============================================================================
CREATE OR REPLACE VIEW V_FLOOD_CERTIFICATION_ANALYTICS AS
SELECT
    fc.certification_id,
    fc.client_id,
    c.client_name,
    fc.property_id,
    p.property_address,
    p.property_state,
    p.county,
    fc.loan_id,
    l.loan_number,
    l.borrower_name,
    fc.certification_date,
    fc.flood_zone,
    fz.zone_description AS flood_zone_description,
    fz.risk_level AS flood_risk_level,
    fc.determination_method,
    fc.certification_status,
    fc.insurance_required,
    fc.expiration_date,
    fc.life_of_loan_tracking,
    CASE
        WHEN fc.insurance_required = TRUE THEN 'INSURANCE_REQUIRED'
        WHEN fz.risk_level = 'HIGH_RISK' THEN 'HIGH_RISK'
        WHEN fz.risk_level = 'MODERATE_RISK' THEN 'MODERATE_RISK'
        ELSE 'LOW_RISK'
    END AS risk_category,
    CASE 
        WHEN fc.expiration_date IS NOT NULL AND fc.expiration_date < CURRENT_DATE() THEN 'EXPIRED'
        WHEN fc.expiration_date IS NOT NULL AND DATEDIFF('day', CURRENT_DATE(), fc.expiration_date) <= 90 THEN 'EXPIRING_SOON'
        ELSE 'CURRENT'
    END AS certification_validity,
    fc.created_at,
    fc.updated_at
FROM RAW.FLOOD_CERTIFICATIONS fc
JOIN RAW.CLIENTS c ON fc.client_id = c.client_id
JOIN RAW.PROPERTIES p ON fc.property_id = p.property_id
JOIN RAW.LOANS l ON fc.loan_id = l.loan_id
LEFT JOIN RAW.FLOOD_ZONES fz ON fc.flood_zone = fz.zone_designation;

-- ============================================================================
-- Subscription Analytics View
-- ============================================================================
CREATE OR REPLACE VIEW V_SUBSCRIPTION_ANALYTICS AS
SELECT
    ss.subscription_id,
    ss.client_id,
    c.client_name,
    c.client_type,
    ss.service_type,
    ss.subscription_tier,
    ss.start_date,
    ss.end_date,
    DATEDIFF('day', CURRENT_DATE(), ss.end_date) AS days_until_expiration,
    ss.billing_cycle,
    ss.monthly_price,
    ss.property_count_limit,
    ss.user_licenses,
    ss.api_call_limit,
    ss.advanced_analytics,
    ss.subscription_status,
    CASE
        WHEN ss.subscription_status = 'ACTIVE' AND DATEDIFF('day', CURRENT_DATE(), ss.end_date) <= 30 THEN 'RENEWAL_RISK'
        WHEN ss.subscription_status = 'ACTIVE' THEN 'HEALTHY'
        WHEN ss.subscription_status = 'EXPIRED' THEN 'EXPIRED'
        ELSE 'PENDING_RENEWAL'
    END AS health_status,
    COUNT(DISTINCT l.loan_id) AS loans_under_subscription,
    COUNT(DISTINCT p.property_id) AS properties_under_subscription,
    ss.created_at,
    ss.updated_at
FROM RAW.SERVICE_SUBSCRIPTIONS ss
JOIN RAW.CLIENTS c ON ss.client_id = c.client_id
LEFT JOIN RAW.LOANS l ON c.client_id = l.client_id AND l.loan_status = 'ACTIVE'
LEFT JOIN RAW.PROPERTIES p ON l.property_id = p.property_id
GROUP BY
    ss.subscription_id, ss.client_id, c.client_name, c.client_type, 
    ss.service_type, ss.subscription_tier, ss.start_date, ss.end_date, 
    ss.billing_cycle, ss.monthly_price, ss.property_count_limit, 
    ss.user_licenses, ss.api_call_limit, ss.advanced_analytics, 
    ss.subscription_status, ss.created_at, ss.updated_at;

-- ============================================================================
-- Revenue Analytics View
-- ============================================================================
CREATE OR REPLACE VIEW V_REVENUE_ANALYTICS AS
SELECT
    t.transaction_id,
    t.client_id,
    c.client_name,
    c.client_type,
    t.transaction_date,
    DATE_TRUNC('month', t.transaction_date) AS transaction_month,
    DATE_TRUNC('year', t.transaction_date) AS transaction_year,
    t.transaction_type,
    t.product_type,
    p.product_name,
    p.product_category,
    t.amount,
    t.discount_amount,
    t.tax_amount,
    t.total_amount,
    t.payment_method,
    t.payment_status,
    t.created_at
FROM RAW.TRANSACTIONS t
JOIN RAW.CLIENTS c ON t.client_id = c.client_id
LEFT JOIN RAW.PRODUCTS p ON t.product_id = p.product_id;

-- ============================================================================
-- Support Analytics View
-- ============================================================================
CREATE OR REPLACE VIEW V_SUPPORT_ANALYTICS AS
SELECT
    st.ticket_id,
    st.client_id,
    c.client_name,
    c.client_type,
    st.subject,
    st.issue_type,
    st.priority,
    st.ticket_status,
    st.channel,
    st.assigned_agent_id,
    sa.agent_name,
    sa.department AS agent_department,
    sa.specialization AS agent_specialization,
    st.created_date,
    st.first_response_date,
    st.resolved_date,
    st.closed_date,
    st.resolution_time_hours,
    st.satisfaction_rating,
    CASE
        WHEN st.ticket_status = 'CLOSED' AND st.satisfaction_rating >= 4 THEN 'SATISFIED'
        WHEN st.ticket_status = 'CLOSED' AND st.satisfaction_rating < 4 THEN 'UNSATISFIED'
        WHEN st.ticket_status IN ('OPEN', 'IN_PROGRESS') AND DATEDIFF('hour', st.created_date, CURRENT_TIMESTAMP()) > 48 THEN 'OVERDUE'
        ELSE 'ON_TRACK'
    END AS ticket_health,
    DATEDIFF('hour', st.created_date, COALESCE(st.first_response_date, CURRENT_TIMESTAMP())) AS first_response_time_hours,
    st.created_at,
    st.updated_at
FROM RAW.SUPPORT_TICKETS st
JOIN RAW.CLIENTS c ON st.client_id = c.client_id
LEFT JOIN RAW.SUPPORT_AGENTS sa ON st.assigned_agent_id = sa.agent_id;

-- ============================================================================
-- Campaign Performance View
-- ============================================================================
CREATE OR REPLACE VIEW V_CAMPAIGN_PERFORMANCE AS
SELECT
    mc.campaign_id,
    mc.campaign_name,
    mc.campaign_type,
    mc.start_date,
    mc.end_date,
    mc.target_audience,
    mc.budget,
    mc.channel,
    mc.campaign_status,
    COUNT(DISTINCT cci.interaction_id) AS total_interactions,
    COUNT(DISTINCT cci.client_id) AS unique_clients,
    COUNT(DISTINCT CASE WHEN cci.interaction_type IN ('EMAIL_OPEN', 'CLICK') THEN cci.interaction_id END) AS engagement_interactions,
    COUNT(DISTINCT CASE WHEN cci.conversion_flag = TRUE THEN cci.interaction_id END) AS conversions,
    SUM(cci.revenue_generated) AS total_revenue,
    CASE
        WHEN COUNT(DISTINCT cci.interaction_id) > 0 
        THEN (COUNT(DISTINCT CASE WHEN cci.conversion_flag = TRUE THEN cci.interaction_id END) * 100.0 / COUNT(DISTINCT cci.interaction_id))
        ELSE 0
    END AS conversion_rate,
    CASE
        WHEN mc.budget > 0 AND SUM(cci.revenue_generated) > 0
        THEN (SUM(cci.revenue_generated) / mc.budget)
        ELSE 0
    END AS roi,
    mc.created_at
FROM RAW.MARKETING_CAMPAIGNS mc
LEFT JOIN RAW.CLIENT_CAMPAIGN_INTERACTIONS cci ON mc.campaign_id = cci.campaign_id
GROUP BY
    mc.campaign_id, mc.campaign_name, mc.campaign_type, mc.start_date, 
    mc.end_date, mc.target_audience, mc.budget, mc.channel, 
    mc.campaign_status, mc.created_at;

-- ============================================================================
-- Display confirmation
-- ============================================================================
SELECT 'All analytical views created successfully' AS status;

