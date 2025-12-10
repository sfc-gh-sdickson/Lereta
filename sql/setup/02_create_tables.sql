-- ============================================================================
-- Lereta Intelligence Agent - Table Definitions
-- ============================================================================
-- Purpose: Create all necessary tables for the Lereta business model
-- Based on verified GoDaddy/MedTrainer template structure
-- Mapping: GoDaddy CUSTOMERS → Lereta CLIENTS
--          GoDaddy DOMAINS → Lereta PROPERTIES + LOANS
-- ============================================================================

USE DATABASE LERETA_INTELLIGENCE;
USE SCHEMA RAW;
USE WAREHOUSE LERETA_WH;

-- ============================================================================
-- CLIENTS TABLE (from CUSTOMERS/ORGANIZATIONS)
-- Financial institutions using Lereta services
-- ============================================================================
CREATE OR REPLACE TABLE CLIENTS (
    client_id VARCHAR(20) PRIMARY KEY,
    client_name VARCHAR(200) NOT NULL,
    contact_email VARCHAR(200) NOT NULL,
    contact_phone VARCHAR(20),
    country VARCHAR(50) DEFAULT 'USA',
    state VARCHAR(50),
    city VARCHAR(100),
    onboarding_date DATE NOT NULL,
    client_status VARCHAR(20) DEFAULT 'ACTIVE',
    client_type VARCHAR(30),
    lifetime_value NUMBER(12,2) DEFAULT 0.00,
    service_quality_score NUMBER(5,2),
    total_properties NUMBER(10,0) DEFAULT 0,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
) CHANGE_TRACKING = TRUE;

-- ============================================================================
-- PROPERTIES TABLE (from DOMAINS concept)
-- Real estate properties being monitored for taxes and flood
-- ============================================================================
CREATE OR REPLACE TABLE PROPERTIES (
    property_id VARCHAR(30) PRIMARY KEY,
    property_address VARCHAR(500) NOT NULL,
    property_city VARCHAR(100) NOT NULL,
    property_state VARCHAR(50) NOT NULL,
    property_zip VARCHAR(20) NOT NULL,
    county VARCHAR(100) NOT NULL,
    property_type VARCHAR(50) NOT NULL,
    parcel_number VARCHAR(100),
    assessed_value NUMBER(15,2),
    flood_zone VARCHAR(20),
    first_monitored_date DATE NOT NULL,
    property_status VARCHAR(30) DEFAULT 'ACTIVE',
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
) CHANGE_TRACKING = TRUE;

-- ============================================================================
-- LOANS TABLE (NEW - Core Lereta Entity)
-- Mortgage loans that connect clients to properties
-- ============================================================================
CREATE OR REPLACE TABLE LOANS (
    loan_id VARCHAR(30) PRIMARY KEY,
    client_id VARCHAR(20) NOT NULL,
    property_id VARCHAR(30) NOT NULL,
    loan_number VARCHAR(100) NOT NULL,
    loan_type VARCHAR(50) NOT NULL,
    loan_amount NUMBER(15,2) NOT NULL,
    loan_date DATE NOT NULL,
    loan_status VARCHAR(20) DEFAULT 'ACTIVE',
    borrower_name VARCHAR(200) NOT NULL,
    servicer_loan_number VARCHAR(100),
    tax_monitoring_required BOOLEAN DEFAULT TRUE,
    flood_monitoring_required BOOLEAN DEFAULT TRUE,
    escrow_account BOOLEAN DEFAULT TRUE,
    maturity_date DATE,
    last_status_change DATE,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (client_id) REFERENCES CLIENTS(client_id),
    FOREIGN KEY (property_id) REFERENCES PROPERTIES(property_id)
) CHANGE_TRACKING = TRUE;

-- ============================================================================
-- SERVICE_SUBSCRIPTIONS TABLE (from HOSTING_PLANS/SUBSCRIPTIONS)
-- Lereta service subscriptions by clients
-- ============================================================================
CREATE OR REPLACE TABLE SERVICE_SUBSCRIPTIONS (
    subscription_id VARCHAR(30) PRIMARY KEY,
    client_id VARCHAR(20) NOT NULL,
    service_type VARCHAR(50) NOT NULL,
    subscription_tier VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    billing_cycle VARCHAR(20),
    monthly_price NUMBER(10,2),
    property_count_limit NUMBER(10,0),
    user_licenses NUMBER(10,0),
    api_call_limit NUMBER(10,0),
    advanced_analytics BOOLEAN DEFAULT FALSE,
    subscription_status VARCHAR(30) DEFAULT 'ACTIVE',
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (client_id) REFERENCES CLIENTS(client_id)
) CHANGE_TRACKING = TRUE;

