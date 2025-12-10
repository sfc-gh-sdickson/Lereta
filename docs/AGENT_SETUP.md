<img src="../Snowflake_Logo.svg" width="200">

# Lereta Intelligence Agent - Complete Setup Guide

This comprehensive guide walks through the complete setup of the Lereta Intelligence Agent, integrating structured analytics, unstructured search, and machine learning predictions.

---

## Prerequisites

### Snowflake Requirements
- Snowflake account with Cortex Intelligence enabled
- ACCOUNTADMIN or equivalent privileges
- X-SMALL or larger warehouse
- Python environment (for ML training)

### Required Privileges
- CREATE DATABASE
- CREATE SEMANTIC VIEW
- CREATE CORTEX SEARCH SERVICE  
- CREATE FUNCTION
- USAGE on warehouses

---

## Part 1: Data Foundation

Execute SQL scripts sequentially to build the data foundation.

### Step 1: Database Setup

```sql
USE ROLE ACCOUNTADMIN;

-- Create database and schemas
@sql/setup/01_database_and_schema.sql

-- Create all tables (24 tables)
@sql/setup/02_create_tables.sql
```

**Time**: < 1 minute

### Step 2: Generate Sample Data

```sql
-- Generate 3.8M+ records
@sql/data/03_generate_synthetic_data.sql
```

**Generates**:
- 10,000 clients
- 500,000 properties
- 750,000 loans
- 2,000,000 tax records
- 500,000 flood certifications
- 1,500,000 transactions
- 75,000 support tickets

**Time**: 10-20 minutes

### Step 3: Create Analytics Layer

```sql
-- Create analytical views
@sql/views/04_create_views.sql

-- Create semantic views for AI
@sql/views/05_create_semantic_views.sql
```

**Creates**:
- 8 analytical views
- 3 semantic views

**Time**: < 1 minute

### Step 4: Enable Document Search

```sql
-- Create search services and documents
@sql/search/06_create_cortex_search.sql
```

**Generates**:
- 25,000 support transcripts
- 15,000 tax dispute documents
- 20,000 flood determination reports
- 3 Cortex Search services

**Time**: 5-10 minutes

---

## Part 2: Machine Learning Models

### Step 5: Train ML Models

Open the Jupyter notebook and execute all cells:

```bash
cd notebooks
jupyter notebook ML_Models_Lereta.ipynb
```

**Configuration** (Cell 2):
```python
connection_params = {
    "account": "<your_account>",
    "user": "<your_user>",
    "password": "<your_password>",
    "role": "ACCOUNTADMIN",
    "warehouse": "LERETA_WH",
    "database": "LERETA_INTELLIGENCE",
    "schema": "RAW"
}
```

**Trains**:
- Tax Delinquency Predictor (Random Forest, F1: 0.85)
- Client Churn Predictor (XGBoost, F1: 0.78)
- Loan Risk Classifier (Random Forest, Accuracy: 0.89)

**Time**: 15-30 minutes

### Step 6: Deploy ML Wrappers

```sql
-- Deploy ML functions and feature views
@sql/ml/07_ml_model_wrappers.sql
```

**Creates**:
- 3 SQL UDFs (PREDICT_TAX_DELINQUENCY, PREDICT_CLIENT_CHURN, CLASSIFY_LOAN_RISK)
- 3 feature preparation views

**Time**: < 1 minute

### Step 7: Configure Agent Infrastructure

```sql
-- Set up agent configuration and permissions
@sql/agent/08_create_ai_agent.sql
```

**Configures**:
- Permission grants for all services
- Agent metadata and monitoring
- Sample questions and test queries

**Time**: < 1 minute

---

## Part 3: Agent Configuration (Snowsight UI)

### Step 8: Create the Agent

1. In Snowsight, navigate to **AI & ML** → **Agents**
2. Click **+ Create Agent**
3. Select **Create this agent for Snowflake Intelligence**
4. Configure:
   - **Agent Object Name**: `LERETA_INTELLIGENCE_AGENT`
   - **Display Name**: `Lereta Intelligence Agent`
5. Click **Create**

### Step 9: Add Description

In the agent editor:

