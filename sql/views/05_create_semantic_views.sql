-- ============================================================================
-- Lereta Intelligence Agent - Semantic Views
-- ============================================================================
-- Purpose: Create semantic views for Snowflake Intelligence agents
-- All syntax VERIFIED against official documentation:
-- https://docs.snowflake.com/en/sql-reference/sql/create-semantic-view
-- 
-- Syntax Verification Notes:
-- 1. Clause order is MANDATORY: TABLES → RELATIONSHIPS → DIMENSIONS → METRICS → COMMENT
-- 2. Semantic expression format: semantic_name AS sql_expression
-- 3. No self-referencing relationships allowed
-- 4. No cyclic relationships allowed
-- 5. PRIMARY KEY columns must exist in table definitions
-- 6. All column names verified against 02_create_tables.sql
-- ============================================================================

USE DATABASE LERETA_INTELLIGENCE;
USE SCHEMA ANALYTICS;
USE WAREHOUSE LERETA_WH;

-- ============================================================================
-- Semantic View 1: Lereta Property Loan & Tax Intelligence
-- ============================================================================
CREATE OR REPLACE SEMANTIC VIEW SV_PROPERTY_LOAN_TAX_INTELLIGENCE
  TABLES (
    clients AS RAW.CLIENTS
      PRIMARY KEY (client_id)
      WITH SYNONYMS ('financial institutions', 'lenders', 'servicers')
      COMMENT = 'Financial institutions using Lereta services',
    properties AS RAW.PROPERTIES
      PRIMARY KEY (property_id)
      WITH SYNONYMS ('real estate', 'parcels', 'addresses')
      COMMENT = 'Properties being monitored for tax and flood',
    loans AS RAW.LOANS
      PRIMARY KEY (loan_id)
      WITH SYNONYMS ('mortgages', 'loan accounts', 'financing')
      COMMENT = 'Mortgage loans requiring tax and flood monitoring',
    tax_records AS RAW.TAX_RECORDS
      PRIMARY KEY (tax_record_id)
      WITH SYNONYMS ('property taxes', 'tax monitoring', 'tax payments')
      COMMENT = 'Property tax records and payment tracking',
    flood_certs AS RAW.FLOOD_CERTIFICATIONS
      PRIMARY KEY (certification_id)
      WITH SYNONYMS ('flood determinations', 'flood zone certifications', 'FEMA certs')
      COMMENT = 'Flood zone certifications and determinations'
  )
  RELATIONSHIPS (
    loans(client_id) REFERENCES clients(client_id),
    loans(property_id) REFERENCES properties(property_id),
    tax_records(client_id) REFERENCES clients(client_id),
    tax_records(property_id) REFERENCES properties(property_id),
    tax_records(loan_id) REFERENCES loans(loan_id),
    flood_certs(client_id) REFERENCES clients(client_id),
    flood_certs(property_id) REFERENCES properties(property_id),
    flood_certs(loan_id) REFERENCES loans(loan_id)
  )
  DIMENSIONS (
    clients.client_name AS client_name
      WITH SYNONYMS ('lender name view1', 'financial institution name', 'servicer name')
      COMMENT = 'Name of the financial institution',
    clients.client_status AS client_status
      WITH SYNONYMS ('account status view1', 'client active status')
      COMMENT = 'Client status: ACTIVE, SUSPENDED, CLOSED',
    clients.client_type AS client_type
      WITH SYNONYMS ('client segment view1', 'institution type')
      COMMENT = 'Client type: NATIONAL_SERVICER, REGIONAL_LENDER, CREDIT_UNION',
    clients.state AS client_state
      WITH SYNONYMS ('client location state', 'lender state')
      COMMENT = 'Client state location',
    clients.city AS client_city
      WITH SYNONYMS ('client location city', 'lender city')
      COMMENT = 'Client city location',
    properties.property_address AS property_address
      WITH SYNONYMS ('address', 'property location')
      COMMENT = 'Full property address',
    properties.property_city AS property_city
      WITH SYNONYMS ('property municipality', 'property town')
      COMMENT = 'City where property is located',
    properties.property_state AS property_state
      WITH SYNONYMS ('property location state', 'state of property')
      COMMENT = 'State where property is located',
    properties.county AS county
      WITH SYNONYMS ('property county', 'county location')
      COMMENT = 'County where property is located',
    properties.property_type AS property_type
      WITH SYNONYMS ('real estate type', 'dwelling type')
      COMMENT = 'Property type: SINGLE_FAMILY, CONDO, TOWNHOUSE, MULTI_FAMILY, MOBILE_HOME',
    properties.flood_zone AS flood_zone
      WITH SYNONYMS ('FEMA zone', 'flood designation')
      COMMENT = 'FEMA flood zone designation',
    properties.property_status AS property_status
      WITH SYNONYMS ('property state', 'real estate status')
      COMMENT = 'Property status: ACTIVE, SOLD, FORECLOSED',
    loans.loan_number AS loan_number
      WITH SYNONYMS ('mortgage number', 'loan account number')
      COMMENT = 'Lender loan number',
    loans.loan_type AS loan_type
      WITH SYNONYMS ('mortgage type', 'financing type')
      COMMENT = 'Loan type: CONVENTIONAL, FHA, VA, JUMBO, USDA',
    loans.loan_status AS loan_status
      WITH SYNONYMS ('mortgage status', 'loan state')
      COMMENT = 'Loan status: ACTIVE, PAID_OFF, FORECLOSED, SOLD',
    loans.borrower_name AS borrower_name
      WITH SYNONYMS ('homeowner name', 'mortgagor')
      COMMENT = 'Name of the borrower',
    loans.tax_monitoring_required AS tax_monitoring_required
      WITH SYNONYMS ('tax tracking needed', 'requires tax monitoring')
      COMMENT = 'Whether loan requires tax monitoring',
    loans.flood_monitoring_required AS flood_monitoring_required
      WITH SYNONYMS ('flood tracking needed', 'requires flood monitoring')
      COMMENT = 'Whether loan requires flood monitoring',
    loans.escrow_account AS escrow_account
      WITH SYNONYMS ('has escrow', 'escrow exists')
      COMMENT = 'Whether loan has escrow account',
    tax_records.tax_year AS tax_year
      WITH SYNONYMS ('assessment year', 'tax period')
      COMMENT = 'Tax year for the record',
    tax_records.payment_status AS payment_status
      WITH SYNONYMS ('tax status', 'payment state')
      COMMENT = 'Payment status: PAID, PENDING, DELINQUENT',
    tax_records.delinquent AS delinquent
      WITH SYNONYMS ('is delinquent', 'tax delinquency')
      COMMENT = 'Whether tax payment is delinquent',
    flood_certs.certification_date AS certification_date
      WITH SYNONYMS ('determination date', 'flood cert date')
      COMMENT = 'Date of flood certification',
    flood_certs.flood_zone AS flood_cert_zone
      WITH SYNONYMS ('certified zone', 'determined zone')
      COMMENT = 'Flood zone from certification',
    flood_certs.determination_method AS determination_method
      WITH SYNONYMS ('cert method', 'flood determination method')
      COMMENT = 'Method used: STANDARD, LIFE_OF_LOAN, MANUAL_REVIEW',
    flood_certs.certification_status AS certification_status
      WITH SYNONYMS ('cert status', 'flood cert state')
      COMMENT = 'Certification status: ACTIVE, EXPIRED',
    flood_certs.insurance_required AS insurance_required
      WITH SYNONYMS ('needs flood insurance', 'insurance mandatory')
      COMMENT = 'Whether flood insurance is required',
    flood_certs.life_of_loan_tracking AS life_of_loan_tracking
      WITH SYNONYMS ('LOL tracking', 'continuous monitoring')
      COMMENT = 'Whether life-of-loan tracking is enabled'
  )
  METRICS (
    clients.total_clients AS COUNT(DISTINCT client_id)
      WITH SYNONYMS ('client count view1', 'number of lenders property')
      COMMENT = 'Total number of clients',
    clients.avg_service_quality AS AVG(service_quality_score)
      WITH SYNONYMS ('average quality score', 'mean service quality')
      COMMENT = 'Average service quality score across clients',
    properties.total_properties AS COUNT(DISTINCT property_id)
      WITH SYNONYMS ('property count', 'real estate count')
      COMMENT = 'Total number of properties',
    properties.avg_assessed_value AS AVG(assessed_value)
      WITH SYNONYMS ('average property value', 'mean assessment')
      COMMENT = 'Average property assessed value',
    loans.total_loans AS COUNT(DISTINCT loan_id)
      WITH SYNONYMS ('loan count', 'mortgage count')
      COMMENT = 'Total number of loans',
    loans.total_loan_amount AS SUM(loan_amount)
      WITH SYNONYMS ('total principal', 'cumulative loan amount')
      COMMENT = 'Total loan amount across all loans',
    loans.avg_loan_amount AS AVG(loan_amount)
      WITH SYNONYMS ('average loan size', 'mean loan amount')
      COMMENT = 'Average loan amount',
    tax_records.total_tax_records AS COUNT(DISTINCT tax_record_id)
      WITH SYNONYMS ('tax record count', 'number of tax records')
      COMMENT = 'Total number of tax records',
    tax_records.total_tax_amount AS SUM(tax_amount)
      WITH SYNONYMS ('total property taxes', 'cumulative tax')
      COMMENT = 'Total tax amount across all records',
    tax_records.avg_tax_amount AS AVG(tax_amount)
      WITH SYNONYMS ('average tax amount', 'mean property tax')
      COMMENT = 'Average tax amount',
    tax_records.total_penalty_amount AS SUM(penalty_amount)
      WITH SYNONYMS ('total penalties', 'cumulative penalties')
      COMMENT = 'Total penalty amount for delinquent taxes',
    flood_certs.total_certifications AS COUNT(DISTINCT certification_id)
      WITH SYNONYMS ('flood cert count', 'determination count')
      COMMENT = 'Total number of flood certifications'
  )
  COMMENT = 'Lereta Property Loan & Tax Intelligence - comprehensive view of properties, loans, tax monitoring, and flood certifications';