-- ============================================================================
-- TAX_JURISDICTIONS TABLE
-- Tax districts and authorities
-- ============================================================================
CREATE OR REPLACE TABLE TAX_JURISDICTIONS (
    jurisdiction_id VARCHAR(30) PRIMARY KEY,
    jurisdiction_name VARCHAR(200) NOT NULL,
    jurisdiction_type VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    county VARCHAR(100),
    tax_rate NUMBER(6,4),
    payment_schedule VARCHAR(50),
    contact_info VARCHAR(500),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
) CHANGE_TRACKING = TRUE;

-- ============================================================================
-- TAX_RECORDS TABLE
-- Property tax monitoring records
-- ============================================================================
CREATE OR REPLACE TABLE TAX_RECORDS (
    tax_record_id VARCHAR(30) PRIMARY KEY,
    property_id VARCHAR(30) NOT NULL,
    loan_id VARCHAR(30) NOT NULL,
    client_id VARCHAR(20) NOT NULL,
    jurisdiction_id VARCHAR(30) NOT NULL,
    tax_year NUMBER(4,0) NOT NULL,
    assessed_value NUMBER(15,2) NOT NULL,
    tax_amount NUMBER(12,2) NOT NULL,
    payment_status VARCHAR(30) DEFAULT 'PENDING',
    due_date DATE NOT NULL,
    payment_date DATE,
    delinquent BOOLEAN DEFAULT FALSE,
    delinquency_date DATE,
    penalty_amount NUMBER(10,2) DEFAULT 0.00,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (property_id) REFERENCES PROPERTIES(property_id),
    FOREIGN KEY (loan_id) REFERENCES LOANS(loan_id),
    FOREIGN KEY (client_id) REFERENCES CLIENTS(client_id),
    FOREIGN KEY (jurisdiction_id) REFERENCES TAX_JURISDICTIONS(jurisdiction_id)
) CHANGE_TRACKING = TRUE;

-- ============================================================================
-- TAX_BILLS TABLE
-- Individual property tax bills
-- ============================================================================
CREATE OR REPLACE TABLE TAX_BILLS (
    bill_id VARCHAR(30) PRIMARY KEY,
    tax_record_id VARCHAR(30) NOT NULL,
    property_id VARCHAR(30) NOT NULL,
    bill_number VARCHAR(100),
    bill_date DATE NOT NULL,
    bill_amount NUMBER(12,2) NOT NULL,
    due_date DATE NOT NULL,
    installment_number NUMBER(2,0),
    total_installments NUMBER(2,0),
    bill_status VARCHAR(30) DEFAULT 'UNPAID',
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (tax_record_id) REFERENCES TAX_RECORDS(tax_record_id),
    FOREIGN KEY (property_id) REFERENCES PROPERTIES(property_id)
) CHANGE_TRACKING = TRUE;

-- ============================================================================
-- TAX_PAYMENTS TABLE
-- Property tax payment transactions
-- ============================================================================
CREATE OR REPLACE TABLE TAX_PAYMENTS (
    payment_id VARCHAR(30) PRIMARY KEY,
    tax_record_id VARCHAR(30) NOT NULL,
    bill_id VARCHAR(30),
    payment_date DATE NOT NULL,
    payment_amount NUMBER(12,2) NOT NULL,
    payment_method VARCHAR(50),
    payment_source VARCHAR(50),
    confirmation_number VARCHAR(100),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (tax_record_id) REFERENCES TAX_RECORDS(tax_record_id),
    FOREIGN KEY (bill_id) REFERENCES TAX_BILLS(bill_id)
) CHANGE_TRACKING = TRUE;

-- ============================================================================
-- FLOOD_ZONES TABLE
-- FEMA flood zone definitions
-- ============================================================================
CREATE OR REPLACE TABLE FLOOD_ZONES (
    zone_id VARCHAR(20) PRIMARY KEY,
    zone_designation VARCHAR(20) NOT NULL,
    zone_description VARCHAR(500),
    risk_level VARCHAR(30) NOT NULL,
    insurance_required BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
) CHANGE_TRACKING = TRUE;