```
This agent provides comprehensive analytics for Lereta's tax monitoring, flood certification, 
and compliance operations. It combines structured data analytics (Cortex Analyst), unstructured 
document search (Cortex Search), and predictive machine learning to deliver actionable insights 
for property tax compliance, client retention, and portfolio risk management.
```

### Step 10: Configure Response Instructions

Click **Instructions** in the left pane and add:

   ```
   You are a specialized analytics assistant for Lereta, a tax and flood services provider 
for the financial services industry. You have access to three types of intelligence:

1. STRUCTURED DATA ANALYTICS (Cortex Analyst):
   - Use semantic views for metrics, KPIs, and analytical queries
   - Provide direct, numerical answers with minimal explanation
   - Focus on property tax monitoring, flood certifications, loans, subscriptions, revenue, and support

2. UNSTRUCTURED DOCUMENT SEARCH (Cortex Search):
   - Search 60,000+ documents for contextual information
   - Find similar cases, resolution procedures, and historical context
   - Cover support transcripts, tax disputes, and flood determination reports

3. PREDICTIVE ANALYTICS (ML Models):
   - Predict tax delinquency risk for properties
   - Identify clients at risk of cancellation
   - Classify loans by risk level (LOW/MEDIUM/HIGH)
   - Provide risk factors and actionable recommendations

RESPONSE GUIDELINES:
- Always identify your data source (Cortex Analyst, Search, or ML)
   - Keep responses under 3-4 sentences when possible
- Present numerical data in structured format
   - Don't speculate beyond available data
- Highlight critical issues prominently (delinquencies, high-risk, churn)
- For tax: Always check payment status and delinquency dates
- For flood: Always indicate if insurance is required
- For risk: Explain key factors driving the prediction
```

**Sample Questions** (click "+ Add a question" for each):
   - "How many properties have delinquent property taxes?"
- "Which properties require flood insurance in high-risk zones?"
- "Predict which properties will become delinquent on taxes"
- "Show me clients at risk of churning with low satisfaction"
- "Search support transcripts for tax payment processing issues"

---

## Part 4: Add Data Sources

### Step 11: Add Cortex Analyst Tools (Semantic Views)

Click **Tools** → Find **Cortex Analyst** → **+ Add**

#### Tool 1: Property Loan & Tax Intelligence

- **Name**: `Property_Loan_Tax_Intelligence`
- **Type**: Semantic view
- **Database**: `LERETA_INTELLIGENCE.ANALYTICS`
- **View**: `SV_PROPERTY_LOAN_TAX_INTELLIGENCE`
- **Warehouse**: `LERETA_WH`
- **Query timeout**: `60` seconds
- **Description**:
  ```
  Analyzes property tax monitoring, flood certifications, loan portfolios, and client 
   relationships. Use for questions about tax payment status, delinquencies, flood 
   insurance requirements, loan details, and property monitoring.
   ```

#### Tool 2: Subscription & Revenue Intelligence

- **Name**: `Subscription_Revenue_Intelligence`
- **Type**: Semantic view
- **Database**: `LERETA_INTELLIGENCE.ANALYTICS`
- **View**: `SV_SUBSCRIPTION_REVENUE_INTELLIGENCE`
- **Warehouse**: `LERETA_WH`
- **Query timeout**: `60` seconds
- **Description**:
   ```
   Analyzes service subscription health, revenue trends, transaction patterns, and product
  performance. Use for questions about subscription renewals, revenue analysis, service 
  adoption, and client lifetime value.
  ```

#### Tool 3: Client Support Intelligence

- **Name**: `Client_Support_Intelligence`
- **Type**: Semantic view
- **Database**: `LERETA_INTELLIGENCE.ANALYTICS`
- **View**: `SV_CLIENT_SUPPORT_INTELLIGENCE`
- **Warehouse**: `LERETA_WH`
- **Query timeout**: `60` seconds
- **Description**:
   ```
   Analyzes support ticket resolution, agent performance, and customer satisfaction.
   Use for questions about support efficiency, ticket trends, agent productivity,
   and client satisfaction metrics.
   ```

### Step 12: Add Cortex Search Services

Find **Cortex Search Services** → **+ Add**

