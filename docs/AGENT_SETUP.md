<img src="..\Snowflake_Logo.svg" width="200">

# Lereta Intelligence Agent - Setup Guide

This guide walks through configuring a Snowflake Intelligence agent for Lereta's tax monitoring, flood certification, and compliance intelligence solution.

---

## Prerequisites

1. **Snowflake Account** with:
   - Snowflake Intelligence (Cortex) enabled
   - Appropriate warehouse size (recommended: X-SMALL or larger)
   - Permissions to create databases, schemas, tables, and semantic views

2. **Roles and Permissions**:
   - `ACCOUNTADMIN` role or equivalent for initial setup
   - `CREATE DATABASE` privilege
   - `CREATE SEMANTIC VIEW` privilege
   - `CREATE CORTEX SEARCH SERVICE` privilege
   - `USAGE` on warehouses

---

## Step 1: Execute SQL Scripts in Order

Execute the SQL files in the following sequence:

### 1.1 Database Setup
```sql
-- Execute: sql/setup/01_database_and_schema.sql
-- Creates database, schemas (RAW, ANALYTICS), and warehouse
-- Execution time: < 1 second
```

### 1.2 Create Tables
```sql
-- Execute: sql/setup/02_create_tables.sql
-- Creates all table structures with proper relationships
-- Tables: CLIENTS, PROPERTIES, LOANS, TAX_RECORDS, FLOOD_CERTIFICATIONS,
--         SERVICE_SUBSCRIPTIONS, TRANSACTIONS, SUPPORT_TICKETS, etc.
-- Execution time: < 5 seconds
```

### 1.3 Generate Sample Data
```sql
-- Execute: sql/data/03_generate_synthetic_data.sql
-- Generates realistic sample data:
--   - 10,000 clients (financial institutions)
--   - 500,000 properties
--   - 750,000 loans
--   - 2,000,000 tax records
--   - 500,000 flood certifications
--   - 1,500,000 transactions
--   - 75,000 support tickets
-- Execution time: 10-20 minutes (depending on warehouse size)
```

### 1.4 Create Analytical Views
```sql
-- Execute: sql/views/04_create_views.sql
-- Creates curated analytical views:
--   - V_CLIENT_360
--   - V_PROPERTY_TAX_ANALYTICS
--   - V_LOAN_ANALYTICS
--   - V_TAX_COMPLIANCE_ANALYTICS
--   - V_FLOOD_CERTIFICATION_ANALYTICS
--   - V_SUBSCRIPTION_ANALYTICS
--   - V_REVENUE_ANALYTICS
--   - V_SUPPORT_ANALYTICS
-- Execution time: < 5 seconds
```

### 1.5 Create Semantic Views
```sql
-- Execute: sql/views/05_create_semantic_views.sql
-- Creates semantic views for AI agents (VERIFIED SYNTAX):
--   - SV_PROPERTY_LOAN_TAX_INTELLIGENCE
--   - SV_SUBSCRIPTION_REVENUE_INTELLIGENCE
--   - SV_CLIENT_SUPPORT_INTELLIGENCE
-- Execution time: < 5 seconds
```

### 1.6 Create Cortex Search Services
```sql
-- Execute: sql/search/06_create_cortex_search.sql
-- Creates tables for unstructured text data:
--   - SUPPORT_TRANSCRIPTS (25,000 support interactions)
--   - TAX_DISPUTE_DOCUMENTS (15,000 dispute documents)
--   - FLOOD_DETERMINATION_REPORTS (20,000 flood reports)
-- Creates Cortex Search services for semantic search:
--   - SUPPORT_TRANSCRIPTS_SEARCH
--   - TAX_DISPUTE_DOCUMENTS_SEARCH
--   - FLOOD_DETERMINATION_REPORTS_SEARCH
-- Execution time: 5-10 minutes (data generation + index building)
```

---

## Step 2: Grant Cortex Analyst Permissions

Before creating the agent, ensure proper permissions are configured:

### 2.1 Grant Database Role for Cortex Analyst

