# Lereta Intelligence Agent - Entity Mapping Document

**Date:** October 18, 2025  
**Purpose:** Explicit mapping from GoDaddy template entities to Lereta business entities  
**Status:** AWAITING APPROVAL - NO SQL WILL BE WRITTEN UNTIL THIS IS APPROVED

---

## Business Context

### GoDaddy Business Model
- Domain registration and web hosting services
- Products: Domains, Hosting, Email, SSL, Website Builder
- Customers: Individuals and businesses buying web services

### Lereta Business Model
- National provider of tax and flood services to financial services industry
- Services: Property tax monitoring, flood certification, compliance tracking
- Customers: Mortgage lenders, loan servicers, financial institutions
- Core Business: Monitor property taxes and flood zones for mortgaged properties

---

## Key Business Entities for Lereta

Based on Lereta.com research, the core entities are:

1. **CLIENTS** - Financial institutions (mortgage lenders, servicers) who subscribe to Lereta's services
2. **PROPERTIES** - Real estate properties being monitored for taxes and flood status
3. **LOANS** - Mortgage loans tied to properties (the reason for monitoring)
4. **TAX_RECORDS** - Property tax payment tracking and compliance
5. **FLOOD_CERTIFICATIONS** - Flood zone determinations and certifications
6. **SERVICE_SUBSCRIPTIONS** - Lereta service subscriptions (tax monitoring, flood tracking)
7. **TRANSACTIONS** - Service fees and payments
8. **SUPPORT_TICKETS** - Customer support interactions

---

## Entity Mapping Table

| GoDaddy Entity | Lereta Entity | Mapping Type | Notes |
|---|---|---|---|
| CUSTOMERS | CLIENTS | Direct Rename | Financial institutions are the customers |
| DOMAINS | PROPERTIES | Concept Map | Properties replace domains as the primary asset |
| *(not mapped)* | LOANS | New Entity | Mortgage loans tied to properties (core business) |
| HOSTING_PLANS | SERVICE_SUBSCRIPTIONS | Concept Map | Service subscriptions replace hosting plans |
| TRANSACTIONS | TRANSACTIONS | Direct Copy | Financial transactions (same concept) |
| SUPPORT_TICKETS | SUPPORT_TICKETS | Direct Copy | Customer support (same concept) |
| WEBSITE_BUILDER_SUBSCRIPTIONS | *(not mapped)* | Skip | Not applicable |
| EMAIL_SERVICES | *(not mapped)* | Skip | Not applicable |
| SSL_CERTIFICATES | *(not mapped)* | Skip | Not applicable |
| MARKETING_CAMPAIGNS | MARKETING_CAMPAIGNS | Direct Copy | Marketing campaigns (same concept) |
| SUPPORT_AGENTS | SUPPORT_AGENTS | Direct Copy | Support staff (same concept) |
| PRODUCTS | PRODUCTS | Direct Copy | Lereta products/services |

---

## New Lereta-Specific Entities

These entities are unique to Lereta's tax and flood business:

### Tax Monitoring Module
| Entity | Purpose |
|---|---|
| LOANS | Mortgage loans tied to properties requiring tax/flood monitoring |
| TAX_RECORDS | Property tax assessment and payment tracking |
| TAX_BILLS | Individual property tax bills and payment status |
| TAX_JURISDICTIONS | Tax districts and jurisdictions (county, city, school district) |
| TAX_PAYMENTS | Property tax payment transactions |

### Flood Certification Module
| Entity | Purpose |
|---|---|
| FLOOD_CERTIFICATIONS | Flood zone determinations and life-of-loan tracking |
| FLOOD_ZONES | FEMA flood zone designations and risk levels |
| FLOOD_MAP_CHANGES | FEMA map revisions requiring re-certification |
| FLOOD_INSURANCE_REQUIREMENTS | Required flood insurance coverage |

### Compliance & Reporting Module
| Entity | Purpose |
|---|---|
| COMPLIANCE_CHECKS | Regulatory compliance monitoring and audits |
| ESCROW_ACCOUNTS | Tax and insurance escrow account tracking |
| DISBURSEMENTS | Tax payment disbursements from escrow |
| REGULATORY_REPORTS | Compliance reports for auditors |

### Unstructured Data (Cortex Search)
| Entity | Purpose |
|---|---|
| SUPPORT_TRANSCRIPTS | Customer support interaction records |
| TAX_DISPUTE_DOCUMENTS | Property tax appeal and dispute documentation |
| FLOOD_DETERMINATION_REPORTS | Detailed flood zone determination reports |

---

## Column Mapping: CUSTOMERS → CLIENTS

| GoDaddy Column | Lereta Column | Transformation |
|---|---|---|
| customer_id | client_id | Rename |
| customer_name | client_name | Rename |
| email | contact_email | Rename |
| phone | contact_phone | Rename |
| country | country | Keep (default 'USA') |
| state | state | Keep |
| city | city | Keep |
| signup_date | onboarding_date | Rename (when they started using Lereta) |
| customer_status | client_status | Rename |
| customer_segment | client_type | Rename: ENTERPRISE→NATIONAL_SERVICER, SMALL_BUSINESS→REGIONAL_LENDER, INDIVIDUAL→CREDIT_UNION |
| lifetime_value | lifetime_value | Keep |
| risk_score | service_quality_score | Rename (measure service delivery quality) |
| is_business_customer | *(removed)* | All Lereta customers are financial institutions |