#### Service 1: Support Transcripts Search

- **Name**: `Support_Transcripts_Search`
- **Description**:
   ```
   Search 25,000 customer support transcripts to find similar issues, resolution 
   procedures, and support best practices. Use for questions about tax payment issues, 
   flood certification processes, escrow questions, and common support scenarios.
   ```
- **Database**: `LERETA_INTELLIGENCE.RAW`
- **Service**: `SUPPORT_TRANSCRIPTS_SEARCH`
- **ID Column**: `transcript_id`
- **Title Column**: `transcript_text`

#### Service 2: Tax Dispute Documents Search

- **Name**: `Tax_Dispute_Documents_Search`
- **Description**:
   ```
   Search 15,000 tax dispute and appeal documents to find similar cases, successful 
   appeals, and resolution strategies. Use for questions about property tax assessments, 
   appeals, exemptions, and dispute outcomes.
   ```
- **Database**: `LERETA_INTELLIGENCE.RAW`
- **Service**: `TAX_DISPUTE_DOCUMENTS_SEARCH`
- **ID Column**: `document_id`
- **Title Column**: `document_text`

#### Service 3: Flood Determination Reports Search

- **Name**: `Flood_Determination_Reports_Search`
- **Description**:
   ```
   Search 20,000 flood determination reports for FEMA zone information, insurance 
   requirements, and determination procedures. Use for questions about flood zones, 
   insurance requirements, LOMA processes, and FEMA regulations.
   ```
- **Database**: `LERETA_INTELLIGENCE.RAW`
- **Service**: `FLOOD_DETERMINATION_REPORTS_SEARCH`
- **ID Column**: `report_id`
- **Title Column**: `report_text`

### Step 13: Configure Orchestration

Click **Orchestration** in the left pane:

- **Orchestration model**: Auto (or select `mistral-large2`)
- **Planning instructions**:
  ```
  For each query, determine the appropriate data source:
  
  (a) Structured metrics/KPIs → Use Cortex Analyst semantic views
  (b) Document content/context → Use Cortex Search services
  (c) Predictions/risk assessment → Reference ML model functions
  (d) Complex queries → Combine multiple sources with clear attribution
  
  For tax monitoring queries: Always check payment status and delinquency flags
  For flood certification queries: Highlight insurance requirements
  For property queries: Include both tax and flood status
  For ML predictions: Explain key risk factors
  ```

### Step 14: Set Up Access

Click **Access** in the left pane:

1. Click **+ Add role**
2. Select roles that should have access
3. Click **Save**

---

## Part 5: Testing

### Step 15: Test Structured Analytics

```
Q: "How many properties have delinquent property taxes?"
Expected: Cortex Analyst query on SV_PROPERTY_LOAN_TAX_INTELLIGENCE
```

```
Q: "What is the average client satisfaction rating?"
Expected: Cortex Analyst query on SV_CLIENT_SUPPORT_INTELLIGENCE
```

### Step 16: Test Document Search

```
Q: "Search support transcripts for tax payment processing issues"
Expected: Cortex Search on SUPPORT_TRANSCRIPTS_SEARCH
```

```
Q: "Find tax dispute documents about assessment appeals"
Expected: Cortex Search on TAX_DISPUTE_DOCUMENTS_SEARCH
```

### Step 17: Test ML Predictions

```
Q: "Which properties are predicted to become delinquent on taxes?"
Expected: Query V_TAX_DELINQUENCY_FEATURES with PREDICT_TAX_DELINQUENCY()
```

```
Q: "Show me clients at risk of churning"
Expected: Query V_CLIENT_CHURN_FEATURES with PREDICT_CLIENT_CHURN()
```

```
Q: "Classify all active loans by risk level"
Expected: Query V_LOAN_RISK_FEATURES with CLASSIFY_LOAN_RISK()
```

### Step 18: Test Hybrid Queries

```
Q: "Find high-risk loans with predicted tax delinquency and search for similar support cases"
Expected: Combines ML predictions with Cortex Search
```

---

## Part 6: Verification

### Verify All Components

