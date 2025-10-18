<img src="Snowflake_Logo.svg" width="200">

# Lereta Intelligence Agent Solution

## About Lereta

Lereta is a leading national provider of comprehensive, technologically advanced tax and flood services to the financial services industry. Their platform delivers extraordinary service to mortgage lenders and servicers, emphasizing flexibility to tailor solutions to individual client needs.

### Key Business Lines

- **Tax Services**: Property tax tracking, payment monitoring, delinquency alerts, escrow management
- **Flood Services**: FEMA flood zone determinations, life-of-loan monitoring, map change tracking, insurance requirement verification
- **Compliance Services**: Regulatory compliance, audit support, custom reporting, API access

### Market Position

- Leading tax and flood services provider for mortgage industry
- Serving major national servicers, regional lenders, and credit unions nationwide
- Comprehensive solution for property tax and flood certification compliance

## Project Overview

This Snowflake Intelligence solution demonstrates how Lereta can leverage AI agents to analyze:

- **Property Tax Monitoring**: Payment status, delinquency tracking, assessment changes, jurisdiction management
- **Flood Certifications**: FEMA zone determinations, insurance requirements, map change alerts, life-of-loan tracking
- **Loan Portfolio Analytics**: Loan status, borrower information, property details, monitoring requirements
- **Subscription Analytics**: Service utilization, renewal rates, client health
- **Revenue Intelligence**: Transaction trends, service performance, pricing optimization
- **Support Operations**: Ticket resolution, agent performance, customer satisfaction
- **Unstructured Data Search**: Semantic search over support transcripts, tax dispute documents, and flood determination reports using Cortex Search

## Database Schema

The solution includes:

1. **RAW Schema**: Core business tables
   - CLIENTS: Financial institution master data (lenders/servicers)
   - PROPERTIES: Real estate properties being monitored
   - LOANS: Mortgage loans requiring tax and flood monitoring
   - TAX_JURISDICTIONS: Tax districts and authorities
   - TAX_RECORDS: Property tax tracking and payment status
   - TAX_BILLS: Individual tax bills
   - TAX_PAYMENTS: Tax payment transactions
   - FLOOD_ZONES: FEMA flood zone definitions
   - FLOOD_CERTIFICATIONS: Flood zone determinations
   - FLOOD_MAP_CHANGES: FEMA map revision tracking
   - ESCROW_ACCOUNTS: Tax and insurance escrow tracking
   - DISBURSEMENTS: Tax payment disbursements
   - COMPLIANCE_CHECKS: Regulatory compliance monitoring
   - SERVICE_SUBSCRIPTIONS: Lereta service subscriptions
   - TRANSACTIONS: Financial transactions
   - SUPPORT_TICKETS: Customer support cases
   - SUPPORT_AGENTS: Support team data
   - PRODUCTS: Lereta product catalog
   - MARKETING_CAMPAIGNS: Campaign tracking
   - SUPPORT_TRANSCRIPTS: Unstructured support interaction records (25K transcripts)
   - TAX_DISPUTE_DOCUMENTS: Unstructured tax dispute documentation (15K documents)
   - FLOOD_DETERMINATION_REPORTS: Detailed flood determination reports (20K reports)

2. **ANALYTICS Schema**: Curated views and semantic models
   - Client 360 views
   - Property tax analytics
   - Loan analytics
   - Tax compliance metrics
   - Flood certification analytics
   - Subscription and revenue analytics
   - Support efficiency metrics
   - Semantic views for AI agents

3. **Cortex Search Services**: Semantic search over unstructured data
   - SUPPORT_TRANSCRIPTS_SEARCH: Search customer support interactions
   - TAX_DISPUTE_DOCUMENTS_SEARCH: Search tax dispute and appeal documentation
   - FLOOD_DETERMINATION_REPORTS_SEARCH: Search flood determination reports and FEMA documentation

## Files

- `sql/setup/01_database_and_schema.sql`: Database and schema creation
- `sql/setup/02_create_tables.sql`: Table definitions with proper constraints (24 tables)
- `sql/data/03_generate_synthetic_data.sql`: Realistic sample data generation
- `sql/views/04_create_views.sql`: Analytical views
- `sql/views/05_create_semantic_views.sql`: Semantic views for AI agents (verified syntax)
- `sql/search/06_create_cortex_search.sql`: Unstructured data tables and Cortex Search services
- `docs/questions.md`: 10 complex questions the agent can answer
- `docs/AGENT_SETUP.md`: Configuration instructions for Snowflake agents
- `MAPPING_DOCUMENT.md`: Entity mapping from GoDaddy template to Lereta

## Setup Instructions

1. Execute SQL files in order (01 through 06)
2. Follow AGENT_SETUP.md for agent configuration
3. Test with questions from questions.md
4. Test Cortex Search with sample queries in AGENT_SETUP.md Step 5