-- ============================================================================
-- FLOOD_CERTIFICATIONS TABLE
-- Flood zone determinations for properties
-- ============================================================================
CREATE OR REPLACE TABLE FLOOD_CERTIFICATIONS (
    certification_id VARCHAR(30) PRIMARY KEY,
    property_id VARCHAR(30) NOT NULL,
    loan_id VARCHAR(30) NOT NULL,
    client_id VARCHAR(20) NOT NULL,
    certification_date DATE NOT NULL,
    flood_zone VARCHAR(20) NOT NULL,
    determination_method VARCHAR(50),
    panel_number VARCHAR(50),
    map_date DATE,
    certification_status VARCHAR(30) DEFAULT 'ACTIVE',
    insurance_required BOOLEAN DEFAULT FALSE,
    expiration_date DATE,
    life_of_loan_tracking BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (property_id) REFERENCES PROPERTIES(property_id),
    FOREIGN KEY (loan_id) REFERENCES LOANS(loan_id),
    FOREIGN KEY (client_id) REFERENCES CLIENTS(client_id)
) CHANGE_TRACKING = TRUE;

-- ============================================================================
-- FLOOD_MAP_CHANGES TABLE
-- FEMA flood map revisions
-- ============================================================================
CREATE OR REPLACE TABLE FLOOD_MAP_CHANGES (
    map_change_id VARCHAR(30) PRIMARY KEY,
    property_id VARCHAR(30) NOT NULL,
    old_flood_zone VARCHAR(20),
    new_flood_zone VARCHAR(20) NOT NULL,
    change_date DATE NOT NULL,
    effective_date DATE NOT NULL,
    map_revision_number VARCHAR(50),
    notification_sent BOOLEAN DEFAULT FALSE,
    recertification_required BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (property_id) REFERENCES PROPERTIES(property_id)
) CHANGE_TRACKING = TRUE;

-- ============================================================================
-- ESCROW_ACCOUNTS TABLE
-- Tax and insurance escrow account tracking
-- ============================================================================
CREATE OR REPLACE TABLE ESCROW_ACCOUNTS (
    escrow_id VARCHAR(30) PRIMARY KEY,
    loan_id VARCHAR(30) NOT NULL,
    client_id VARCHAR(20) NOT NULL,
    account_number VARCHAR(100),
    current_balance NUMBER(12,2) DEFAULT 0.00,
    monthly_payment NUMBER(10,2),
    tax_portion NUMBER(10,2),
    insurance_portion NUMBER(10,2),
    last_analysis_date DATE,
    account_status VARCHAR(30) DEFAULT 'ACTIVE',
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (loan_id) REFERENCES LOANS(loan_id),
    FOREIGN KEY (client_id) REFERENCES CLIENTS(client_id)
) CHANGE_TRACKING = TRUE;

-- ============================================================================
-- DISBURSEMENTS TABLE
-- Tax payment disbursements from escrow
-- ============================================================================
CREATE OR REPLACE TABLE DISBURSEMENTS (
    disbursement_id VARCHAR(30) PRIMARY KEY,
    escrow_id VARCHAR(30) NOT NULL,
    tax_record_id VARCHAR(30),
    disbursement_date DATE NOT NULL,
    disbursement_amount NUMBER(12,2) NOT NULL,
    disbursement_type VARCHAR(50) NOT NULL,
    payee VARCHAR(200),
    check_number VARCHAR(50),
    disbursement_status VARCHAR(30) DEFAULT 'COMPLETED',
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (escrow_id) REFERENCES ESCROW_ACCOUNTS(escrow_id),
    FOREIGN KEY (tax_record_id) REFERENCES TAX_RECORDS(tax_record_id)
) CHANGE_TRACKING = TRUE;

-- ============================================================================
-- COMPLIANCE_CHECKS TABLE
-- Regulatory compliance monitoring
-- ============================================================================
CREATE OR REPLACE TABLE COMPLIANCE_CHECKS (
    check_id VARCHAR(30) PRIMARY KEY,
    client_id VARCHAR(20) NOT NULL,
    loan_id VARCHAR(30),
    check_date DATE NOT NULL,
    check_type VARCHAR(50) NOT NULL,
    compliance_status VARCHAR(30) NOT NULL,
    findings VARCHAR(2000),
    risk_level VARCHAR(20),
    remediation_required BOOLEAN DEFAULT FALSE,
    remediation_date DATE,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (client_id) REFERENCES CLIENTS(client_id),
    FOREIGN KEY (loan_id) REFERENCES LOANS(loan_id)
) CHANGE_TRACKING = TRUE;