```sql
USE ROLE ACCOUNTADMIN;

-- Grant Cortex Analyst user role to your role
GRANT DATABASE ROLE SNOWFLAKE.CORTEX_ANALYST_USER TO ROLE <your_role>;

-- Grant usage on the database and schemas
GRANT USAGE ON DATABASE LERETA_INTELLIGENCE TO ROLE <your_role>;
GRANT USAGE ON SCHEMA LERETA_INTELLIGENCE.ANALYTICS TO ROLE <your_role>;
GRANT USAGE ON SCHEMA LERETA_INTELLIGENCE.RAW TO ROLE <your_role>;

-- Grant privileges on semantic views
GRANT REFERENCES, SELECT ON SEMANTIC VIEW LERETA_INTELLIGENCE.ANALYTICS.SV_PROPERTY_LOAN_TAX_INTELLIGENCE TO ROLE <your_role>;
GRANT REFERENCES, SELECT ON SEMANTIC VIEW LERETA_INTELLIGENCE.ANALYTICS.SV_SUBSCRIPTION_REVENUE_INTELLIGENCE TO ROLE <your_role>;
GRANT REFERENCES, SELECT ON SEMANTIC VIEW LERETA_INTELLIGENCE.ANALYTICS.SV_CLIENT_SUPPORT_INTELLIGENCE TO ROLE <your_role>;

-- Grant usage on warehouse
GRANT USAGE ON WAREHOUSE LERETA_WH TO ROLE <your_role>;

-- Grant usage on Cortex Search services
GRANT USAGE ON CORTEX SEARCH SERVICE LERETA_INTELLIGENCE.RAW.SUPPORT_TRANSCRIPTS_SEARCH TO ROLE <your_role>;
GRANT USAGE ON CORTEX SEARCH SERVICE LERETA_INTELLIGENCE.RAW.TAX_DISPUTE_DOCUMENTS_SEARCH TO ROLE <your_role>;
GRANT USAGE ON CORTEX SEARCH SERVICE LERETA_INTELLIGENCE.RAW.FLOOD_DETERMINATION_REPORTS_SEARCH TO ROLE <your_role>;
```

---

## Step 3: Create Snowflake Intelligence Agent

### Step 3.1: Create the Agent

1. In Snowsight, click on **AI & ML** > **Agents**
2. Click on **Create Agent**
3. Select **Create this agent for Snowflake Intelligence**
4. Configure:
   - **Agent Object Name**: `LERETA_INTELLIGENCE_AGENT`
   - **Display Name**: `Lereta Intelligence Agent`
5. Click **Create**

### Step 3.2: Add Description and Instructions

1. Click on **LERETA_INTELLIGENCE_AGENT** to open the agent
2. Click **Edit** on the top right corner
3. In the **Description** section, add:
   ```
   This agent orchestrates between Lereta tax monitoring, flood certification, and compliance data 
   for analyzing structured metrics using Cortex Analyst (semantic views) and unstructured 
   content using Cortex Search services (support transcripts, tax disputes, flood reports).
   ```

### Step 3.3: Configure Response Instructions

1. Click on **Instructions** in the left pane
2. Enter the following **Response Instructions**:
   ```
   You are a specialized analytics assistant for Lereta, a tax and flood services provider 
   for the financial services industry. Your primary objectives are:

   For structured data queries (metrics, KPIs, compliance figures):
   - Use the Cortex Analyst semantic views for property tax monitoring, flood certifications, 
     loan portfolio analysis, and revenue tracking
   - Provide direct, numerical answers with minimal explanation
   - Format responses clearly with relevant units and time periods
   - Only include essential context needed to understand the metric

   For unstructured content (support transcripts, tax disputes, flood reports):
   - Use Cortex Search services to find similar cases, procedures, and documentation
   - Extract relevant information from past interactions and determinations
   - Summarize findings in brief, focused responses
   - Maintain context from the original source documents

   Operating guidelines:
   - Always identify whether you're using Cortex Analyst or Cortex Search for each response
   - Keep responses under 3-4 sentences when possible
   - Present numerical data in a structured format
   - Don't speculate beyond available data
   - Highlight tax delinquencies and flood insurance requirements prominently
   - For tax monitoring, always check payment status and delinquency dates
   - For flood certifications, always indicate if flood insurance is required
   ```