## Data Model Highlights

### Structured Data
- Realistic tax and flood monitoring scenarios
- Multi-tier service subscriptions (Tax Only, Flood Only, Tax and Flood, Full Suite)
- Comprehensive client segments (National Servicer, Regional Lender, Credit Union)
- Property tax tracking with jurisdiction and payment workflows
- Flood certification with FEMA zone tracking and insurance requirements
- Escrow account management and disbursement tracking
- Compliance monitoring and regulatory reporting

### Unstructured Data
- 25,000 customer support transcripts with realistic tax and flood interactions
- 15,000 tax dispute and appeal documents with resolution details
- 20,000 flood determination reports with insurance requirement analysis
- Semantic search powered by Snowflake Cortex Search
- RAG (Retrieval Augmented Generation) ready for AI agents

## Key Features

✅ **Hybrid Data Architecture**: Combines structured tables with unstructured text data  
✅ **Semantic Search**: Find similar issues and solutions by meaning, not just keywords  
✅ **RAG-Ready**: Agent can retrieve context from support transcripts, tax disputes, and flood reports  
✅ **Production-Ready Syntax**: All SQL verified against Snowflake documentation  
✅ **Comprehensive Demo**: 10K clients, 500K properties, 750K loans, 2M+ tax records, 500K flood certs  
✅ **Verified Syntax**: CREATE SEMANTIC VIEW and CREATE CORTEX SEARCH SERVICE syntax verified against official Snowflake documentation

## Complex Questions Examples

The agent can answer sophisticated questions like:

1. **Tax Delinquency Analysis**: Identify properties with delinquent taxes and penalty amounts
2. **Flood Insurance Requirements**: Track properties requiring flood insurance by zone
3. **Escrow Analysis**: Calculate escrow account shortfalls and surplus
4. **Tax Assessment Changes**: Analyze properties with significant assessment increases
5. **Client Health Monitoring**: Identify clients at risk of churn based on usage patterns
6. **Revenue Trend Analysis**: Monthly revenue patterns with seasonality detection
7. **Support Efficiency Metrics**: Resolution times by issue type and channel
8. **Loan Portfolio Analytics**: Analyze loans by type, status, and monitoring requirements
9. **Cross-Sell Opportunities**: Clients using only tax or flood services
10. **Service Performance**: Analyze service delivery quality by client segment

Plus unstructured data questions for semantic search over transcripts, tax disputes, and flood reports.

## Semantic Views

The solution includes three verified semantic views:

1. **SV_PROPERTY_LOAN_TAX_INTELLIGENCE**: Comprehensive view of clients, properties, loans, tax records, and flood certifications
2. **SV_SUBSCRIPTION_REVENUE_INTELLIGENCE**: Subscriptions, products, transactions, and revenue metrics
3. **SV_CLIENT_SUPPORT_INTELLIGENCE**: Support tickets, agents, and customer satisfaction

All semantic views follow the verified syntax structure:
- TABLES clause with PRIMARY KEY definitions
- RELATIONSHIPS clause defining foreign keys
- DIMENSIONS clause with synonyms and comments
- METRICS clause with aggregations and calculations
- Proper clause ordering (TABLES → RELATIONSHIPS → DIMENSIONS → METRICS → COMMENT)

## Cortex Search Services

Three Cortex Search services enable semantic search over unstructured data:

1. **SUPPORT_TRANSCRIPTS_SEARCH**: Search 25,000 customer support interactions
   - Find similar issues by description, not exact keywords
   - Retrieve resolution procedures from past successful cases
   - Analyze support patterns and best practices

2. **TAX_DISPUTE_DOCUMENTS_SEARCH**: Search 15,000 tax dispute documents
   - Find similar assessment appeals and disputes
   - Identify successful appeal strategies
   - Retrieve dispute resolution procedures

3. **FLOOD_DETERMINATION_REPORTS_SEARCH**: Search 20,000 flood determination reports
   - Retrieve flood zone determination details
   - Find insurance requirement analysis
   - Access FEMA map change documentation

All Cortex Search services use verified syntax:
- ON clause specifying search column
- ATTRIBUTES clause for filterable columns
- WAREHOUSE assignment
- TARGET_LAG for refresh frequency
- AS clause with source query

## Syntax Verification

All SQL syntax has been verified against official Snowflake documentation:

- **CREATE SEMANTIC VIEW**: https://docs.snowflake.com/en/sql-reference/sql/create-semantic-view
- **CREATE CORTEX SEARCH SERVICE**: https://docs.snowflake.com/en/sql-reference/sql/create-cortex-search
- **Cortex Search Overview**: https://docs.snowflake.com/en/user-guide/snowflake-cortex/cortex-search/cortex-search-overview