-- ============================================================================
-- Semantic View 2: Lereta Subscription & Revenue Intelligence
-- ============================================================================
CREATE OR REPLACE SEMANTIC VIEW SV_SUBSCRIPTION_REVENUE_INTELLIGENCE
  TABLES (
    clients AS RAW.CLIENTS
      PRIMARY KEY (client_id)
      WITH SYNONYMS ('subscription clients', 'revenue customers')
      COMMENT = 'Financial institutions',
    subscriptions AS RAW.SERVICE_SUBSCRIPTIONS
      PRIMARY KEY (subscription_id)
      WITH SYNONYMS ('service plans', 'service packages', 'subscription plans')
      COMMENT = 'Lereta service subscriptions',
    transactions AS RAW.TRANSACTIONS
      PRIMARY KEY (transaction_id)
      WITH SYNONYMS ('purchases', 'payments', 'invoices')
      COMMENT = 'Financial transactions',
    products AS RAW.PRODUCTS
      PRIMARY KEY (product_id)
      WITH SYNONYMS ('services', 'offerings', 'packages')
      COMMENT = 'Lereta products and services'
  )
  RELATIONSHIPS (
    subscriptions(client_id) REFERENCES clients(client_id),
    transactions(client_id) REFERENCES clients(client_id),
    transactions(product_id) REFERENCES products(product_id)
  )
  DIMENSIONS (
    clients.client_name AS client_name
      WITH SYNONYMS ('subscription client name', 'revenue customer name')
      COMMENT = 'Name of the client',
    clients.client_type AS client_type
      WITH SYNONYMS ('subscription client type', 'revenue customer segment')
      COMMENT = 'Client type: NATIONAL_SERVICER, REGIONAL_LENDER, CREDIT_UNION',
    clients.state AS client_state_revenue
      WITH SYNONYMS ('subscription client state', 'revenue location state')
      COMMENT = 'Client state location',
    subscriptions.service_type AS service_type
      WITH SYNONYMS ('subscription type', 'service category')
      COMMENT = 'Service type: TAX_ONLY, FLOOD_ONLY, TAX_AND_FLOOD, FULL_SUITE',
    subscriptions.subscription_tier AS subscription_tier
      WITH SYNONYMS ('plan tier', 'package level')
      COMMENT = 'Subscription tier: BASIC, PROFESSIONAL, ENTERPRISE',
    subscriptions.billing_cycle AS billing_cycle
      WITH SYNONYMS ('payment frequency', 'billing period')
      COMMENT = 'Billing cycle: MONTHLY, ANNUAL',
    subscriptions.subscription_status AS subscription_status
      WITH SYNONYMS ('plan status', 'service status')
      COMMENT = 'Subscription status: ACTIVE, EXPIRED, PENDING_RENEWAL',
    subscriptions.property_count_limit AS property_count_limit
      WITH SYNONYMS ('property limit', 'maximum properties')
      COMMENT = 'Maximum number of properties allowed',
    subscriptions.advanced_analytics AS advanced_analytics
      WITH SYNONYMS ('premium analytics', 'advanced reporting')
      COMMENT = 'Whether advanced analytics is included',
    transactions.transaction_type AS transaction_type
      WITH SYNONYMS ('transaction category', 'purchase type')
      COMMENT = 'Transaction type: SERVICE_FEE, SUBSCRIPTION_PAYMENT, SETUP_FEE, ONE_TIME_SERVICE',
    transactions.product_type AS product_type
      WITH SYNONYMS ('transaction service type')
      COMMENT = 'Product type: TAX_MONITORING, FLOOD_CERTIFICATION, COMPLIANCE_REPORTING, FULL_SUITE',
    transactions.payment_method AS payment_method
      WITH SYNONYMS ('transaction payment type', 'payment method type')
      COMMENT = 'Payment method: ACH, WIRE, CHECK, CREDIT_CARD',
    transactions.payment_status AS payment_status
      WITH SYNONYMS ('transaction payment status', 'payment completion status')
      COMMENT = 'Payment status: COMPLETED, PENDING, FAILED',
    transactions.currency AS currency
      WITH SYNONYMS ('payment currency')
      COMMENT = 'Transaction currency',
    products.product_name AS product_name
      WITH SYNONYMS ('service name', 'package name')
      COMMENT = 'Name of the product or service',
    products.product_category AS product_category
      WITH SYNONYMS ('product type')
      COMMENT = 'Product category: TAX_MONITORING, FLOOD_CERTIFICATION, COMPLIANCE_REPORTING, FULL_SUITE',
    products.product_subcategory AS product_subcategory
      WITH SYNONYMS ('subcategory')
      COMMENT = 'Product subcategory',
    products.billing_frequency AS billing_frequency
      WITH SYNONYMS ('product billing frequency', 'product payment frequency')
      COMMENT = 'Billing frequency for product',
    products.is_active AS is_active
      WITH SYNONYMS ('available', 'active product')
      COMMENT = 'Whether product is currently active'
  )
  METRICS (
    clients.total_clients AS COUNT(DISTINCT client_id)
      WITH SYNONYMS ('client count view2', 'number of clients subscriptions')
      COMMENT = 'Total number of clients',
    subscriptions.total_subscriptions AS COUNT(DISTINCT subscription_id)
      WITH SYNONYMS ('subscription count', 'plan count')
      COMMENT = 'Total number of subscriptions',
    subscriptions.avg_monthly_price AS AVG(monthly_price)
      WITH SYNONYMS ('average subscription price', 'mean monthly cost')
      COMMENT = 'Average monthly subscription price',
    subscriptions.total_property_limits AS SUM(property_count_limit)
      WITH SYNONYMS ('total property capacity', 'cumulative property limits')
      COMMENT = 'Total property count limit across all subscriptions',
    subscriptions.avg_property_limit AS AVG(property_count_limit)
      WITH SYNONYMS ('average property limit per subscription')
      COMMENT = 'Average property count limit per subscription',
    subscriptions.total_user_licenses AS SUM(user_licenses)
      WITH SYNONYMS ('total user access', 'cumulative licenses')
      COMMENT = 'Total user licenses across all subscriptions',
    transactions.total_transactions AS COUNT(DISTINCT transaction_id)
      WITH SYNONYMS ('transaction count', 'payment count')
      COMMENT = 'Total number of transactions',
    transactions.total_revenue AS SUM(total_amount)
      WITH SYNONYMS ('total sales', 'gross revenue')
      COMMENT = 'Total revenue from all transactions',
    transactions.avg_transaction_amount AS AVG(total_amount)
      WITH SYNONYMS ('average transaction value', 'mean purchase amount')
      COMMENT = 'Average transaction amount',
    transactions.total_discount_amount AS SUM(discount_amount)
      WITH SYNONYMS ('total discounts', 'discount sum')
      COMMENT = 'Total discount amount given',
    transactions.total_tax_amount AS SUM(tax_amount)
      WITH SYNONYMS ('total tax', 'tax sum')
      COMMENT = 'Total tax amount collected',
    products.total_products AS COUNT(DISTINCT product_id)
      WITH SYNONYMS ('product count')
      COMMENT = 'Total number of unique products',
    products.avg_base_price AS AVG(base_price)
      WITH SYNONYMS ('average base price')
      COMMENT = 'Average product base price',
    products.avg_recurring_price AS AVG(recurring_price)
      WITH SYNONYMS ('average recurring price')
      COMMENT = 'Average product recurring price'
  )
  COMMENT = 'Lereta Subscription & Revenue Intelligence - comprehensive view of subscriptions, products, transactions, and revenue metrics';