---

## Column Mapping: DOMAINS → PROPERTIES

| GoDaddy Column | Lereta Column | Transformation |
|---|---|---|
| domain_id | property_id | Rename |
| customer_id | *(removed)* | Properties are tied to LOANS, not directly to CLIENTS |
| domain_name | property_address | Rename: domain → full property address |
| domain_extension | property_type | Map: .com→SINGLE_FAMILY, .net→CONDO, .org→MULTI_FAMILY, etc. |
| registration_date | first_monitored_date | Rename |
| expiration_date | *(removed)* | Properties don't expire |
| auto_renew | *(removed)* | Not applicable |
| domain_status | property_status | Rename: ACTIVE, SOLD, FORECLOSED |
| is_privacy_enabled | *(removed)* | Not applicable |
| nameservers | county | Replace: nameservers → county/jurisdiction |
| *(new)* | assessed_value | Add: Property tax assessed value |
| *(new)* | flood_zone | Add: FEMA flood zone designation |
| *(new)* | property_state | Add: State where property is located |
| *(new)* | property_city | Add: City where property is located |
| *(new)* | property_zip | Add: Zip code |

---

## Column Mapping: HOSTING_PLANS → SERVICE_SUBSCRIPTIONS

| GoDaddy Column | Lereta Column | Transformation |
|---|---|---|
| hosting_id | subscription_id | Rename |
| customer_id | client_id | Rename |
| domain_id | *(removed)* | Subscriptions are per client, not per property |
| plan_type | service_type | Map: SHARED→TAX_ONLY, VPS→FLOOD_ONLY, DEDICATED→TAX_AND_FLOOD, CLOUD→FULL_SUITE |
| plan_name | subscription_tier | Rename: Economy→BASIC, Deluxe→PROFESSIONAL, Ultimate→ENTERPRISE |
| start_date | start_date | Keep |
| end_date | end_date | Keep |
| billing_cycle | billing_cycle | Keep |
| monthly_price | monthly_price | Keep |
| disk_space_gb | property_count_limit | Replace: storage → number of properties covered |
| bandwidth_gb | *(removed)* | Not applicable |
| email_accounts_limit | user_licenses | Replace: email limit → number of user logins |
| databases_limit | api_call_limit | Replace: databases → API calls per month |
| ssl_included | advanced_analytics | Replace: SSL → advanced reporting/analytics |
| hosting_status | subscription_status | Rename |
| uptime_percentage | *(removed)* | Not applicable |

---

## New Entity Definition: LOANS

This is the CORE entity unique to Lereta - the mortgage loans that require monitoring.

| Column Name | Data Type | Description |
|---|---|---|
| loan_id | VARCHAR(50) | Primary key |
| client_id | VARCHAR(50) | Foreign key to CLIENTS |
| property_id | VARCHAR(50) | Foreign key to PROPERTIES |
| loan_number | VARCHAR(100) | Lender's loan number |
| loan_type | VARCHAR(50) | CONVENTIONAL, FHA, VA, JUMBO |
| loan_amount | NUMBER(15,2) | Original loan amount |
| loan_date | DATE | Loan origination date |
| loan_status | VARCHAR(20) | ACTIVE, PAID_OFF, FORECLOSED, SOLD |
| borrower_name | VARCHAR(200) | Primary borrower name |
| servicer_loan_number | VARCHAR(100) | Servicer's tracking number |
| tax_monitoring_required | BOOLEAN | Requires tax monitoring service |
| flood_monitoring_required | BOOLEAN | Requires flood certification |
| escrow_account | BOOLEAN | Has escrow account for taxes/insurance |
| maturity_date | DATE | Loan maturity date |
| last_status_change | DATE | Last time loan status changed |
| created_at | TIMESTAMP_NTZ | Record creation timestamp |

---

## Products Mapping

### GoDaddy Products → Lereta Products

| GoDaddy Product Type | Lereta Product Type | Examples |
|---|---|---|
| DOMAIN | *(not mapped)* | N/A |
| HOSTING | TAX_MONITORING | Basic Tax Tracking, Professional Tax Service, Enterprise Tax Suite |
| WEBSITE_BUILDER | FLOOD_CERTIFICATION | Standard Flood Cert, Life-of-Loan Flood Tracking, Full Flood Compliance |
| EMAIL | COMPLIANCE_REPORTING | Basic Reports, Advanced Analytics, Full Compliance Suite |
| SSL | *(not mapped)* | N/A |

### New Lereta Product Categories
- TAX_MONITORING: Property tax tracking, payment monitoring, delinquency alerts
- FLOOD_CERTIFICATION: Flood zone determinations, map change tracking, insurance requirements
- COMPLIANCE_REPORTING: Regulatory compliance, audit support, custom reporting
- FULL_SUITE: All services bundled (tax + flood + compliance)