Key verification points:
- ✅ Clause order is mandatory (TABLES → RELATIONSHIPS → DIMENSIONS → METRICS)
- ✅ PRIMARY KEY columns must exist in source tables
- ✅ No self-referencing or cyclic relationships
- ✅ Semantic expression format: `name AS expression`
- ✅ Change tracking enabled for Cortex Search tables
- ✅ Correct ATTRIBUTES syntax for filterable columns

## Getting Started

### Prerequisites
- Snowflake account with Cortex Intelligence enabled
- ACCOUNTADMIN or equivalent privileges
- X-SMALL or larger warehouse

### Quick Start
```sql
-- 1. Create database and schemas
@sql/setup/01_database_and_schema.sql

-- 2. Create tables
@sql/setup/02_create_tables.sql

-- 3. Generate sample data (10-20 minutes)
@sql/data/03_generate_synthetic_data.sql

-- 4. Create analytical views
@sql/views/04_create_views.sql

-- 5. Create semantic views
@sql/views/05_create_semantic_views.sql

-- 6. Create Cortex Search services (5-10 minutes)
@sql/search/06_create_cortex_search.sql
```

### Configure Agent
Follow the detailed instructions in `docs/AGENT_SETUP.md` to:
1. Create the Snowflake Intelligence Agent
2. Add semantic views as data sources
3. Configure Cortex Search services
4. Set up system prompts
5. Test with sample questions

## Testing

### Verify Installation
```sql
-- Check semantic views
SHOW SEMANTIC VIEWS IN SCHEMA LERETA_INTELLIGENCE.ANALYTICS;

-- Check Cortex Search services
SHOW CORTEX SEARCH SERVICES IN SCHEMA LERETA_INTELLIGENCE.RAW;

-- Test Cortex Search
SELECT PARSE_JSON(
  SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
      'LERETA_INTELLIGENCE.RAW.SUPPORT_TRANSCRIPTS_SEARCH',
      '{"query": "tax payment delinquency", "limit":5}'
  )
)['results'] as results;
```

### Sample Test Questions
1. "How many properties have delinquent property taxes?"
2. "Which properties require flood insurance due to high-risk zones?"
3. "Show me tax dispute documents about assessment appeals"
4. "Find flood determination reports for Zone AE properties"

## Data Volumes

- **Clients**: 10,000
- **Properties**: 500,000
- **Loans**: 750,000
- **Tax Records**: 2,000,000
- **Flood Certifications**: 500,000
- **Service Subscriptions**: 9,500
- **Transactions**: 1,500,000
- **Support Tickets**: 75,000
- **Support Transcripts**: 25,000 (unstructured)
- **Tax Dispute Documents**: 15,000 (unstructured)
- **Flood Determination Reports**: 20,000 (unstructured)

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                   Snowflake Intelligence Agent                   │
│                                                                  │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │              Semantic Views (Structured Data)              │ │
│  │  • SV_PROPERTY_LOAN_TAX_INTELLIGENCE                       │ │
│  │  • SV_SUBSCRIPTION_REVENUE_INTELLIGENCE                    │ │
│  │  • SV_CLIENT_SUPPORT_INTELLIGENCE                          │ │
│  └────────────────────────────────────────────────────────────┘ │
│                                                                  │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │          Cortex Search (Unstructured Data)                 │ │
│  │  • SUPPORT_TRANSCRIPTS_SEARCH                              │ │
│  │  • TAX_DISPUTE_DOCUMENTS_SEARCH                            │ │
│  │  • FLOOD_DETERMINATION_REPORTS_SEARCH                      │ │
│  └────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌──────────────────────────────────────────┐
        │         RAW Schema (Source Data)         │
        │  • Clients, Properties, Loans            │
        │  • Tax Records, Flood Certifications     │
        │  • Subscriptions, Transactions           │
        │  • Support Tickets, Compliance           │
        │  • Support Transcripts (Unstructured)    │
        │  • Tax Disputes (Unstructured)           │
        │  • Flood Reports (Unstructured)          │
        └──────────────────────────────────────────┘
```

## Support

For questions or issues:
- Review `docs/AGENT_SETUP.md` for detailed setup instructions
- Check `docs/questions.md` for example questions
- Consult Snowflake documentation for syntax verification
- Contact your Snowflake account team for assistance

## Version History

- **v1.0** (October 2025): Initial release
  - Verified semantic view syntax
  - Verified Cortex Search syntax
  - 10K clients, 500K properties, 750K loans, 2M tax records
  - 25K support transcripts with semantic search
  - 10 complex test questions
  - Comprehensive documentation

## License

This solution is provided as a template for building Snowflake Intelligence agents. Adapt as needed for your specific use case.

---

**Created**: October 2025  
**Template Based On**: GoDaddy Intelligence Demo  
**Snowflake Documentation**: Syntax verified against official documentation  
**Target Use Case**: Lereta tax monitoring, flood certification, and compliance intelligence

**NO GUESSING - ALL SYNTAX VERIFIED** ✅