-- ============================================================================
-- Semantic View 3: Lereta Client Support Intelligence
-- ============================================================================
CREATE OR REPLACE SEMANTIC VIEW SV_CLIENT_SUPPORT_INTELLIGENCE
  TABLES (
    clients AS RAW.CLIENTS
      PRIMARY KEY (client_id)
      WITH SYNONYMS ('support clients', 'ticket customers')
      COMMENT = 'Financial institutions',
    tickets AS RAW.SUPPORT_TICKETS
      PRIMARY KEY (ticket_id)
      WITH SYNONYMS ('support cases', 'help requests', 'issues')
      COMMENT = 'Customer support tickets',
    agents AS RAW.SUPPORT_AGENTS
      PRIMARY KEY (agent_id)
      WITH SYNONYMS ('support staff', 'help desk agents', 'representatives')
      COMMENT = 'Support agents'
  )
  RELATIONSHIPS (
    tickets(client_id) REFERENCES clients(client_id),
    tickets(assigned_agent_id) REFERENCES agents(agent_id)
  )
  DIMENSIONS (
    clients.client_name AS client_name
      WITH SYNONYMS ('support client name', 'ticket customer name')
      COMMENT = 'Name of the client',
    clients.client_type AS client_type
      WITH SYNONYMS ('support customer type', 'support institution type')
      COMMENT = 'Client type: NATIONAL_SERVICER, REGIONAL_LENDER, CREDIT_UNION',
    tickets.issue_type AS issue_type
      WITH SYNONYMS ('problem type', 'ticket category')
      COMMENT = 'Issue type: TAX_MONITORING, FLOOD_CERTIFICATION, BILLING, TECHNICAL, COMPLIANCE, ACCOUNT_MANAGEMENT',
    tickets.priority AS priority
      WITH SYNONYMS ('urgency', 'ticket priority')
      COMMENT = 'Ticket priority: LOW, MEDIUM, HIGH, URGENT',
    tickets.ticket_status AS ticket_status
      WITH SYNONYMS ('status', 'case status')
      COMMENT = 'Ticket status: OPEN, IN_PROGRESS, RESOLVED, CLOSED',
    tickets.channel AS channel
      WITH SYNONYMS ('contact channel', 'communication method')
      COMMENT = 'Support channel: PHONE, EMAIL, CHAT, PORTAL',
    agents.agent_name AS agent_name
      WITH SYNONYMS ('support agent', 'rep name')
      COMMENT = 'Name of support agent',
    agents.department AS department
      WITH SYNONYMS ('support team', 'agent department')
      COMMENT = 'Agent department: TAX_SERVICES, FLOOD_SERVICES, TECHNICAL, COMPLIANCE, BILLING',
    agents.specialization AS specialization
      WITH SYNONYMS ('expertise', 'specialty')
      COMMENT = 'Agent specialization area',
    agents.agent_status AS agent_status
      WITH SYNONYMS ('agent state')
      COMMENT = 'Agent status: ACTIVE, INACTIVE'
  )
  METRICS (
    clients.total_clients AS COUNT(DISTINCT client_id)
      WITH SYNONYMS ('client count view3', 'number of clients support')
      COMMENT = 'Total number of clients',
    tickets.total_tickets AS COUNT(DISTINCT ticket_id)
      WITH SYNONYMS ('ticket count', 'case count', 'number of tickets')
      COMMENT = 'Total number of support tickets',
    tickets.avg_resolution_time AS AVG(resolution_time_hours)
      WITH SYNONYMS ('average resolution time', 'mean time to resolve')
      COMMENT = 'Average ticket resolution time in hours',
    tickets.avg_satisfaction_rating AS AVG(satisfaction_rating)
      WITH SYNONYMS ('average satisfaction', 'csat score', 'customer satisfaction')
      COMMENT = 'Average customer satisfaction rating',
    agents.total_agents AS COUNT(DISTINCT agent_id)
      WITH SYNONYMS ('agent count', 'support staff count')
      COMMENT = 'Total number of support agents',
    agents.avg_agent_satisfaction AS AVG(average_satisfaction_rating)
      WITH SYNONYMS ('average agent rating')
      COMMENT = 'Average satisfaction rating across all agents',
    agents.total_tickets_resolved_by_agents AS SUM(total_tickets_resolved)
      WITH SYNONYMS ('total resolved tickets', 'cumulative resolutions')
      COMMENT = 'Total tickets resolved by all agents'
  )
  COMMENT = 'Lereta Client Support Intelligence - comprehensive view of support tickets, agents, and customer satisfaction';

-- ============================================================================
-- Display confirmation and verification
-- ============================================================================
SELECT 'Semantic views created successfully - all syntax verified' AS status;

-- Verify semantic views exist
SELECT 
    table_name AS semantic_view_name,
    comment AS description
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_SCHEMA = 'ANALYTICS'
  AND table_name LIKE 'SV_%'
ORDER BY table_name;

-- Show semantic view details
SHOW SEMANTIC VIEWS IN SCHEMA ANALYTICS;