3. **Add Sample Questions** (click "Add a question" for each):
   - "How many properties have delinquent property taxes?"
   - "Which properties require flood insurance due to high-risk zones?"
   - "Search tax dispute documents for successful assessment appeals"

---

### Step 3.4: Add Cortex Analyst Tools (Semantic Views)

1. Click on **Tools** in the left pane
2. Find **Cortex Analyst** and click **+ Add**

**Add Semantic View 1: Property Loan & Tax Intelligence**

1. **Name**: `Property_Loan_Tax_Intelligence`
2. Click on **Semantic view** radio button
3. Click on **Database** dropdown and choose `LERETA_INTELLIGENCE.ANALYTICS`
4. Click on the semantic view to highlight it: `SV_PROPERTY_LOAN_TAX_INTELLIGENCE`
5. Select **Warehouse**: `LERETA_WH`
6. **Query timeout (seconds)**: `60`
7. **Description** (or click generate):
   ```
   Analyzes property tax monitoring, flood certifications, loan portfolio, and client 
   relationships. Use for questions about tax payment status, delinquencies, flood 
   insurance requirements, loan details, and property monitoring.
   ```
8. Once the **Add** button is highlighted blue, click **Add**

**Add Semantic View 2: Subscription & Revenue Intelligence**

1. Click **+ Add** again under Cortex Analyst
2. **Name**: `Subscription_Revenue_Intelligence`
3. Click on **Semantic view** radio button
4. Click on **Database** dropdown and choose `LERETA_INTELLIGENCE.ANALYTICS`
5. Click on the semantic view to highlight it: `SV_SUBSCRIPTION_REVENUE_INTELLIGENCE`
6. Select **Warehouse**: `LERETA_WH`
7. **Query timeout (seconds)**: `60`
8. **Description**:
   ```
   Analyzes service subscription health, revenue trends, transaction patterns, and product
   performance. Use for questions about subscription renewals, revenue analysis,
   service adoption, and client lifetime value.
   ```
9. Click **Add**

**Add Semantic View 3: Client Support Intelligence**

1. Click **+ Add** again under Cortex Analyst
2. **Name**: `Client_Support_Intelligence`
3. Click on **Semantic view** radio button
4. Click on **Database** dropdown and choose `LERETA_INTELLIGENCE.ANALYTICS`
5. Click on the semantic view to highlight it: `SV_CLIENT_SUPPORT_INTELLIGENCE`
6. Select **Warehouse**: `LERETA_WH`
7. **Query timeout (seconds)**: `60`
8. **Description**:
   ```
   Analyzes support ticket resolution, agent performance, and customer satisfaction.
   Use for questions about support efficiency, ticket trends, agent productivity,
   and client satisfaction metrics.
   ```
9. Click **Add**

---

### Step 3.5: Add Cortex Search Services

Still in the **Tools** section:

**Add Cortex Search Service 1: Support Transcripts Search**

1. Find **Cortex Search Services** and click **+ Add**
2. **Name**: `Support_Transcripts_Search`
3. **Description**:
   ```
   Search 25,000 customer support transcripts to find similar issues, resolution 
   procedures, and support best practices. Use for questions about tax payment issues, 
   flood certification processes, escrow questions, and common support scenarios.
   ```
4. Click on **Database** dropdown and choose `LERETA_INTELLIGENCE.RAW`
5. Choose the search service from the dropdown: `SUPPORT_TRANSCRIPTS_SEARCH`
6. For **ID Column**: `transcript_id` (used to generate hyperlink to source)
7. For **Title Column**: `transcript_text` (the search field)
8. Click **Add**

**Add Cortex Search Service 2: Tax Dispute Documents Search**

1. Click **+ Add** again under Cortex Search Services
2. **Name**: `Tax_Dispute_Documents_Search`
3. **Description**:
   ```
   Search 15,000 tax dispute and appeal documents to find similar cases, successful 
   appeals, and resolution strategies. Use for questions about property tax assessments, 
   appeals, exemptions, and dispute outcomes.
   ```
4. Click on **Database** dropdown and choose `LERETA_INTELLIGENCE.RAW`
5. Choose the search service from the dropdown: `TAX_DISPUTE_DOCUMENTS_SEARCH`
6. For **ID Column**: `document_id`
7. For **Title Column**: `document_text`
8. Click **Add**