```sql
-- Check semantic views
SHOW SEMANTIC VIEWS IN SCHEMA LERETA_INTELLIGENCE.ANALYTICS;

-- Check search services
SHOW CORTEX SEARCH SERVICES IN SCHEMA LERETA_INTELLIGENCE.RAW;

-- Check ML functions
SHOW FUNCTIONS IN SCHEMA LERETA_INTELLIGENCE.ANALYTICS 
WHERE FUNCTION_NAME LIKE 'PREDICT_%' OR FUNCTION_NAME LIKE 'CLASSIFY_%';

-- Test search service
SELECT PARSE_JSON(
  SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
      'LERETA_INTELLIGENCE.RAW.SUPPORT_TRANSCRIPTS_SEARCH',
      '{"query": "tax delinquency help", "limit":5}'
  )
)['results'] as results;

-- Test ML prediction
SELECT 
    tax_record_id,
    PREDICT_TAX_DELINQUENCY(
        tax_record_id, property_type, assessed_value, flood_zone,
        tax_amount, tax_rate, jurisdiction_type, penalty_amount,
        days_since_due, days_since_last_payment, loan_type, loan_amount,
        escrow_account, loan_status, client_type, service_quality_score,
        client_status, has_unpaid_taxes, current_paid_status
    ) AS prediction
FROM V_TAX_DELINQUENCY_FEATURES
LIMIT 5;
```

### Agent Configuration Summary

```sql
-- View complete configuration
SELECT * FROM AGENT_CONFIGURATION_SUMMARY;

-- View sample questions
SELECT * FROM AGENT_SAMPLE_QUESTIONS;
```

---

## Troubleshooting

### Issue: Semantic views not found

```sql
-- Verify views exist
SHOW SEMANTIC VIEWS IN SCHEMA LERETA_INTELLIGENCE.ANALYTICS;

-- Check permissions
SHOW GRANTS ON SEMANTIC VIEW SV_PROPERTY_LOAN_TAX_INTELLIGENCE;
```

### Issue: Search returns no results

```sql
-- Check service status
SHOW CORTEX SEARCH SERVICES IN SCHEMA RAW;

-- Verify data
SELECT COUNT(*) FROM RAW.SUPPORT_TRANSCRIPTS;

-- Check change tracking
SHOW TABLES LIKE 'SUPPORT_TRANSCRIPTS';
```

### Issue: ML predictions fail

```sql
-- Check models in registry
SHOW MODELS IN SCHEMA ANALYTICS;

-- Check functions exist
SHOW FUNCTIONS IN SCHEMA ANALYTICS WHERE FUNCTION_NAME LIKE 'PREDICT_%';

-- Test feature view
SELECT * FROM V_TAX_DELINQUENCY_FEATURES LIMIT 1;
```

### Issue: Slow performance

**Solutions**:
- Increase warehouse size (MEDIUM or LARGE)
- Add filters on date columns
- Review query execution plan
- Check ML model loading time

---

## Success Checklist

✅ All 8 SQL scripts executed successfully  
✅ 3.8M+ records generated  
✅ 3 semantic views created  
✅ 3 Cortex Search services indexed (60K documents)  
✅ 3 ML models trained and registered  
✅ 3 ML UDFs deployed  
✅ Agent created in Snowsight  
✅ All data sources configured  
✅ All test questions work  
✅ Hybrid queries function correctly  

---

## Performance Benchmarks

| Component | Time | Records |
|-----------|------|---------|
| Database Setup | < 1 min | - |
| Data Generation | 10-20 min | 3.8M |
| Analytics Layer | < 1 min | 11 views |
| Search Indexing | 5-10 min | 60K docs |
| ML Training | 15-30 min | 3 models |
| ML Deployment | < 1 min | 3 UDFs |
| Agent Config | 5-10 min | UI setup |
| **Total** | **45-60 min** | **Complete** |

---

## Additional Resources

- **Sample Questions**: See `questions.md`
- **Architecture Diagrams**: `architecture-overview.svg`, `ml-pipeline-flow.svg`
- **Snowflake Documentation**: [Cortex Intelligence](https://docs.snowflake.com/en/user-guide/snowflake-cortex)

---

**Setup Complete!** Your Lereta Intelligence Agent is ready for production use.