---

## Semantic View Mapping

| GoDaddy Semantic View | Lereta Semantic View | Tables Included |
|---|---|---|
| SV_DOMAIN_HOSTING_INTELLIGENCE | SV_PROPERTY_LOAN_INTELLIGENCE | CLIENTS, PROPERTIES, LOANS, TAX_RECORDS, FLOOD_CERTIFICATIONS |
| SV_PRODUCT_REVENUE_INTELLIGENCE | SV_SUBSCRIPTION_REVENUE_INTELLIGENCE | CLIENTS, TRANSACTIONS, PRODUCTS, SERVICE_SUBSCRIPTIONS |
| SV_CUSTOMER_SUPPORT_INTELLIGENCE | SV_CLIENT_SUPPORT_INTELLIGENCE | CLIENTS, SUPPORT_TICKETS, SUPPORT_AGENTS |

---

## Cortex Search Mapping

| GoDaddy Search Service | Lereta Search Service | Content |
|---|---|---|
| SUPPORT_TRANSCRIPTS_SEARCH | SUPPORT_TRANSCRIPTS_SEARCH | Customer support interaction transcripts |
| DOMAIN_TRANSFER_NOTES_SEARCH | TAX_DISPUTE_DOCUMENTS_SEARCH | Property tax appeal and dispute documentation |
| KNOWLEDGE_BASE_SEARCH | FLOOD_DETERMINATION_REPORTS_SEARCH | Detailed flood zone determination reports and FEMA documentation |

---

## Questions for Approval

Before I proceed, please confirm:

1. **✅ or ❌ Entity Mapping**: Does the CLIENTS → PROPERTIES → LOANS structure make sense for Lereta's business?

2. **✅ or ❌ Core Tables**: Are these the right main tables?
   - CLIENTS (lenders/servicers)
   - PROPERTIES (real estate)
   - LOANS (mortgages)
   - TAX_RECORDS (tax tracking)
   - FLOOD_CERTIFICATIONS (flood tracking)
   - SERVICE_SUBSCRIPTIONS (Lereta services)
   - TRANSACTIONS (payments)

3. **✅ or ❌ Service Types**: Are these the right service categories?
   - TAX_ONLY
   - FLOOD_ONLY
   - TAX_AND_FLOOD
   - FULL_SUITE (tax + flood + compliance)

4. **✅ or ❌ Client Types**: Are these the right client segments?
   - NATIONAL_SERVICER (large servicers like Mr. Cooper, Rocket Mortgage)
   - REGIONAL_LENDER (regional banks and mortgage companies)
   - CREDIT_UNION (credit unions with mortgage portfolios)

5. **✅ or ❌ Unstructured Data**: Should I include these for Cortex Search?
   - Support transcripts (customer service interactions)
   - Tax dispute documents (appeals, challenges)
   - Flood determination reports (detailed certifications)

6. **✅ or ❌ Data Volumes**: Are these appropriate?
   - 10,000 clients (lenders/servicers)
   - 500,000 properties
   - 750,000 loans (some properties have multiple loans)
   - 2,000,000 tax records
   - 500,000 flood certifications
   - 1,500,000 transactions

7. **✅ or ❌ Complex Questions**: Should I generate 10 complex questions like MedTrainer?

8. **❓ Additional Tables**: Do we need tables for:
   - ESCROW_ACCOUNTS (tracking escrow balances)?
   - TAX_JURISDICTIONS (county, city, school district tax authorities)?
   - FLOOD_MAP_CHANGES (FEMA map revision tracking)?
   - TAX_BILLS (individual tax bills)?

9. **❓ Your Input**: What aspects of Lereta's business are MOST important to model?
   - Tax payment compliance and delinquency?
   - Flood certification accuracy and timeliness?
   - Revenue and subscription analytics?
   - Support efficiency?
   - All of the above?

---

## Verification Checklist (Before Writing SQL)

Once you approve this mapping, I will:

✅ Read ALL GoDaddy template files  
✅ Create table definitions following this exact mapping  
✅ Verify EVERY column name against table definitions  
✅ Verify EVERY foreign key relationship  
✅ Check for duplicate synonyms in semantic views  
✅ Verify syntax against Snowflake documentation  
✅ Create comprehensive test questions  
✅ Provide verification report BEFORE you test  

---

## Next Steps

**WAITING FOR YOUR APPROVAL**

Please review this mapping and:
1. Answer ✅ or ❌ to questions 1-7
2. Provide guidance on question 8 (additional tables)
3. Answer question 9 (business priorities)
4. Tell me if anything is incorrect or missing

**I WILL NOT WRITE ANY SQL UNTIL YOU APPROVE THIS MAPPING.**

---

**NO GUESSING - ALL MAPPINGS BASED ON:**
- Lereta.com business description
- Financial services industry knowledge
- GoDaddy template structure
- MedTrainer lessons learned

**Version:** 1.0 - DRAFT  
**Status:** AWAITING APPROVAL  
**Created:** October 18, 2025