**Add Cortex Search Service 3: Flood Determination Reports Search**

1. Click **+ Add** again under Cortex Search Services
2. **Name**: `Flood_Determination_Reports_Search`
3. **Description**:
   ```
   Search 20,000 flood determination reports for FEMA zone information, insurance 
   requirements, and determination procedures. Use for questions about flood zones, 
   insurance requirements, LOMA processes, and FEMA regulations.
   ```
4. Click on **Database** dropdown and choose `LERETA_INTELLIGENCE.RAW`
5. Choose the search service from the dropdown: `FLOOD_DETERMINATION_REPORTS_SEARCH`
6. For **ID Column**: `report_id`
7. For **Title Column**: `report_text`
8. Click **Add**

---

### Step 3.6: Configure Orchestration

1. Click on **Orchestration** in the left pane
2. **Orchestration model**: Leave as **Auto** (or select a specific model like `mistral-large2`)
3. In the **Planning instructions**, add:
   ```
   If a query spans both structured and unstructured data, clearly separate the sources.
   
   For any query, first determine whether it requires:
   (a) Structured data analysis → Use Cortex Analyst semantic views
   (b) Document content/context → Use Cortex Search
   (c) Both → Combine both services with clear source attribution
   
   Please confirm which approach you'll use before providing each response.
   
   For tax monitoring queries, always check payment status and delinquency flags.
   For flood certification queries, highlight insurance requirements.
   For property queries, include both tax and flood status.
   ```
4. Click **Save** on the top right

---

### Step 3.7: Set Up Access to the Agent

1. Click on **Access** in the left pane
2. Click **Add role**
3. Select the role(s) that should have access to the agent
4. Click **Save** on the top right

---

### Step 3.8: Test the Agent

1. Return to the agent details page (if you clicked Save, you should be back at the main agent view)
2. Use the agent playground at the bottom
3. Ask a simple question: **"How many clients are in the system?"**
4. Verify the agent:
   - Identifies it will use Cortex Analyst
   - Selects the appropriate semantic view
   - Generates a SQL query
   - Returns the correct count (~10,000 clients)
5. Review the generated SQL to ensure it's correct

---

## Step 4: Test the Complete Agent

### 4.1 Simple Test Questions

Start with simple questions to verify connectivity:

1. **"How many financial institution clients are using Lereta?"**
   - Should query SV_PROPERTY_LOAN_TAX_INTELLIGENCE or SV_SUBSCRIPTION_REVENUE_INTELLIGENCE
   - Expected: ~10,000 clients

2. **"What is the total number of properties being monitored?"**
   - Should query SV_PROPERTY_LOAN_TAX_INTELLIGENCE
   - Expected: ~500,000 properties

3. **"How many support tickets are currently open?"**
   - Should query SV_CLIENT_SUPPORT_INTELLIGENCE
   - Expected: Count of tickets with status = 'OPEN'

### 4.2 Complex Test Questions

Test with the 10 complex questions provided in `docs/questions.md`, including:

1. Tax Delinquency Analysis
2. Flood Insurance Requirements Tracking
3. Escrow Account Management
4. Property Tax Assessment Analysis
5. Client Service Utilization
6. Revenue Trend Analysis
7. Loan Portfolio Risk Assessment
8. Cross-Sell Service Opportunities
9. Support Efficiency Benchmarking
10. Tax Jurisdiction Analysis

### 4.3 Cortex Search Test Questions

Test unstructured data search:

1. **"Search support transcripts for tax payment issues"**
2. **"Find tax dispute documents about successful assessment appeals"**
3. **"What do flood determination reports say about Zone AE properties?"**

---

## Step 5: Query Cortex Search Services Directly (Optional)

You can also query Cortex Search services directly using SQL for testing:

### Query Support Transcripts
```sql
SELECT PARSE_JSON(
  SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
      'LERETA_INTELLIGENCE.RAW.SUPPORT_TRANSCRIPTS_SEARCH',
      '{
        "query": "tax delinquency help",
        "columns":["transcript_text", "interaction_type"],
        "limit":10
      }'
  )
)['results'] as results;
```