-- ============================================================================
-- TRANSACTIONS TABLE
-- Service fee transactions
-- ============================================================================
CREATE OR REPLACE TABLE TRANSACTIONS (
    transaction_id VARCHAR(30) PRIMARY KEY,
    client_id VARCHAR(20) NOT NULL,
    transaction_date TIMESTAMP_NTZ NOT NULL,
    transaction_type VARCHAR(50) NOT NULL,
    product_type VARCHAR(50),
    product_id VARCHAR(30),
    amount NUMBER(12,2) NOT NULL,
    currency VARCHAR(10) DEFAULT 'USD',
    payment_method VARCHAR(30),
    payment_status VARCHAR(30) DEFAULT 'COMPLETED',
    discount_amount NUMBER(10,2) DEFAULT 0.00,
    tax_amount NUMBER(10,2) DEFAULT 0.00,
    total_amount NUMBER(12,2) NOT NULL,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (client_id) REFERENCES CLIENTS(client_id)
) CHANGE_TRACKING = TRUE;

-- ============================================================================
-- SUPPORT_TICKETS TABLE
-- Customer support cases
-- ============================================================================
CREATE OR REPLACE TABLE SUPPORT_TICKETS (
    ticket_id VARCHAR(30) PRIMARY KEY,
    client_id VARCHAR(20) NOT NULL,
    subject VARCHAR(500) NOT NULL,
    issue_type VARCHAR(50) NOT NULL,
    priority VARCHAR(20) DEFAULT 'MEDIUM',
    ticket_status VARCHAR(30) DEFAULT 'OPEN',
    channel VARCHAR(30),
    assigned_agent_id VARCHAR(20),
    created_date TIMESTAMP_NTZ NOT NULL,
    first_response_date TIMESTAMP_NTZ,
    resolved_date TIMESTAMP_NTZ,
    closed_date TIMESTAMP_NTZ,
    resolution_time_hours NUMBER(10,2),
    satisfaction_rating NUMBER(3,0),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (client_id) REFERENCES CLIENTS(client_id)
) CHANGE_TRACKING = TRUE;

-- ============================================================================
-- SUPPORT_AGENTS TABLE
-- Lereta support team
-- ============================================================================
CREATE OR REPLACE TABLE SUPPORT_AGENTS (
    agent_id VARCHAR(20) PRIMARY KEY,
    agent_name VARCHAR(200) NOT NULL,
    email VARCHAR(200) NOT NULL,
    department VARCHAR(50),
    specialization VARCHAR(100),
    hire_date DATE,
    average_satisfaction_rating NUMBER(3,2),
    total_tickets_resolved NUMBER(10,0) DEFAULT 0,
    agent_status VARCHAR(30) DEFAULT 'ACTIVE',
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
) CHANGE_TRACKING = TRUE;

-- ============================================================================
-- PRODUCTS TABLE
-- Lereta products and services
-- ============================================================================
CREATE OR REPLACE TABLE PRODUCTS (
    product_id VARCHAR(30) PRIMARY KEY,
    product_name VARCHAR(200) NOT NULL,
    product_category VARCHAR(50) NOT NULL,
    product_subcategory VARCHAR(50),
    base_price NUMBER(10,2),
    recurring_price NUMBER(10,2),
    billing_frequency VARCHAR(20),
    product_description VARCHAR(1000),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
) CHANGE_TRACKING = TRUE;

-- ============================================================================
-- MARKETING_CAMPAIGNS TABLE
-- Marketing and sales campaigns
-- ============================================================================
CREATE OR REPLACE TABLE MARKETING_CAMPAIGNS (
    campaign_id VARCHAR(30) PRIMARY KEY,
    campaign_name VARCHAR(200) NOT NULL,
    campaign_type VARCHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    target_audience VARCHAR(100),
    budget NUMBER(12,2),
    channel VARCHAR(50),
    campaign_status VARCHAR(30) DEFAULT 'ACTIVE',
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
) CHANGE_TRACKING = TRUE;

-- ============================================================================
-- CLIENT_CAMPAIGN_INTERACTIONS TABLE
-- Client interactions with marketing campaigns
-- ============================================================================
CREATE OR REPLACE TABLE CLIENT_CAMPAIGN_INTERACTIONS (
    interaction_id VARCHAR(30) PRIMARY KEY,
    client_id VARCHAR(20) NOT NULL,
    campaign_id VARCHAR(30) NOT NULL,
    interaction_date TIMESTAMP_NTZ NOT NULL,
    interaction_type VARCHAR(50) NOT NULL,
    conversion_flag BOOLEAN DEFAULT FALSE,
    revenue_generated NUMBER(12,2) DEFAULT 0.00,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (client_id) REFERENCES CLIENTS(client_id),
    FOREIGN KEY (campaign_id) REFERENCES MARKETING_CAMPAIGNS(campaign_id)
) CHANGE_TRACKING = TRUE;

-- ============================================================================
-- Display confirmation
-- ============================================================================
SELECT 'All tables created successfully' AS status;