### Query Tax Dispute Documents
```sql
SELECT PARSE_JSON(
  SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
      'LERETA_INTELLIGENCE.RAW.TAX_DISPUTE_DOCUMENTS_SEARCH',
      '{
        "query": "assessment appeal successful",
        "columns":["document_text", "dispute_status"],
        "limit":10
      }'
  )
)['results'] as results;
```

### Query Flood Determination Reports
```sql
SELECT PARSE_JSON(
  SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
      'LERETA_INTELLIGENCE.RAW.FLOOD_DETERMINATION_REPORTS_SEARCH',
      '{
        "query": "flood insurance required high risk",
        "columns":["report_text", "flood_zone_determined"],
        "limit":5
      }'
  )
)['results'] as results;
```

---

## Step 6: Additional Access Control (Optional)

### Create Role for Agent Users

If you need to create additional roles for other users:
```sql
CREATE ROLE IF NOT EXISTS LERETA_AGENT_USER;

-- Grant necessary privileges
GRANT USAGE ON DATABASE LERETA_INTELLIGENCE TO ROLE LERETA_AGENT_USER;
GRANT USAGE ON SCHEMA LERETA_INTELLIGENCE.ANALYTICS TO ROLE LERETA_AGENT_USER;
GRANT USAGE ON SCHEMA LERETA_INTELLIGENCE.RAW TO ROLE LERETA_AGENT_USER;
GRANT SELECT ON ALL VIEWS IN SCHEMA LERETA_INTELLIGENCE.ANALYTICS TO ROLE LERETA_AGENT_USER;
GRANT USAGE ON WAREHOUSE LERETA_WH TO ROLE LERETA_AGENT_USER;

-- Grant Cortex Search usage
GRANT USAGE ON CORTEX SEARCH SERVICE LERETA_INTELLIGENCE.RAW.SUPPORT_TRANSCRIPTS_SEARCH TO ROLE LERETA_AGENT_USER;
GRANT USAGE ON CORTEX SEARCH SERVICE LERETA_INTELLIGENCE.RAW.TAX_DISPUTE_DOCUMENTS_SEARCH TO ROLE LERETA_AGENT_USER;
GRANT USAGE ON CORTEX SEARCH SERVICE LERETA_INTELLIGENCE.RAW.FLOOD_DETERMINATION_REPORTS_SEARCH TO ROLE LERETA_AGENT_USER;

-- Grant to specific user
GRANT ROLE LERETA_AGENT_USER TO USER your_username;
```

---

## Troubleshooting

### Issue: Semantic views not found

**Solution:**
```sql
-- Verify semantic views exist
SHOW SEMANTIC VIEWS IN SCHEMA LERETA_INTELLIGENCE.ANALYTICS;

-- Check permissions
SHOW GRANTS ON SEMANTIC VIEW SV_PROPERTY_LOAN_TAX_INTELLIGENCE;
```

### Issue: Cortex Search returns no results

**Solution:**
```sql
-- Verify service exists and is populated
SHOW CORTEX SEARCH SERVICES IN SCHEMA RAW;

-- Check data in source table
SELECT COUNT(*) FROM RAW.SUPPORT_TRANSCRIPTS;

-- Verify change tracking is enabled
SHOW TABLES LIKE 'SUPPORT_TRANSCRIPTS';
```

### Issue: Slow query performance

**Solution:**
- Increase warehouse size (MEDIUM or LARGE)
- Check for missing filters on date columns
- Review query execution plan
- Consider materializing frequently-used aggregations

---

## Success Metrics

Your agent is successfully configured when:

✅ All 6 SQL scripts execute without errors  
✅ All semantic views are created and validated  
✅ All 3 Cortex Search services are created and indexed  
✅ Agent can answer simple test questions  
✅ Agent can answer complex analytical questions  
✅ Cortex Search returns relevant results  
✅ Query performance is acceptable (< 30 seconds for complex queries)  
✅ Results are accurate and match expected business logic  

---

## Support Resources

- **Snowflake Documentation**: https://docs.snowflake.com/en/sql-reference/sql/create-semantic-view
- **Lereta Website**: https://www.lereta.com
- **Snowflake Community**: https://community.snowflake.com

---

**Version:** 1.0  
**Created:** October 2025  
**Based on:** MedTrainer Intelligence Template


